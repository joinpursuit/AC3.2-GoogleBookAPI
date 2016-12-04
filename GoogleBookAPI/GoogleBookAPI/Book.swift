//
//  Book.swift
//  GoogleBookAPI
//
//  Created by Tong Lin on 12/4/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation

class Book{
    let id: String
    let selfLink: String
    let title: String
    let subtitle: String
    let author: String
    let publishedData: String
    let description: String
    let ISBN_10: String
    let ISBN_13: String
    let thumbnail: String
    
    init(id: String, selfLink: String, title: String, subtitle: String, author: String, publishedData: String, description: String, ISBN_10: String, ISBN_13: String, thumbnail: String) {
        self.id = id
        self.selfLink = selfLink
        self.title = title
        self.subtitle = subtitle
        self.author = author
        self.publishedData = publishedData
        self.description = description
        self.ISBN_10 = ISBN_10
        self.ISBN_13 = ISBN_13
        self.thumbnail = thumbnail
    }
    
    static func getBooks(data: Data) -> [Book]?{
        do {
            var allBooks: [Book] = []
            let json: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let myData: [String: AnyObject] = json as? [String: AnyObject],
                let items: [AnyObject] = myData["items"] as? [AnyObject] else { return nil }
            
            items.forEach{ (item) in
                guard let book: [String: Any] = item as? [String: Any] else { return }
                
                guard let id: String = book["id"] as? String,
                    let selfLink: String = book["selfLink"] as? String,
                    let title: String = book["title"] as? String,
                    let subtitle: String = book["subtitle"] as? String,
                    let author: String = book["author"] as? String,
                    let publishedData: String = book["publishedDate"] as? String,
                    let description: String = book["description"] as? String,
                    let industryIdentifiers: [[String: Any]] = book["industryIdentifiers"] as? [[String: Any]],
                    let ISBN_10: String = industryIdentifiers[0]["identifier"] as? String,
                    let ISBN_13: String = industryIdentifiers[1]["identifier"] as? String,
                    let images: [String: Any] = book["imageLinks"] as? [String: Any],
                    let thumbnail: String = images["thumbnail"] as? String else{ return }
                
                allBooks.append(Book(id: id, selfLink: selfLink, title: title, subtitle: subtitle, author: author, publishedData: publishedData, description: description, ISBN_10: ISBN_10, ISBN_13: ISBN_13, thumbnail: thumbnail))
            }
            
            return allBooks
        } catch{
            print("error parsing data to Book object: \(error)")
        }
        return nil
    }
    
/*    {"kind": "books#volume",
    "id": "cSoVd-o8PmoC",
    "etag": "JI/72PJknNM",
    "selfLink": "https://www.googleapis.com/books/v1/volumes/cSoVd-o8PmoC",
    "volumeInfo": {
    "title": "Banana",
    "subtitle": "The Fate of the Fruit that Changed the World",
    "authors": [
    "Dan Koeppel"
    ],
    "publisher": "Penguin",
    "publishedDate": "2008",
    "description": "From its early beginnings in Southeast Asia, to the machinations of the United Fruit Company in Costa Rica and Central America, the banana's history and its fate as a victim of fungus are explored.",
    "industryIdentifiers": [
    {
    "type": "ISBN_10",
    "identifier": "1594630380"
    },
    {
    "type": "ISBN_13",
    "identifier": "9781594630385"
    }
    ],
    "readingModes": {
    "text": false,
    "image": false
    },
    "pageCount": 281,
    "printType": "BOOK",
    "categories": [
    "Business & Economics"
    ],
    "averageRating": 3.5,
    "ratingsCount": 14,
    "maturityRating": "NOT_MATURE",
    "allowAnonLogging": false,
    "contentVersion": "preview-1.0.0",
    "imageLinks": {
    "smallThumbnail": "http://books.google.com/books/content?id=cSoVd-o8PmoC&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api",
    "thumbnail": "http://books.google.com/books/content?id=cSoVd-o8PmoC&printsec=frontcover&img=1&zoom=1&edge=curl&source=gbs_api"
    },
    "language": "en",
    "previewLink": "http://books.google.com/books?id=cSoVd-o8PmoC&printsec=frontcover&dq=banana&hl=&cd=1&source=gbs_api",
    "infoLink": "http://books.google.com/books?id=cSoVd-o8PmoC&dq=banana&hl=&source=gbs_api",
    "canonicalVolumeLink": "http://books.google.com/books/about/Banana.html?hl=&id=cSoVd-o8PmoC"
    },
    "saleInfo": {
    "country": "US",
    "saleability": "NOT_FOR_SALE",
    "isEbook": false
    },
    "accessInfo": {
    "country": "US",
    "viewability": "PARTIAL",
    "embeddable": true,
    "publicDomain": false,
    "textToSpeechPermission": "ALLOWED_FOR_ACCESSIBILITY",
    "epub": {
    "isAvailable": false
    },
    "pdf": {
    "isAvailable": false
    },
    "webReaderLink": "http://books.google.com/books/reader?id=cSoVd-o8PmoC&hl=&printsec=frontcover&output=reader&source=gbs_api",
    "accessViewStatus": "SAMPLE",
    "quoteSharingAllowed": false
    },
    "searchInfo": {
    "textSnippet": "From its early beginnings in Southeast Asia, to the machinations of the United Fruit Company in Costa Rica and Central America, the banana&#39;s history and its fate as a victim of fungus are explored."
    }*/
}
