//
//  BookTableViewController.swift
//  GoogleBookAPI
//
//  Created by Victor Zhong on 12/4/16.
//  Copyright © 2016 Victor Zhong. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    var cellIdentifier = "bookCell"
    var segue = "bookSegue"
    var books = [Book]()
    var searchString = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadBooks()
    }
    
    // MARK: - Preparatory Functions
    
    internal func loadBooks(searchTerm: String = "banana") {

        let escapedString = searchTerm.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
        APIRequestManager.manager.getData(endPoint: "https://www.googleapis.com/books/v1/volumes?q=\(escapedString!)") { (data) in
            if data != nil {
                if let returnedBooks = Book.getBooks(from: data) {
                    print("We've got Books! \(returnedBooks.count)")
                    self.books = returnedBooks
                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.title = searchTerm
                        self.searchString = searchTerm
                    }
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
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        let book = books[indexPath.row]
        var auth = ""
        
        cell.textLabel?.text = book.title
        
        if book.authors.count > 0 {
            for x in 0..<book.authors.count {
                if x != book.authors.count - 1 {
                    auth += "\(book.authors[x]), "
                }
                else {
                    auth += "\(book.authors[x])"
                }
            }
        }
        
        cell.detailTextLabel?.text = auth
        
        if let thumb = book.thumbnail {
            APIRequestManager.manager.getData(endPoint: thumb ) { (data: Data?) in
                if  let validData = data,
                    let validImage = UIImage(data: validData) {
                    DispatchQueue.main.async {
                        cell.imageView?.image = validImage
                        cell.setNeedsLayout()
                    }
                }
            }
        }
        
        return cell
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tappedCell = sender as? UITableViewCell {
            if segue.identifier == self.segue {
                let detailView = segue.destination as! BookDetailViewController
                let cellIndexPath = self.tableView.indexPath(for: tappedCell)!
                let book = books[cellIndexPath.row]
                
                detailView.book = book
                detailView.id = book.id
            }
        }
    }
}

// MARK: - UISearchBar Delegate

extension BookTableViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let text = searchBar.text {
            loadBooks(searchTerm: text)
        }
        
        searchBar.showsCancelButton = false
    }
}
