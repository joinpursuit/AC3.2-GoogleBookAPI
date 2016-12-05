//
//  BooksTableViewController.swift
//  GoogleBookAPI
//
//  Created by Erica Y Stevens on 12/3/16.
//  Copyright © 2016 Erica Stevens. All rights reserved.
//

import UIKit

class BooksTableViewController: UITableViewController {
    
    var books = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        APIRequestManager.manager.getData(endPoint: "https://www.googleapis.com/books/v1/volumes?q=iOS") { (data: Data?) in
            if let validData = data {
                if let jsonData = try? JSONSerialization.jsonObject(with: validData, options: []) {
                    if let jsonDict = jsonData as? [String:Any],
                        let items = jsonDict["items"] as? [[String:Any]] {
                        self.books = Book.parseBooks(from: items)
                        print(validData)
                        print(self.books)
                        
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell
        
        let book = books[indexPath.row]
        
        cell.bookTitleLabel.text = book.title
        let authorsString = book.authors.joined(separator: ", ")
        cell.bookAuthorsLabel.text = "Authors: \(authorsString)"
        if let imageThumbnailURL = book.imageLinks["thumbnail"] {
            APIRequestManager.manager.getData(endPoint: imageThumbnailURL, callback: { (data: Data?) in
                if let validData = data,
                    let image = UIImage(data: validData) {
                    DispatchQueue.main.async {
                        cell.bookImageView?.image = image
                        cell.setNeedsLayout()
                    }
                }
            })
        }
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let dvc = segue.destination as? DetailViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            let book = books[indexPath.row]
            let bookID = books[indexPath.row].id
            dvc.bookDescriptionString = book.description
            dvc.title = book.title
            
            
            APIRequestManager.manager.getData(endPoint: "https://www.googleapis.com/books/v1/volumes/\(bookID)", callback: { (data: Data?) in
                if let validData = data {
                    if let jsonData = try? JSONSerialization.jsonObject(with: validData, options: []) {
                        if let jsonDict = jsonData as? [String:Any],
                            let volumeInfo = jsonDict["volumeInfo"] as? [String:Any] {
                            if let imageLinks = volumeInfo["imageLinks"] as? [String:String] {
                                if let highResImageURLString = imageLinks["extraLarge"]  {
                                    APIRequestManager.manager.getData(endPoint: highResImageURLString, callback: { (data: Data?) in
                                        if let validData = data {
                                            if let image = UIImage(data: validData){
                                                print("*****************")
                                                print("DATA: \(validData)")
                                                
                                                DispatchQueue.main.async {
                                                    dvc.highResBookImageView.image = image
                                                    dvc.highResBookThumbnailImageView.image = image
                                                }
                                            }
                                            
                                        }
                                    })
                                }
                                
                            }
                        }
                    }
                }
            })
        }
    }
    
}
