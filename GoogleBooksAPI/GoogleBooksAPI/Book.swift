//
//  Book.swift
//  GoogleBooksAPI
//
//  Created by Marcel Chaucer on 12/3/16.
//  Copyright © 2016 Marcel Chaucer. All rights reserved.
//

import Foundation

class Book {
    let title: String
    let subtitle: String
    let publisher: String
    let description: String
    let author: String
    let id: String
    let thumbNail: URL
    let thumbNailString: String
    
    init?(from dict:[String:Any]) {
        if  let volumeInfo = dict["volumeInfo"] as? [String: Any],
            let title = volumeInfo["title"] as? String,
            let authorArray = volumeInfo["authors"] as? [String],
            let subtitle = volumeInfo["subtitle"] as? String,
            let publisher = volumeInfo["publisher"] as? String,
            let description = volumeInfo["description"] as? String,
            let id = dict["id"] as? String,
            let allImages = volumeInfo["imageLinks"] as? [String: Any],
            let thumbNailString = allImages["smallThumbnail"] as? String,
            let thumbNail = URL(string: thumbNailString) {
            let author = authorArray[0]
            self.title = title
            self.subtitle = subtitle
            self.publisher = publisher
            self.description = description
            self.id = id
            self.thumbNail = thumbNail
            self.author = author
            self.thumbNailString = thumbNailString
        }
        else {
            return nil
        }
    }
    
    
    static func parseBooks(from arr:[[String:Any]]) -> [Book] {
        var books = [Book]()
        for bookDict in arr {
            if let book = Book(from: bookDict) {
                books.append(book)
            }
        }
        return books
    }
}
