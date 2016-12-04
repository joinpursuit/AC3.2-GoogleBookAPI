//
//  DetailViewController.swift
//  GoogleBookAPI
//
//  Created by C4Q on 12/4/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit
import SwiftyJSON

class DetailViewController: UIViewController {
    
    @IBOutlet weak var image: UIImageView!
    var book: Book?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.getImage(endpoint: "https://www.googleapis.com/books/v1/volumes/\(book!.id)") {(data: Data?) in
            guard let d = data else { return }
            let json = JSON(data: d)
            if let imageLink = json["volumeInfo"]["imageLinks"]["extraLarge"].string {
                NetworkManager.shared.getImage(endpoint: imageLink) {(data: Data?) in
                    guard let d = data else { return }
                    DispatchQueue.main.async {
                        self.image.image = UIImage(data: d)
                    }
                }
            }
        }
    }
}
