//
//  APIRequestManager.swift
//  GoogleBookAPI
//
//  Created by Ana Ma on 12/3/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class APIRequestManager {
    let manager: APIRequestManager = APIRequestManager()
    
    private init() {}
    
    static func getData(endpoint: String, complete: @escaping (Data?) -> Void) {
        guard let validURL = URL(string: endpoint) else { return }
        
        let session = URLSession(configuration: URLSessionConfiguration.default)
        session.dataTask(with: validURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print(error)
            }
            
            guard let validData = data else { return }
            
            complete(validData)
        }.resume()
    }
    
}
