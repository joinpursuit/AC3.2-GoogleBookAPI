//
//  BookTableViewController.swift
//  GoogleBookAPI
//
//  Created by Eashir Arafat on 12/4/16.
//  Copyright © 2016 Evan. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController {
    
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Books"
        
        let endPoint = "https://www.googleapis.com/books/v1/volumes?q=banana"
        
        
        APIRequestManager.manager.getData(endPoint: endPoint) { (data: Data?) in
            if let validData = data,
                let validBooks = Book.getBooks(from: validData) {
                self.books = validBooks
                
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath) as! BookTableViewCell
        
        let book = books[indexPath.row]
        
        cell.bookTitle.text = book.title
        
        
        APIRequestManager.manager.getData(endPoint: book.thumbnail) { (data: Data?) in
            if let validData = data,
                let validImage = UIImage(data: validData) {
                
                
                DispatchQueue.main.async {
                    cell.bookThumbnail.image = validImage
                    cell.setNeedsLayout()
                }
                
                
            }
        }
        // Configure the cell...
        
        return cell
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let dvc = segue.destination as? DetailViewController,
        let cell = sender as? BookTableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            dvc.book = books[indexPath.row]
            
        }
        
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    
    
}
