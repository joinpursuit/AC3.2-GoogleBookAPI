//
//  DetailViewController.swift
//  GoogleBooksAPI
//
//  Created by Harichandan Singh on 12/4/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    //MARK: - Properties
    var book: Book?
    var images: [String: String]?
    
    //MARK: - Outlets
    @IBOutlet weak var highResImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpLabels()
        loadImage()
    }
    
    func setUpLabels() {
        if let book = self.book {
            if book.subtitle != "" {
                self.titleLabel?.text = "\(book.title): \(book.subtitle)"
            }
            else {
                self.titleLabel?.text = book.title
            }
            
            switch book.authors.count {
            case 0:
                self.authorLabel?.text = "Not Available"
            case 1:
                self.authorLabel?.text = book.authors[0]
            case 2:
                self.authorLabel?.text = "\(book.authors[0]) and \(book.authors[1])"
            default:
                print("Never reaches this point.")
            }
        }
    }
    
    func loadImage() {
        if let book = self.book {
            let endpoint = "https://www.googleapis.com/books/v1/volumes/\(book.id)"
            APIRequestManager.shared.getData(apiEndpoint: endpoint, callback: { (data: Data) in
                
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
                    
                    if let jsonData = json {
                        guard let volumeInfo = jsonData["volumeInfo"] as? [String: Any],
                            let imageLinks = volumeInfo["imageLinks"] as? [String: String]
                            else { return }
                        self.images = imageLinks
                        self.setHighestResImage()
                    }
                }
                catch {
                    print("Unexpected error found while parsing JSON data")
                }
            })
        }
    }
    
    func setHighestResImage() {
        if let imagesDict = self.images {
            let largestSize = imagesDict.keys.sorted{ $0 < $1 }[0]
            print("Largest image size: \(largestSize)")
            
            guard let imageString = imagesDict[largestSize] else { return }
            APIRequestManager.shared.getData(apiEndpoint: imageString, callback: { (data: Data) in
                DispatchQueue.main.async {
                    self.highResImageView.image = UIImage(data: data)
                    self.view.setNeedsLayout()
                }
            })
        }
    }
    
    
}
