//
//  DetailViewController.swift
//  GoogleBookAPI
//
//  Created by Annie Tung on 12/4/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var thumbnailImage: UIImageView!
    var googlebook: Googlebook?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let validGooglebook = googlebook else { return }
        APIRequestManager.manager.getDataFrom(endPoint: "https://www.googleapis.com/books/v1/volumes/\(validGooglebook.id)") { (data: Data?) in
            guard let validData = data else { return }
            validGooglebook.extraLargeImage = Googlebook.parseXLImageFrom(jsonData: validData)
            
            if let validThumbnail = validGooglebook.extraLargeImage {
                APIRequestManager.manager.getDataFrom(endPoint: validThumbnail, completion: { (data: Data?) in
                    guard let validData = data else { return }
                    self.thumbnailImage.image = UIImage(data: validData)
                })
            }
        }
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
