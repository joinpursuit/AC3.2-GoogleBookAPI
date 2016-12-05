//
//  APIManager.swift
//  GoogleBookAPI
//
//  Created by Annie Tung on 12/4/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import Foundation

/*    let id: String
 let title: String
 let subtitle: String
 let authors: [String]
 let smallThumbnail: String
 let thumbnail: String*/

class APIRequestManager {
    static let manager: APIRequestManager = APIRequestManager()
    private init() {}
    
    func getDataFrom(endPoint: String, completion: @escaping (Data?) -> Void) {
        guard let url = URL(string: endPoint) else { return }
        let session = URLSession(configuration: .default)
        session.dataTask(with: url) { (data, response, error) in
            if error != nil {
                print("Error at \(error)")
                return
            }
            DispatchQueue.main.async {
                completion(data)
            }
        }.resume()
    }
}

//    func getData(endPoint: String, completion: @escaping ([Googlebook]?) -> Void) {
//        // 1. convert string to url object
//        guard let url = URL(string: endPoint) else { return }
//        // 2. perform network call using URLSession
//        let session = URLSession(configuration: .default)
//        session.dataTask(with: url) { (data: Data?, response: URLResponse?, error: Error?) in
//            // 3. check for error
//            if error != nil {
//                print("Error encountered: \(error)")
//                return
//            }
//            // 4. pass data back to callback
//            guard let validData = data else { return }
//            // 5. validating googleBooks Object
//
//            // use encapsulation - to remove code that doesn't belong in the file, separate responsibililties of code for information hiding mechanism
//            guard let googleBooks = Googlebook.parse(jsonData: validData) else { return }
//
//            // 6. callback the array of Googlebook
//            DispatchQueue.main.async {
//                completion(googleBooks)
//            }
//        }.resume()
//    }
