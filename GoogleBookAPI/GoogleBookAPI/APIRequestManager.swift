//
//  APIRequestManager.swift
//  SpotifySearch
//
//  Created by Jason Gresh on 10/31/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class APIRequestManager {
    
    static let manager = APIRequestManager()
    public init() {}

    // defaultSession conforms to DHURLSession protocol for FakeTests
    var defaultSession: DHURLSession = URLSession(configuration: .default)

    func getData(endPoint: String, callback: @escaping (Data) -> Void) {
        print(URLCache.shared.currentMemoryUsage)
        
        guard let myURL = URL(string: endPoint) else { return }
//        let session = URLSession(configuration: URLSessionConfiguration.default)

        defaultSession.dataTask(with: myURL) { (data: Data?, response: URLResponse?, error: Error?) in
            if error != nil {
                print("Error during session: \(error)")
            }
            guard let validData = data else { return }
            callback(validData)
            }.resume()
    }
}
