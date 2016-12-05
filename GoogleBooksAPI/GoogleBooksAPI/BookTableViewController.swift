//
//  BookTableViewController.swift
//  GoogleBooksAPI
//
//  Created by Harichandan Singh on 12/4/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController {
    //MARK: - Properties
    let endpoint: String = "https://www.googleapis.com/books/v1/volumes?q=banana"
    let identifier: String = "bookCell"
    var books: [Book] = []
    
    //MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBooks()
    }
    
    func loadBooks() {
        APIRequestManager.shared.getData(apiEndpoint: self.endpoint) { (data: Data) in
            if let books = Book.createBooks(from: data) {
                self.books = books
            }
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    // MARK: - Table view data source
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.books.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: identifier, for: indexPath) as? BookTableViewCell
        let book = books[indexPath.row]
        
        if book.subtitle != "" {
            cell?.titleLabel?.text = "\(book.title): \(book.subtitle)"
        }
        else {
            cell?.titleLabel?.text = book.title
        }
        
        switch book.authors.count {
        case 0:
            cell?.subtitleLabel?.text = "Not Available"
        case 1:
            cell?.subtitleLabel?.text = book.authors[0]
        case 2:
            cell?.subtitleLabel?.text = "\(book.authors[0]) and \(book.authors[1])"
        default:
            print("Never reaches this point.")
        }
        let url = URL(string: book.thumbnail)!
        if let imageData = try? Data(contentsOf: url) {
            cell?.thumbnailImageView.image = UIImage(data: imageData)
        }
        //        APIRequestManager.shared.getData(apiEndpoint: book.thumbnail) { (data: Data) in
        //            DispatchQueue.main.async {
        //                cell?.thumbnailImageView.image = UIImage(data: data)
        //                cell?.setNeedsLayout()
        //            }
        //        }
        return cell!
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookSegue" {
            if let dvc = segue.destination as? DetailViewController {
                let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)!
                let book = self.books[indexPath.row]
                dvc.book = book
            }
            
            
            
        }
    }
    
}


