//
//  BookDetailViewController.swift
//  GoogleBookAPI
//
//  Created by Edward Anchundia on 12/4/16.
//  Copyright © 2016 Edward Anchundia. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {

    var googleBook: GoogleBook?
    var images: [String: String]?
    
    @IBOutlet weak var bookImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getImage()
    }
    
    func getImage() {
        if let book = self.googleBook {
            let endpoint = "https://www.googleapis.com/books/v1/volumes/\(book.id)"
            APIRequestManager.manager.getData(endPoint: endpoint) { (data: Data?) in
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                    
                    if let jsonData = json {
                        guard let volumeInfo = jsonData["volumeInfo"] as? [String: Any],
                            let imageLinks = volumeInfo["imageLinks"] as? [String: String]
                            else { return }
                        self.images = imageLinks
                        self.setHighestResImage()
                    }
                } catch {
                    print("Unexpected error found while parsing JSON data")
                }
            }
        
        }
    }
    
    func setHighestResImage() {
        if let imagesDict = self.images {
            let largestSize = imagesDict.keys.sorted{ $0 < $1 }[0]
            print("Largest image size: \(largestSize)")
            
            guard let imageString = imagesDict[largestSize] else { return }
            APIRequestManager.manager.getData(endPoint: imageString) { (data: Data?) in
                DispatchQueue.main.async {
                    self.bookImage.image = UIImage(data: data!)
                    self.view.setNeedsLayout()
                }
            }
        }
    }


}
