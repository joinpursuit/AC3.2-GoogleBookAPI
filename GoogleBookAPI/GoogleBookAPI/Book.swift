//
//  Book.swift
//  GoogleBookAPI
//
//  Created by Erica Y Stevens on 12/3/16.
//  Copyright © 2016 Erica Stevens. All rights reserved.
//

import Foundation

class Book {
    var authors: [String]
    var title: String
    var description: String
    var imageLinks: [String: String]
    var id: String

    init?(from dict: [String:Any]) {
        guard let authors = dict["authors"] as? [String],
            let title = dict["title"] as? String,
            let description = dict["description"] as? String,
            let imageLinks = dict["imageLinks"] as? [String:String],
            let id = dict["id"] as? String else { return nil }
        self.authors = authors
        self.title = title
        self.description = description
        self.imageLinks = imageLinks
        self.id = id
    }
    
    static func parseBooks(from arr: [[String:Any]]) -> [Book] {
        var books = [Book]()
        
        for bookDict in arr {
            if var volumeInfo = bookDict["volumeInfo"] as? [String:Any],
                let bookID = bookDict["id"] as? String{
                volumeInfo["id"] = bookID
                if let book = Book(from: volumeInfo) {
                        books.append(book)
                }
            }
        }
        return books
    }
    
}
