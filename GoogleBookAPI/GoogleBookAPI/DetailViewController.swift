//
//  DetailViewController.swift
//  GoogleBookAPI
//
//  Created by Amber Spadafora on 12/4/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit
import SDWebImage

class DetailViewController: UIViewController {
    
    var book: Book?
    
    @IBOutlet weak var bookImage: UIImageView!
    @IBOutlet weak var bookTitle: UILabel!
    @IBOutlet weak var descripLabel: UILabel!
    
    
    @IBOutlet weak var bookAuthors: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: (book?.smallThumbnail)!)
        bookImage.sd_setImage(with: url!)
        bookTitle.text = book?.title
        
        let bookAuthorsString = book?.authors.joined(separator: ", ")
        
        if let descrip = book?.descrip {
            descripLabel.text = descrip
        }
        
        bookAuthors.text = bookAuthorsString!
        
        
        

        // Do any additional setup after loading the view.
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
