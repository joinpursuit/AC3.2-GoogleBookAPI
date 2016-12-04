//
//  BookDetailViewController.swift
//  GoogleBookAPI
//
//  Created by Victor Zhong on 12/4/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    var book: Book!
    var id: String!
    
    @IBOutlet weak var bookImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBook()
    }
    

    func loadBook() {
        let escapedString = id.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        APIRequestManager.manager.getData(endPoint: "https://www.googleapis.com/books/v1/volumes/\(escapedString!)") { (data) in
            if data != nil {
                if let returnedBook = Book.getOneBook(from: data!) {
                    print("We've got Books!")
                    self.book = returnedBook
                    DispatchQueue.main.async {
                        self.loadData()
                    }
                }
            }
        }
    }
    
    func loadData() {
        let imageCount = book.image?.count ?? 0

        var largestImage = ""
        
        if imageCount > 0 {
            switch imageCount {
            case 6:
                largestImage = "extraLarge"
            case 5:
                largestImage = "large"
            case 4:
                largestImage = "medium"
            case 3:
                largestImage = "small"
            case 2:
                largestImage = "thumbnail"
            default:
                largestImage = "smallThumbnail"
        }
            if let image = book.image?[largestImage] as? String {
                APIRequestManager.manager.getData(endPoint: image) { (data: Data?) in
                    if  let validData = data,
                        let validImage = UIImage(data: validData) {
                        DispatchQueue.main.async {
                            self.bookImage.image = validImage
                        }
                    }
                }
            }
        }
    }
}
