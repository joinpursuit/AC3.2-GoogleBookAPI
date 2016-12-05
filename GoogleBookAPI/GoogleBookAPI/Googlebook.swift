//
//  Googlebook.swift
//  GoogleBookAPI
//
//  Created by Annie Tung on 12/4/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import Foundation

class Googlebook {
    let id: String
    let title: String
    let authors: String
    let subtitle: String?
    let smallThumbnail: String?
    let thumbnail: String?
    var extraLargeImage: String?
    
    init(id: String, title: String, subtitle: String?, authors: [String], smallThumbnail: String?, thumbnail: String?) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.smallThumbnail = smallThumbnail
        self.thumbnail = thumbnail
        
        var allAuthors = ""
        for author in authors {
            allAuthors.append("\(author) ")
        }
        self.authors = allAuthors
    }
    // parse the dict and apply the necessary properties to self
    convenience init? (dictionary: [String:Any]) {
        guard
            let id = dictionary["id"] as? String,
            let volumeInfo = dictionary["volumeInfo"] as? [String:Any],
            let title = volumeInfo["title"] as? String,
            let authors = volumeInfo["authors"] as? [String] else { return nil }
        
        let subtitle = volumeInfo["subtitle"] as? String
        let imageLinks = volumeInfo["imageLinks"] as? [String:Any]
        let smallThumbnail = imageLinks?["smallThumbnail"] as? String
        let thumbnail = imageLinks?["thumbnail"] as? String
        
        self.init(id: id, title: title, subtitle: subtitle, authors: authors, smallThumbnail: smallThumbnail, thumbnail: thumbnail)
    }
    
    // this class function takes in data and return an array of objects, doesn't need to be initializes
    class func parse(jsonData: Data) -> [Googlebook]? {
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any]
            guard let items = json?["items"] as? [[String:Any]] else { return nil }
            var googlebookToReturn = [Googlebook]()
            // loop through the array and get the objects
            for bookDict in items {
                if let bookObj = Googlebook(dictionary: bookDict) {
                    googlebookToReturn.append(bookObj)
                }
            }
            return googlebookToReturn
        } catch {
            print("Error parsing data: \(error)")
            return nil
        }
    }
    class func parseXLImageFrom(jsonData: Data) -> String? {
        do {
            let json = try JSONSerialization.jsonObject(with: jsonData, options: []) as? [String:Any]
            guard
                let volumeInfo = json?["volumeInfo"] as? [String:Any],
                let imageLinks = volumeInfo["imageLinks"] as? [String:Any],
                let extraLargeImageStr = imageLinks["extraLarge"] as? String else { return nil }
            return extraLargeImageStr
        } catch {
            print("Error parsing large image: \(error)")
            return nil
        }
    }
}
