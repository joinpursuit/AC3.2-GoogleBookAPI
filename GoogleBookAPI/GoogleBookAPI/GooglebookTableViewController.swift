//
//  GooglebookTableViewController.swift
//  GoogleBookAPI
//
//  Created by Annie Tung on 12/4/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import UIKit

class GooglebookTableViewController: UITableViewController {
    
    var googlebookArr = [Googlebook]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIRequestManager.manager.getDataFrom(endPoint: "https://www.googleapis.com/books/v1/volumes?q=banana") { (data: Data?) in
            guard let validData = data else { return }
            if let googlebookObj = Googlebook.parse(jsonData: validData) {
                self.googlebookArr = googlebookObj
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return googlebookArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "gbCell", for: indexPath)
        let googlebook = googlebookArr[indexPath.row]
        cell.textLabel?.text = googlebook.title
        cell.detailTextLabel?.text = googlebook.authors
        
        if let smallthumbnail = googlebook.smallThumbnail {
            APIRequestManager.manager.getDataFrom(endPoint: smallthumbnail) { (data: Data?) in
                guard let validData = data else { return }
                cell.imageView?.image = UIImage(data: validData)
                cell.setNeedsLayout()
            }
        }
        return cell
    }

     // MARK: - Navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destinationVC = segue.destination as? DetailViewController, let selectedCell = sender as? UITableViewCell, let indexPath = tableView.indexPath(for: selectedCell) {
            // pass indexPath to googlebookArr for that selected book
            let googlebook = googlebookArr[indexPath.row]
            destinationVC.googlebook = googlebook
            
        }
     }
}
