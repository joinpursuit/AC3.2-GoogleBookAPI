//
//  Book.swift
//  GoogleBookAPI
//
//  Created by Eric Chang on 12/4/16.
//  Copyright © 2016 Eric Chang. All rights reserved.
//

import Foundation

enum BookParseError: Error {
    case items
}

class Book {
    internal let title: String
    internal let id: String
    internal let thumbnail: [String: String]
    internal let authors: [String]
    
    init(title: String, id: String, thumbnail: [String: String], authors: [String]) {
        self.title = title
        self.id = id
        self.thumbnail = thumbnail
        self.authors = authors
    }
    
    static func objects(from data: Data) -> [Book]? {
        var books: [Book]? = []
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response = jsonData as? [String: Any],
                let items = response["items"] as? [[String: Any]]
                else { throw BookParseError.items }
            
            for each in items {
                
                if let volume = each["volumeInfo"] as? [String: AnyObject],
                    let title = volume["title"] as? String,
                    let authors = volume["authors"] as? [String],
                    let id = each["id"] as? String,
                    let images = volume["imageLinks"] as? [String: String] {
                
                let validBook = Book(title: title,
                                    id: id,
                                    thumbnail: images,
                                    authors: authors)
                
                books?.append(validBook)
                }
            }
            return books
        }
        catch {
            print("error: \(error)")
        }
        
        return nil
    }
}
