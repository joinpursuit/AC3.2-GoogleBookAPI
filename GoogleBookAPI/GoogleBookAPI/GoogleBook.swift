//
//  GoogleBook.swift
//  GoogleBookAPI
//
//  Created by Madushani Lekam Wasam Liyanage on 12/4/16.
//  Copyright © 2016 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import Foundation

enum GoogleBooksModelParseError: Error {
    case results(json: Any)
}

class GoogleBook {
    
    let title: String
    let id: String
    let thumbnail: String
    let description: String
    let fullImage: String
    
    init(title: String, id: String, thumbnail: String, description: String, fullImage: String) {
        self.title = title
        self.id = id
        self.thumbnail = thumbnail
        self.description = description
        self.fullImage = fullImage
    }
    
    convenience init?(from dictionary: [String:AnyObject]) throws {
        
        var fullImageString = ""
        
        if let bookId = dictionary["id"] as? String,
            let infoDict = dictionary["volumeInfo"] as? [String:Any],
            let bookTitle = infoDict["title"] as? String,
            let imageLinksDict = infoDict["imageLinks"] as? [String:Any],
            let thumbnailString = imageLinksDict["thumbnail"] as? String,
            let description = infoDict["description"] as? String {
            
            if let fullImage = imageLinksDict["extraLarge"] as? String {
                fullImageString = fullImage
            }
            else if let fullImage = imageLinksDict["large"] as? String {
                fullImageString = fullImage
            }
            else if let fullImage = imageLinksDict["small"] as? String {
                fullImageString = fullImage
            }
            else if let fullImage = imageLinksDict["thumbnail"] as? String {
                fullImageString = fullImage
            }
            
            self.init(title: bookTitle, id: bookId, thumbnail: thumbnailString, description: description, fullImage: fullImageString)
        }
            
        else {
            return nil
        }
        
    }
    
    static func getGoogleBook(from data: Data) -> GoogleBook? {
        var googleBookToReturn: GoogleBook?
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response: [String:AnyObject] = jsonData as? [String:AnyObject]
                
                else {
                    throw GoogleBooksModelParseError.results(json: jsonData)
            }
            
            
            if let book = try GoogleBook(from: response) {
                googleBookToReturn = book
            }
            
            
            
        }
            
        catch let GoogleBooksModelParseError.results(json: json)  {
            print("Error encountered with parsing 'records' key for object: \(json)")
        }
            
        catch {
            print("Unknown parsing error")
        }
        
        return googleBookToReturn
    }
    
    
    static func getGoogleBooks(from data: Data) -> [GoogleBook]? {
        var googleBooksToReturn: [GoogleBook]? = []
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            
            guard let response: [String:AnyObject] = jsonData as? [String:AnyObject],
                let bookArray: [[String : AnyObject]] = response["items"] as? [[String:AnyObject]]
                
                else {
                    throw GoogleBooksModelParseError.results(json: jsonData)
            }
            
            for bookDict in bookArray {
                
                if let book = try GoogleBook(from: bookDict) {
                    googleBooksToReturn?.append(book)
                }
                
            }
            
        }
            
        catch let GoogleBooksModelParseError.results(json: json)  {
            print("Error encountered with parsing 'records' key for object: \(json)")
        }
            
        catch {
            print("Unknown parsing error")
        }
        
        return googleBooksToReturn
    }
    
}
