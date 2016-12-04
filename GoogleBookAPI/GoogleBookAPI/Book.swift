//
//  Book.swift
//  GoogleBookAPI
//
//  Created by C4Q on 12/4/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class Book {
    let id: String
    let thumb: String
    let title: String
    let subtitle: String
    let authors: [String]
    let description: String
    
    init (id: String, thumb: String, title: String, authors: [String], description: String, subtitle: String) {
        self.authors = authors
        self.description = description
        self.id = id
        self.thumb = thumb
        self.title = title
        self.subtitle = subtitle
    }
}
