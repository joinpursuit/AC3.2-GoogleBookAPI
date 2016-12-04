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
    
    func getArticles(endpoint: String, completionHandler: @escaping ([Article]?) -> Void ) {
        Alamofire.request(endpoint).validate().responseJSON { (response) in
            var articles: [Article] = []

            let json = JSON(response.result.value)
            guard let results = json["results"].array else { return }
            for result in results {
                guard let section = result["section"].string,
                    let subsection = result["subsection"].string,
                    let title = result["title"].string,
                    let abstract = result["abstract"].string,
                    let url = result["url"].string,
                    let byline = result["byline"].string,
                    let publishedDate = result["published_date"].string else { return }
            
            articles.append(Article(section: section, subsection: subsection, title: title, abstract: abstract, url: url, byline: byline, publishedDate: publishedDate))
            }
            completionHandler(articles)
        }
    }
}

