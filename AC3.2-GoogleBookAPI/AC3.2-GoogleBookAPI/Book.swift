//
//  Book.swift
//  AC3.2-GoogleBookAPI
//
//  Created by Tom Seymour on 12/4/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import Foundation

class Book {
    let id: String
    let thumb: String
    let title: String
    let subtitile: String
    let authors: [String]
    let description: String
    var fullImageString: String?
    
    init (id: String, thumb: String, title: String, subtitle: String, authors: [String], description: String) {
        self.authors = authors
        self.description = description
        self.id = id
        self.thumb = thumb
        self.title = title
        self.subtitile = subtitle
    }
}
