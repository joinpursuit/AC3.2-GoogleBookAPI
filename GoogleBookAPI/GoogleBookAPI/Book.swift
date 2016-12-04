//
//  Book.swift
//  GoogleBookAPI
//
//  Created by Victor Zhong on 12/4/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import Foundation

enum BookModelParseError: Error {
    case results, id, volume,title, subtitle, authors, thumbnail, image
}

class Book {
    let id:         String
    let title:      String
    let subtitle:   String?
    let authors:    [String]
    let thumbnail:  String?
    let image:      [String : AnyObject]?
    
    init(
        id:         String,
        title:      String,
        subtitle:   String?,
        authors:    [String],
        thumbnail:  String?,
        image:      [String : AnyObject]?
        ) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.authors = authors
        self.thumbnail = thumbnail
        self.image = image
    }
    
    convenience init?(from dictionary: [String:AnyObject]) throws {
        guard let id = dictionary["id"] as? String else { throw
            BookModelParseError.id }
        guard let volume = dictionary["volumeInfo"] as? [String : AnyObject] else { throw
            BookModelParseError.volume }
        guard let title = volume["title"] as? String else { throw BookModelParseError.title }
        var sub = ""
        if let subtitle = volume["subtitle"] as? String {
            sub = subtitle
        }
        var auth = [String]()
        if let authors = volume["authors"] as? [String] {
            auth = authors
        }
        guard let image = volume["imageLinks"] as? [String : AnyObject] else { throw BookModelParseError.image }
        guard let thumbnail = image["smallThumbnail"] as? String else { throw BookModelParseError.thumbnail }
        
        self.init(id: id,
                  title: title,
                  subtitle: sub,
                  authors: auth,
                  thumbnail: thumbnail,
                  image: image)
    }
    
    static func getBooks(from data: Data) -> [Book]? {
        var booksToReturn: [Book]? = []
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response: [String : AnyObject] = jsonData as? [String : AnyObject],
                let books = response["items"] as? [[String: AnyObject]] else {
                    throw BookModelParseError.results
            }
            
            for book in books {
                if let bookDict = try Book(from: book) {
                    booksToReturn?.append(bookDict)
                }
            }
        }
        catch {
            print("Parsing Error: \(error)")
        }
        return booksToReturn
    }
    
    static func getOneBook(from data: Data) -> Book? {
        var bookToReturn: Book?
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response: [String : AnyObject] = jsonData as? [String : AnyObject] else {
                    throw BookModelParseError.results
            }
            
          
            if let bookDict = try Book(from: response) {
                bookToReturn = bookDict
            }
        }
        catch {
            print("Parsing Error: \(error)")
        }
        return bookToReturn
    }
}


/*
 "items": [
 {
 "kind": "books#volume",
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
 }
 },
 */
