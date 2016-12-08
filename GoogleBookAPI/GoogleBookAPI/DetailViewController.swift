//
//  DetailViewController.swift
//  GoogleBookAPI
//
//  Created by Eashir Arafat on 12/4/16.
//  Copyright © 2016 Evan. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    
    var book: Book?

    @IBOutlet weak var bookImageHighRes: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIRequestManager.manager.getData(endPoint: (book?.thumbnail)!) { (data: Data?) in
            if let validData = data,
                let validImage = UIImage(data: validData) {
                
                
                DispatchQueue.main.async {
                    self.bookImageHighRes.image = validImage
                    
                }
                
                
            }
        }

       

        // Do any additional setup after loading the view.
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
