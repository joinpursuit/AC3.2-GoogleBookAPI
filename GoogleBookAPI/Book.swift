//
//  Book.swift
//  GoogleBookAPI
//
//  Created by Ana Ma on 12/3/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

enum BookModelParseError: Error {
    case dictionary
    case items
    case item
    case kind
    case id
    case selfLink
    case title
    case authors
    case subtitle
    case thumbnail
    case imageLinks
    case description
    case previewLink
    case volumeInfo
    case extraLargeimage
}

class Book {
    var kind: String
    var id : String
    var selfLink : String
    var title: String
    var authors: [String]? = [""]
    var subtitle: String? = String()
    var previewLink: String = String()
    var description: String? = String()
    var smallThumbnail: String? = String()
    var thumbnail: String? = String()
    var smallImage: String? = String()
    var mediumImage: String? = String()
    var largeImage: String? = String()
    var extraLargeImage: String? = String()
    
    required init(kind: String, id: String, selfLink: String, title: String, previewLink: String, smallThumbnail: String?, thumbnail: String?) {
        self.kind = kind
        self.id = id
        self.selfLink = selfLink
        self.title = title
        self.previewLink = previewLink
        self.thumbnail = thumbnail
        self.smallThumbnail = smallThumbnail
    }

    convenience init? (kind: String, id: String, selfLink: String, title: String, authors: [String]?, subtitle: String?, previewLink: String, description: String?, smallThumbnail: String?, thumbnail: String?, smallImage: String?, mediumImage: String?, largeImage: String?, extraLargeImage: String?) {
        self.init(kind: kind, id: id, selfLink: selfLink, title: title, previewLink: previewLink, smallThumbnail: smallThumbnail, thumbnail: thumbnail)
        self.authors = authors
        self.subtitle = subtitle
        self.description = description
        self.smallImage = smallImage
        self.mediumImage = mediumImage
        self.largeImage = largeImage
        self.extraLargeImage = extraLargeImage
    }
    
    static func getBooks(data: Data) -> [Book]? {
        var booksArrToReturn: [Book] = []
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let dictionary = json as? [String: AnyObject] else {
                throw BookModelParseError.dictionary
            }
            
            guard let items = dictionary["items"] as? [[String: AnyObject]] else {
                throw BookModelParseError.items
            }
            
            try items.forEach({ (item) in
                guard let kind = item["kind"] as? String else {
                    throw BookModelParseError.kind
                }
                guard let id = item["id"] as? String else {
                    throw BookModelParseError.id
                }
                guard let selfLink = item["selfLink"] as? String else {
                    throw BookModelParseError.selfLink
                }
                guard let valumeInfo = item["volumeInfo"] as? [String: AnyObject] else {
                    throw BookModelParseError.volumeInfo
                }
                guard let title = valumeInfo["title"] as? String  else {
                    throw BookModelParseError.title
                }
                guard let previewLink = valumeInfo["previewLink"] as? String else {
                    throw BookModelParseError.previewLink
                }
                guard let imageLinks = valumeInfo["imageLinks"] as? [String: AnyObject] else {
                    throw BookModelParseError.imageLinks
                }
                let thumbnail = imageLinks["thumbnail"] as? String
                let smallThumbnail = imageLinks["smallThumbnail"] as? String

                let book = Book(kind: kind, id: id, selfLink: selfLink, title: title, previewLink: previewLink, smallThumbnail: smallThumbnail, thumbnail: thumbnail)
//                let book = Book(kind: kind, id: id, selfLink: selfLink, title: title, authors: authors ?? [""], subtitle: subtitle ?? "", thumbnail: thumbnail, image: "", description: description ?? "", previewLink: previewLink)
                booksArrToReturn.append(book)
                
            })
        }
        catch BookModelParseError.kind {
            print("Error in Parsing Json in kind")
        }
        catch BookModelParseError.id {
            print("Error in Parsing Json in id")
        }
        catch BookModelParseError.selfLink {
            print("Error in Parsing Json in selfLink")
        }
        catch BookModelParseError.title {
            print("Error in Parsing Json in title")
        }
        catch BookModelParseError.thumbnail {
            print("Error in Parsing Json in thumbnail")
        }
        catch BookModelParseError.previewLink {
            print("Error in Parsing Json in previewLink")
        }
        catch BookModelParseError.volumeInfo {
            print("Error in Parsing Json in volumeInfo")
        }
        catch {
            print(Error.self)
        }
        return booksArrToReturn
    }
    
    static func getBook(data: Data) -> Book? {
        do {
            let json = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let dictionary = json as? [String: AnyObject] else {
                throw BookModelParseError.dictionary
            }
            guard let kind = dictionary["kind"] as? String else {
                throw BookModelParseError.kind
            }
            guard let id = dictionary["id"] as? String else {
                throw BookModelParseError.id
            }
            guard let selfLink = dictionary["selfLink"] as? String else {
                throw BookModelParseError.selfLink
            }
            guard let valumeInfo = dictionary["volumeInfo"] as? [String: AnyObject] else {
                throw BookModelParseError.volumeInfo
            }
            guard let title = valumeInfo["title"] as? String  else {
                throw BookModelParseError.title
            }
            guard let previewLink = valumeInfo["previewLink"] as? String else {
                throw BookModelParseError.previewLink
            }
            guard let imageLinks = valumeInfo["imageLinks"] as? [String: AnyObject] else {
                throw BookModelParseError.imageLinks
            }
            let authors = valumeInfo["authors"] as? [String]
            let subtitle = valumeInfo["subtitle"] as? String
            let description = valumeInfo["description"] as? String
            let smallThumbnail = valumeInfo["smallThumbnail"] as? String
            let thumbnail = imageLinks["thumbnail"] as? String
            let smallImage = valumeInfo["smallImage"] as? String
            let mediumImage = valumeInfo["mediumImage"] as? String
            let largeImage = valumeInfo["largeImage"] as? String
            let extraLargeImage = imageLinks["extraLarge"] as? String
            
            let book = Book(kind: kind, id: id, selfLink: selfLink, title: title, authors: authors, subtitle: subtitle, previewLink: previewLink, description: description, smallThumbnail: smallThumbnail, thumbnail: thumbnail, smallImage: smallImage, mediumImage: mediumImage, largeImage: largeImage, extraLargeImage: extraLargeImage)
            
//            let book = Book(kind: kind, id: id, selfLink: selfLink, title: title, authors: authors ?? [], subtitle: subtitle ?? "", thumbnail: thumbnail, image: extraLargeImage ?? "" , description: description ?? "", previewLink: previewLink)
            return book
        }
        catch BookModelParseError.kind {
            print("Error in Parsing Json in kind")
        }
        catch BookModelParseError.id {
            print("Error in Parsing Json in id")
        }
        catch BookModelParseError.selfLink {
            print("Error in Parsing Json in selfLink")
        }
        catch BookModelParseError.title {
            print("Error in Parsing Json in title")
        }
        catch BookModelParseError.authors {
            print("Error in Parsing Json in authors")
        }
        catch BookModelParseError.subtitle {
            print("Error in Parsing Json in subtitle")
        }
        catch BookModelParseError.thumbnail {
            print("Error in Parsing Json in thumbnail")
        }
        catch BookModelParseError.description {
            print("Error in Parsing Json in description")
        }
        catch BookModelParseError.previewLink {
            print("Error in Parsing Json in previewLink")
        }
        catch BookModelParseError.volumeInfo {
            print("Error in Parsing Json in volumeInfo")
        }
        catch {
            print(Error.self)
        }
        return nil
    }
    
}
/*
 {
 kind": "books#volume",
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
 }
 */
