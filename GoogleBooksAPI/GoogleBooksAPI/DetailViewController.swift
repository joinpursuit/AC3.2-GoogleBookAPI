//
//  DetailViewController.swift
//  GoogleBooksAPI
//
//  Created by Marcel Chaucer on 12/3/16.
//  Copyright © 2016 Marcel Chaucer. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var detailBook: Book?
    @IBOutlet weak var bookTitleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    @IBOutlet weak var bookArt: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let detail = self.detailBook {
            self.title = detail.title
            bookTitleLabel.text = detailBook?.title
            authorLabel.text = detailBook?.author
            APIRequestManager.manager.getData(endPoint: "https://www.googleapis.com/books/v1/volumes/\(detail.id)") { (data: Data?) in
                if let validData = data {
                    if let jsonData = try? JSONSerialization.jsonObject(with: validData, options:[]) {
                        if let wholeBook = jsonData as? [String:Any],
                        let theVolume = wholeBook["volumeInfo"] as? [String: Any],
                            let allTheImages = theVolume["imageLinks"] as? [String:Any],
                            let fullImage = allTheImages["extraLarge"] as? String,
                            let url = URL(string: fullImage),
                            let imageData = try? Data(contentsOf: url)
                            {
                            // start off with everything
                                DispatchQueue.main.async {
                                    self.bookArt.image = UIImage(data: imageData)
                                }
                          
                    }
                    }
                }
            }
        }
    }
}
