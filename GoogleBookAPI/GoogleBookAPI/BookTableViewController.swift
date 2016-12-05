//
//  BookTableViewController.swift
//  GoogleBookAPI
//
//  Created by Tong Lin on 12/4/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController, UISearchBarDelegate {
    var books: [Book] = []

    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchBar.delegate = self
    }
    
    func loadData(endpoint: String){
        APIRequestManager.manager.getData(url: endpoint) { (someData: Data?) in
            if let validData = someData{
                DispatchQueue.main.async {
                    if let allBooks = Book.getBooks(data: validData){
                        self.books = allBooks
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = true
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let newEndpoint = "https://www.googleapis.com/books/v1/volumes?q=\(searchBar.text)".addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)!
        loadData(endpoint: newEndpoint)
        self.searchBar.endEditing(true)
        self.searchBar.showsCancelButton = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.searchBar.showsCancelButton = false
        self.searchBar.endEditing(true)
        self.searchBar.text = ""
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let book = self.books[indexPath.row]
        cell.textLabel?.text = book.title + " (\(book.publishedData))"
        cell.detailTextLabel?.text = book.subtitle
        APIRequestManager.manager.getData(url: book.thumbnail) {(data: Data?) in
            if let imageData = data{
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: imageData)
                    cell.setNeedsLayout()
                    
                }
            }
        }
        return cell
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailViewSegue"{
            let dvc = segue.destination as! DetailViewController
            let indexPath = self.tableView.indexPath(for: sender as! UITableViewCell)!
            let selectedBook = self.books[indexPath.row]
            dvc.book = selectedBook
        }
        
    }
}
