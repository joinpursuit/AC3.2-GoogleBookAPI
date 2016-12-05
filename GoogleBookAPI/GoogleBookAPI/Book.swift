//
//  Book.swift
//  GoogleBookAPI
//
//  Created by Amber Spadafora on 12/3/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import Foundation

class Book {
    
    let bookID: String
    let title: String
    let authors: [String]
    let smallThumbnail: String?
    let descrip: String?

    init(bookID: String, title: String, smallThumbnail: String?,authors: [String], descrip: String?){
        self.bookID = bookID
        self.title = title
        self.authors = authors
        self.smallThumbnail = smallThumbnail
        self.descrip = descrip
    }
    
    
    
    
}
