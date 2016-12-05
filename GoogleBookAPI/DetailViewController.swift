//
//  DetailViewController.swift
//  GoogleBookAPI
//
//  Created by Madushani Lekam Wasam Liyanage on 12/4/16.
//  Copyright © 2016 Madushani Lekam Wasam Liyanage. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookDescription: UILabel!
    
    var bookEndPoint: String?
    var book: GoogleBook?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let googleBookEndPoint = bookEndPoint {
            APIRequestManager.manager.getData(endPoint: googleBookEndPoint) { (data: Data?) in
                if  let validData = data,
                    let validBook = GoogleBook.getGoogleBook(from: validData) {
                    self.book = validBook
                    DispatchQueue.main.async {
                        self.bookDescription.text = self.book?.description
                        if let imageStr = self.book?.fullImage {
                            if imageStr != "" {
                                APIRequestManager.manager.getData(endPoint: imageStr ) { (data: Data?) in
                                    if  let validData = data,
                                        let validImage = UIImage(data: validData) {
                                        DispatchQueue.main.async {
                                            //print("String" + imageString)
                                            self.bookImage.image = validImage
                                            
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
