//
//  ApiManager.swift
//  GoogleBookAPI
//
//  Created by Amber Spadafora on 12/3/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class ApiManager {
    
    static let shared = ApiManager()
    private init() {}


    func getData(callback: @escaping ([Book?]) ->Void){
        var books: [Book] = []
        let endPointUrl = URL(string: "https://www.googleapis.com/books/v1/volumes?q=dogs")
        
        
        let currentSession = URLSession(configuration: .default)
        currentSession.dataTask(with: endPointUrl!) { (data: Data?, response: URLResponse?, error: Error?) in
            
            if error != nil {
                print(error!)
                return
            }
            
            if data != nil {
                print("data was not nil")
                // callback(data!)
                do{
                    let jsonData = try JSONSerialization.jsonObject(with: data!, options: [])
                    
                    guard let resultsDictionary = jsonData as? [String: AnyObject] else {
                        print("error w/ resultsDictionary")
                        return
                    }
                    guard let bookResults = resultsDictionary["items"] as? [[String: Any]] else {
                        print("error w/ bookResults")
                        return
                    }
                    for book in bookResults {
                        guard let bookID = book["id"] as? String else {
                            print("error w/ bookID")
                            return
                        }
                        guard let volumeInfoDict = book["volumeInfo"] as? [String: Any] else {
                            print("error w/ volumeInfo")
                            return
                        }
                        guard let title = volumeInfoDict["title"] as? String else {
                            print("error w/ title")
                            return
                        }
                        guard let authors = volumeInfoDict["authors"] as? [String] else {
                            print("error w/ authors")
                            return
                        }
                        
                        let descrip = volumeInfoDict["description"] as! String?
                        
                        guard let imageDict = volumeInfoDict["imageLinks"] as? [String: String] else {
                            print("error w/ imageDict")
                            return
                        }
                        
                        let thumbnail = imageDict["smallThumbnail"]
                        let bookInfo = Book(bookID: bookID, title: title, smallThumbnail: thumbnail!, authors: authors, descrip: descrip)
                        books.append(bookInfo)
                    }
                print(books[4].descrip!)
                callback(books)
                }
                catch {
                    print(error)
                }
            }
            }.resume()

    }
}
