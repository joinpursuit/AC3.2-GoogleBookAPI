//
//  GoogleBooksTableViewController.swift
//  GoogleBooksAPI
//
//  Created by Marcel Chaucer on 12/3/16.
//  Copyright © 2016 Marcel Chaucer. All rights reserved.
//

import UIKit

class GoogleBooksTableViewController: UITableViewController {
 var APIEndPoint = "https://www.googleapis.com/books/v1/volumes?q=book"
    var allTheBooks: [Book] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
        self.title = "All These Books"
    }

    
    
    func loadData() {
        APIRequestManager.manager.getData(endPoint: self.APIEndPoint) { (data: Data?) in
            var theBooks = [Book]()
            if let validData = data {
                if let jsonData = try? JSONSerialization.jsonObject(with: validData, options: []) {
                    if let wholeDict = jsonData as? [String: Any],
                        let books = wholeDict["items"] as? [[String: Any]] {
                        theBooks.append(contentsOf: Book.parseBooks(from: books))
                        self.allTheBooks = theBooks
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
        return self.allTheBooks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "bookCell", for: indexPath)
        let theBook = self.allTheBooks[indexPath.row]
        
        cell.textLabel?.text = theBook.title
        cell.detailTextLabel?.text = theBook.author

//        //The non asynchronous call works for the thumbnail but not using the APIRequestManager
        let imageData = try? Data(contentsOf: theBook.thumbNail)
        cell.imageView?.image = UIImage(data: imageData!)
//        APIRequestManager.manager.getData(endPoint: theBook.thumbNailString) { (data: Data?) in
//            if let validData = data,
//                let validImage = UIImage(data: validData) {
//                DispatchQueue.main.async {
//                    cell.imageView?.image = validImage
//                    self.tableView.reloadData()
//                }
//            }
//        }


        return cell
    }
    

   
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tappedObject = sender as? UITableViewCell {
            if segue.identifier == "showBook" {
                let objectDetailViewController = segue.destination as! DetailViewController
                let cellIndexPath: IndexPath = self.tableView.indexPath(for: tappedObject)!
                let selectedObject = self.allTheBooks[cellIndexPath.row]
                objectDetailViewController.detailBook = selectedObject            }
        }
    }
}

