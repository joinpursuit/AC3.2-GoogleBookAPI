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
    var id: String?
    
    @IBOutlet weak var bookImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

}
