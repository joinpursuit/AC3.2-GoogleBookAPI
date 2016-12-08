//
//  Book.swift
//  GoogleBookAPI
//
//  Created by Eashir Arafat on 12/4/16.
//  Copyright © 2016 Evan. All rights reserved.
//

import Foundation

enum bookErrors: Error {
    case response, authors, id, thumbnail, volumeInfoDict, title ,imageLinksDict
}

class Book {
    let authors: [String]
    let id: String
    let thumbnail: String
    let title: String
    
    init(authors: [String], id: String, thumbnail: String, title: String) {
        self.authors = authors
        self.id = id
        self.thumbnail = thumbnail
        self.title = title
    }
    
    static func getBooks(from data: Data) -> [Book]? {
        var books: [Book]? = []
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response = jsonData as? [String: Any],
                  let items = response["items"] as? [[String : Any]]
                else { throw bookErrors.response }
            
            for book in items {
                guard let id = book["id"] as? String
                    else { throw bookErrors.id }
                
                guard let volumeInfo = book["volumeInfo"] as? [String: Any]
                    else { throw bookErrors.volumeInfoDict }
                
                guard let title = volumeInfo["title"] as? String
                    else { throw bookErrors.title }
                
                guard let authors = volumeInfo["authors"] as? [String]
                    else { let authors = "Unknown"
                        break }
                
                guard let imageLinks = volumeInfo["imageLinks"] as? [String: Any]
                    else { throw bookErrors.imageLinksDict }
                
                guard let thumbnail = imageLinks["smallThumbnail"] as? String
                    else { throw bookErrors.thumbnail }
                
                let validBook = Book(authors: authors, id: id, thumbnail: thumbnail, title: title)
                
                books?.append(validBook)
                
                /* jsonDict -> Items Array of Dicts -> volumeInfoDict -> authorsArray
                                    id                      title           authors
                                                    -> volumeInfoDict -> imageLinksDict
                                                                           thumbnail
                 */
            }
            
            return books
        }
            
        catch {
            print("Error \(error)")
        }
        
        return nil
    }   
}
