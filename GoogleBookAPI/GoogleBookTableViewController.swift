//
//  GoogleBookTableViewController.swift
//  GoogleBookAPI
//
//  Created by Edward Anchundia on 12/3/16.
//  Copyright © 2016 Edward Anchundia. All rights reserved.
//

import UIKit

class GoogleBookTableViewController: UITableViewController, UISearchBarDelegate {

    var googleBook: [GoogleBook] = []
    var searchTerm = "banana"
    @IBOutlet weak var searchBar: UISearchBar!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loadData()
        title = "Books: \(searchTerm)"
    }

    func loadData() {
        APIRequestManager.manager.getData(endPoint: "https://www.googleapis.com/books/v1/volumes?q=\(self.searchTerm)") { (data: Data?) in
            if data != nil {
                if let googleBookData = GoogleBook.getGoogleBook(from: data!) {
                    DispatchQueue.main.async {
                        self.googleBook = googleBookData
                        self.tableView.reloadData()
                    }
                }
            }
        }
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = searchBar.text {
            searchTerm = search
            title = "Books: \(search)"
            loadData()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return googleBook.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "GoogleBook", for: indexPath)

        let googleBooks = googleBook[indexPath.row]
        let thumbnails = googleBooks.thumbnail
        
        cell.textLabel?.text = googleBooks.title
        cell.detailTextLabel?.text = googleBooks.subtitle
        
        APIRequestManager.manager.getData(endPoint: thumbnails) { (data: Data?) in
            if let validData = data,
                let validImage = UIImage(data: validData) {
                DispatchQueue.main.async {
                    cell.imageView?.image = validImage
                    cell.setNeedsLayout()
                }
            }
        }
        
        return cell
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tappedCell = sender as? UITableViewCell {
            if segue.identifier == "Segue" {
                let bookDetailView = segue.destination as! BookDetailViewController
                let cellIndexPath = self.tableView.indexPath(for: tappedCell)!
                let bookSelected = googleBook[cellIndexPath.row]
                bookDetailView.id = bookSelected.id
            }
        }
    }

}
