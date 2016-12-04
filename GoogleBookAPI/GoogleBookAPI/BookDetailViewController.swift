//
//  BookDetailViewController.swift
//  GoogleBookAPI
//
//  Created by Eric Chang on 12/4/16.
//  Copyright © 2016 Eric Chang. All rights reserved.
//

import UIKit

class BookDetailViewController: UIViewController {
    
    let apiClient = APIManager()
    var thisBook: Book?
    var images: [String: String]?
    var imageURL: String?
    var url = "https://www.googleapis.com/books/v1/volumes/"
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var authorsTextLabel: UILabel!
    @IBOutlet weak var coverImageView: UIImageView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getData(endPoint: url + (thisBook?.id)!)
        loadData()
    }
    
    func getData(endPoint: String) {
        apiClient.getData(endPoint: endPoint) { (data: Data?) in
            if  let validData = data,
                let validObjects = Book.objects(from: validData) {
                self.images = validObjects[0].thumbnail
            }
        }
    }
    
    func loadData() {
        titleTextLabel.text = thisBook?.title
        authorsTextLabel.text = thisBook?.authors[0]
        
        if checkImageSize() != nil {
            apiClient.downloadImage(urlString: checkImageSize()!) { (returnedData: Data) in
                DispatchQueue.main.async {
                    self.coverImageView.image = UIImage(data: returnedData)
                }
            }
        }
    }
    
    func checkImageSize() -> String? {
        if images?["extraLarge"] != nil {
            return (images?["extraLarge"])!
        }
        else if images?["large"] != nil {
            return (images?["large"])!
        }
        else if images?["medium"] != nil {
            return (images?["medium"])!
        }
        else if images?["small"] != nil {
            return (images?["small"])!
        }
        else if images?["smallThumbnail"] != nil {
            return (images?["smallThumbnail"])!
        }
        else if images?["thumbail"] != nil {
            return (images?["thumbnail"])!
        }
        else {
            return nil
        }
    }
    
}
