//
//  APIRequestManager.swift
//  GoogleBookAPI
//
//  Created by Tong Lin on 12/4/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import Foundation

internal class APIRequestManager {
    static let manager = APIRequestManager()
    private let request = URLSession(configuration: URLSessionConfiguration.default)
    init() { }
    
    func getData(url: String, callback: @escaping ((Data?)->Void)) {
        let endpoint = URL(string: url)!
        
        self.request.dataTask(with: endpoint) {(data: Data?, _, error: Error?) in
            if let myError = error{
                print(myError)
            }
            
            if let myData = data{
                callback(myData)
            }
        }.resume()
    }
}
