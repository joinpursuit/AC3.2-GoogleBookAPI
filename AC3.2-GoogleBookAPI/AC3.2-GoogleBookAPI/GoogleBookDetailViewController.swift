//
//  GoogleBookDetailViewController.swift
//  AC3.2-GoogleBookAPI
//
//  Created by Tom Seymour on 12/4/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit

class GoogleBookDetailViewController: UIViewController {
    
    
    @IBOutlet weak var fullImageView: UIImageView!
    
    @IBOutlet weak var bookDescriptionLabel: UILabel!
    var thisBook: Book!

    override func viewDidLoad() {
        super.viewDidLoad()
        loadDetailView()

    }
    
    func loadDetailView() {
        
        bookDescriptionLabel.text = thisBook.title
        
        if thisBook.fullImageString == nil {
            let fullDetailEndpoint = "https://www.googleapis.com/books/v1/volumes/\(thisBook.id)"
            print("############ \(fullDetailEndpoint)")
            NetworkManager.shared.getFullImage(endpoint: fullDetailEndpoint, completionHandler: { (str: String?) in
                guard let fullImageString = str else { return }
                DispatchQueue.main.async {
                    self.thisBook.fullImageString = fullImageString
                    self.loadFullImage(endpoint: fullImageString)
                }
            })
        } else {
            self.loadFullImage(endpoint: thisBook.fullImageString!)
        }
        
    }
    
    func loadFullImage(endpoint: String) {
        NetworkManager.shared.getData(endPoint: endpoint) { (data: Data?) in
            guard let unwrappedData = data else { return }
            DispatchQueue.main.async {
                self.fullImageView.image = UIImage(data: unwrappedData)
                self.view.reloadInputViews()
            }
        }
    }

   
}
