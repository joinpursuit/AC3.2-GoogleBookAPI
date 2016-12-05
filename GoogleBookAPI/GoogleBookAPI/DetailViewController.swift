//
//  DetailViewController.swift
//  GoogleBookAPI
//
//  Created by Tong Lin on 12/4/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    var book: Book?
    var largeImageEndpoint = ""
    @IBOutlet weak var ISBN_10Label: UILabel!
    @IBOutlet weak var ISBN_13Label: UILabel!
    @IBOutlet weak var largeImage: UIImageView!
    @IBOutlet weak var authorsLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationItem.title = self.book?.title
        setupView()
    }

    func setupView(){
        self.ISBN_10Label.text = "ISBN_10: " + (self.book?.ISBN_10)!
        self.ISBN_13Label.text = "ISBN_13: " + (self.book?.ISBN_13)!
        self.authorsLabel.text = allAuthors()
        self.descriptionLabel.text = self.book?.description
        getLargeImage()
    }
    
    private func getLargeImage(){
        APIRequestManager.manager.getData(url: (self.book?.selfLink)!) { (data: Data?) in
            do{
                let json: Any = try JSONSerialization.jsonObject(with: data!, options: [])
                
                guard let myData: [String: Any] = json as? [String: Any],
                    let volumeInfo: [String: Any] = myData["volumeInfo"] as? [String: Any],
                    let imageLinks: [String: Any] = volumeInfo["imageLinks"] as? [String: Any],
                    let large: String = imageLinks["large"] as? String else{ return }
                
                DispatchQueue.main.async {
                    self.largeImageEndpoint = large
                    self.loadImage()
                }
                
            }catch{
                print(error)
            }
        }
    }
    
    private func loadImage(){
        APIRequestManager.manager.getData(url: self.largeImageEndpoint) { (data: Data?) in
            if let imageData = data{
                DispatchQueue.main.async {
                    self.largeImage.image = UIImage(data: imageData)
                    self.view.setNeedsLayout()
                }
            }
        
        }
    }
    
    private func allAuthors() -> String{
        var str = ""
        if let authors = self.book?.authors{
            for name in authors{
                str += "\(name)\n"
            }
        }
        return str
    }
    
}
