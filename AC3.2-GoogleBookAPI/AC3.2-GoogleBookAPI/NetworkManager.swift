//
//  NetworkManager.swift
//  AC3.2-GoogleBookAPI
//
//  Created by Tom Seymour on 12/4/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON


/*
 let id: String
 let thumb: String
 let title: String
 let subtitile: String
 let author: [String]
 let description: String
 */
class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    
    func getBooks(endpoint: String, completionHandler: @escaping ([Book]?) -> Void) {
        Alamofire.request(endpoint).validate().responseJSON { (response) in
            
            var theBooks: [Book] = []
            let json = JSON(response.result.value)
            guard let items = json["items"].array else { return }
            
            for item in items {
                guard let title = item["volumeInfo"]["title"].string,
                    let authors = item["volumeInfo"]["authors"].array,
                    let id = item["id"].string,
                    let thumb = item["volumeInfo"]["imageLinks"]["smallThumbnail"].string,
                    let description = item["volumeInfo"]["description"].string else { continue }
                
                let subtitle = item["volumeInfo"]["subtitle"].string ?? ""
                let authorArr = authors.map { $0.stringValue }
                
                let thisBook = Book(id: id, thumb: thumb, title: title, subtitle: subtitle, authors: authorArr, description: description)
                theBooks.append(thisBook)
            }
            completionHandler(theBooks)
        }
    }
    
    func getFullImage(endpoint: String, completionHandler: @escaping (String?) -> Void) {
        Alamofire.request(endpoint).validate().responseJSON { (response) in
            let json = JSON(response.result.value)
            guard let fullImageString = json["volumeInfo"]["imageLinks"]["extraLarge"].string else { return }
            completionHandler(fullImageString)
        }
    }
    
    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        let session = URLSession(configuration: URLSessionConfiguration.default)
        
        session.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error durring session: \(error)")
            }
            guard let validData = data else { return }
            
            callback(validData)
            }.resume()
    }
}
