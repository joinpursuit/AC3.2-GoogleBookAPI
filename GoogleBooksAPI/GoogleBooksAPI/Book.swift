//
//  Book.swift
//  GoogleBooksAPI
//
//  Created by Harichandan Singh on 12/4/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import Foundation

enum BookErrors: Error {
    case id, volumeInfo, title, subtitle, authors, description, imageLinks, thumbnail
}

class Book {
    //MARK: - Properties
    let id: String
    let title: String
    let subtitle: String
    let authors: [String]
    let description: String
    let imageLinks: [String: String]
    let thumbnail: String
    
    //MARK: - Initializers
    init(id: String, title: String, subtitle: String, authors: [String], description: String, imageLinks: [String: String], thumbnail: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.authors = authors
        self.description = description
        self.imageLinks = imageLinks
        self.thumbnail = thumbnail
    }
    
    //MARK: - Methods
    static func createBooks(from data: Data) -> [Book]?{
        var books: [Book] = []
        
        do {
            let jsonData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            
            if let bookData = jsonData {
                guard let items = bookData["items"] as? [[String: Any]] else { return nil }
                
                for dict in items {
                    guard let id = dict["id"] as? String else { throw BookErrors.id }
                    guard let volumeInfo = dict["volumeInfo"] as? [String: Any] else { throw BookErrors.volumeInfo }
                    guard let title = volumeInfo["title"] as? String else { throw BookErrors.title }
                    let subtitle = volumeInfo["subtitle"] as? String ?? ""
                    let authors = volumeInfo["authors"] as? [String] ?? []
                    let description = volumeInfo["description"] as? String ?? ""
                    guard let imageLinks = volumeInfo["imageLinks"] as? [String: String] else { throw BookErrors.imageLinks }
                    guard let thumbnail = imageLinks["thumbnail"] else { throw BookErrors.thumbnail }
                    
                    let book: Book = Book(id: id,
                                          title: title,
                                          subtitle: subtitle,
                                          authors: authors,
                                          description: description,
                                          imageLinks: imageLinks,
                                          thumbnail: thumbnail)
                    books.append(book)
                }
            }
        }
        catch BookErrors.id {
            print("Error finding the id key.")
        }
        catch BookErrors.volumeInfo {
            print("Error finding the volumeInfo key.")
        }
        catch BookErrors.title {
            print("Error finding the title key.")
        }
        catch BookErrors.subtitle {
            print("Error finding the subtitle key.")
        }
        catch BookErrors.authors {
            print("Error finding the authors key.")
        }
        catch BookErrors.description {
            print("Error finding the description key.")
        }
        catch BookErrors.imageLinks {
            print("Error finding the imageLinks key.")
        }
        catch BookErrors.thumbnail {
            print("Error finding the thumbnail key.")
        }
        catch {
            print("There is an unidentified error.")
        }
        return books
    }
    
}
