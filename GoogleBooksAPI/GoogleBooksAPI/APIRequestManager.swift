//
//  APIRequestManager.swift
//  GoogleBooksAPI
//
//  Created by Harichandan Singh on 12/4/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import Foundation

class APIRequestManager {
    //MARK: - Properties
    static let shared = APIRequestManager()
    
    //MARK: - Initializers
    private init() {}
    
    //MARK: - Methods
    func getData(apiEndpoint: String, callback: @escaping (Data) -> Void) {
        let url: URL = URL(string: apiEndpoint)!
        let session: URLSession = URLSession(configuration: .default)
        
        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Encountered an error with the data task: \(error)")
            }
            
            guard let jsonData = data else { return }
            callback(jsonData)
            
            }.resume()
    }
}
