//
//  APIRequestManager.swift
//  GoogleBookAPI
//
//  Created by Eashir Arafat on 12/4/16.
//  Copyright © 2016 Evan. All rights reserved.
//

import Foundation

class APIRequestManager {
    
    static let manager = APIRequestManager()
    private init () {}
    
    func getData(endPoint: String, callback: @escaping (Data?) -> Void) {
        guard let myURL = URL(string: endPoint) else { return }
        
        let session = URLSession(configuration: .default)
        
        session.dataTask(with: myURL) { (data:Data?, response: URLResponse?, error:Error?) in
            if error != nil {
                print("Error during session \(error)")
            }
            guard let validData = data else { return }
            callback(validData)
        }.resume()
    }
}
