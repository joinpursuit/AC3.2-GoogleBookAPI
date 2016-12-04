//
//  GoogleBookTableViewController.swift
//  AC3.2-GoogleBookAPI
//
//  Created by Tom Seymour on 12/4/16.
//  Copyright © 2016 C4Q-3.2. All rights reserved.
//

import UIKit

class GoogleBookTableViewController: UITableViewController {
    
    let googleBookCellIdentifier = "GoogleBookCell"
    let detailSegueIdentifier = "detailSegueIdentifier"
    
    var books: [Book] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        loadTableview()

   
    }
    
    func loadTableview() {
        let googleBooksEndpoint = "https://www.googleapis.com/books/v1/volumes?q=banana"
        NetworkManager.shared.getBooks(endpoint: googleBooksEndpoint) { (theBooks) in
            DispatchQueue.main.async {
                if let unwrappedBooksArr = theBooks {
                    self.books = unwrappedBooksArr
                    dump(self.books)
                    self.tableView.reloadData()
                }
            }
        }
    }

    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: googleBookCellIdentifier, for: indexPath)
        let thisBook = books[indexPath.row]
        cell.textLabel?.text = thisBook.title
        cell.detailTextLabel?.text = thisBook.subtitile
        
        NetworkManager.shared.getData(endPoint: thisBook.thumb) { (data: Data?) in
            if let unwrappedData = data {
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: unwrappedData)
                    cell.setNeedsLayout()
                }
            }
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == detailSegueIdentifier {
            if let destinationVC = segue.destination as? GoogleBookDetailViewController,
                let cell = sender as? UITableViewCell,
                let indexPath = tableView.indexPath(for: cell) {
                destinationVC.thisBook = books[indexPath.row]
            }
        }
    }
    
    
    

    
}
