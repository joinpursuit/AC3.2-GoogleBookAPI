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
//        
//        self.tableView.estimatedRowHeight = 200
//        self.tableView.rowHeight = UITableViewAutomaticDimension
        
        APIRequestManager.manager.getData(endPoint: "https://www.googleapis.com/books/v1/volumes?q=banana") { (data: Data?) in
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if let dvc = segue.destination as? DetailViewController,
            let cell = sender as? UITableViewCell,
            let indexPath = tableView.indexPath(for: cell) {
            let bookID = books[indexPath.row].id
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
                                                    dvc.highResBookImageView.setNeedsLayout()
                                                    
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
