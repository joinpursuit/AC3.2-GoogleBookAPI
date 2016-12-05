//
//  BookDetailViewController.swift
//  GoogleBookAPI
//
//  Created by Ana Ma on 12/4/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    var selecedBook: Book!
    var detailBook: Book!
    var imageString: String = ""
    
    @IBOutlet weak var bookImageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //add more image options for the class
        //do a switch case for the detailBook's image option than make an APICall for the largest image
        //refactor some code
        //Have the smallest image string stores as a variabl.
        //If there is a larger one, relace the string with newer image string.
        
        APIRequestManager.getData(endpoint: "https://www.googleapis.com/books/v1/volumes/\(selecedBook.id)") { (data: Data?) in
            guard let validData = data else { return }
            self.detailBook = Book.getBook(data: validData)
            self.getImage()
            DispatchQueue.main.async {
                let url = NSURL(string:self.imageString)
                let data = NSData(contentsOf:url! as URL)
                if data != nil {
                    self.bookImageView.image = UIImage(data: data! as Data)
                    self.view.reloadInputViews()
                }
            }
        }
    }
    
    func getImage() {
        let images: [String?] = [self.detailBook.smallThumbnail,  self.detailBook.thumbnail, self.detailBook.smallImage, self.detailBook.mediumImage, self.detailBook.largeImage, self.detailBook.extraLargeImage ]
        for image in images {
            guard let validImageString = image else { continue }
            if validImageString != "" {
                self.imageString = validImageString
            }
        }
    }
}
