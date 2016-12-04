//
//  APIManager.swift
//  GoogleBookAPI
//
//  Created by Eric Chang on 12/4/16.
//  Copyright © 2016 Eric Chang. All rights reserved.
//

import Foundation

class APIManager {
    private static let defaultSession = URLSession(configuration: .default)
      
    // MARK: - Get Book
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
    
    // MARK: - Get Image
    func downloadImage(urlString: String, callback: @escaping (Data) -> () ) {
        guard let imageURL = URL(string: urlString) else { return }
        
        let session = URLSession.shared
        session.dataTask(with: imageURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error encountered!: \(error!)")
            }
            guard let imageData = data else { return }
            callback(imageData)
            }.resume()
    }

}
