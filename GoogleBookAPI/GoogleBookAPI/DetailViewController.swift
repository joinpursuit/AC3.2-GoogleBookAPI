//
//  DetailViewController.swift
//  GoogleBookAPI
//
//  Created by Erica Y Stevens on 12/3/16.
//  Copyright © 2016 Erica Stevens. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var highResBookImageView: UIImageView!
    
    @IBOutlet weak var highResBookThumbnailImageView: UIImageView!
    
    @IBOutlet weak var bookInfoLabel: UILabel!
    
    var bookDescriptionString = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        blurView.frame = highResBookImageView.bounds
        highResBookImageView.addSubview(blurView)
  
        bookInfoLabel.text = bookDescriptionString
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
