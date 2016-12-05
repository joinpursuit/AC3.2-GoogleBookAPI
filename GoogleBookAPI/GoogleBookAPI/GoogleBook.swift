//
//  GoogleBook.swift
//  GoogleBookAPI
//
//  Created by Edward Anchundia on 12/4/16.
//  Copyright © 2016 Edward Anchundia. All rights reserved.
//

import Foundation

class GoogleBook {
    let id: String
    let title: String
    let subtitle: String
    let author: [String]
    let thumbnail: String
    
    typealias jsonStandard = [String: Any]
    
    init(id: String, title: String, subtitle: String, author: [String], thumbnail: String) {
        self.id = id
        self.title = title
        self.subtitle = subtitle
        self.author = author
        self.thumbnail = thumbnail
    }
    
    static func getGoogleBook(from data: Data) -> [GoogleBook]? {
        var dataToReturn: [GoogleBook]? = []
        
        do {
            let jsonData: Any = try JSONSerialization.jsonObject(with: data, options: [])
            guard let fullDict: jsonStandard = jsonData as? jsonStandard,
                let bookItem = fullDict["items"] as? [jsonStandard] else {
                    return nil
            }
            bookItem.forEach({ dataObject in
                guard let id = dataObject["id"] as? String,
                    let volumeInfo = dataObject["volumeInfo"] as? jsonStandard,
                    let title = volumeInfo["title"] as? String,
                    let subtitle = volumeInfo["subtitle"] as? String,
                    let authorArr = volumeInfo["authors"] as? [String],
                    let imageLinks = volumeInfo["imageLinks"] as? jsonStandard,
                    let thumbnail = imageLinks["thumbnail"] as? String else {
                    return
                }
                let detail = GoogleBook(id: id, title: title, subtitle: subtitle, author: authorArr, thumbnail: thumbnail)
                dataToReturn?.append(detail)
            })
            return dataToReturn
        } catch {
            print("Unknown parsing error")
        }
        return nil
    }
}
