//
//  NetworkManager.swift
//  AC3.2-4K-Fork--B
//
//  Created by Tom Seymour on 12/1/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class NetworkManager {
    
    static let shared = NetworkManager()
    private init () {}
    
    func getBooks(endpoint: String, completionHandler: @escaping ([Book]?) -> Void ) {
        Alamofire.request(endpoint).validate().responseJSON { (response) in
            var books: [Book] = []
            
            let json = JSON(response.result.value)
            guard let items = json["items"].array else { return }
            for item in items {
                guard
                    let id = item["id"].string,
                    let title = item["volumeInfo"]["title"].string,
                    //let subtitle = item["volumeInfo"]["subtitle"].string,
                    let authors = item["volumeInfo"]["authors"].array,
                    let description = item["volumeInfo"]["description"].string,
                    let thumb = item["volumeInfo"]["imageLinks"]["smallThumbnail"].string else {
                        print("JSONFailed")
                        return
                }
                books.append(Book(id: id, thumb: thumb, title: title, authors: authors.map{$0.stringValue}, description: description, subtitle: item["volumeInfo"]["subtitle"].string ?? ""))
                
            }
            
            
            completionHandler(books)
        }
    }
    func getImage(endpoint: String, completionHandler: @escaping (Data?) -> Void) {
        Alamofire.request(endpoint).validate().responseData { (data) in
            completionHandler(data.data)
        }
    }
}

