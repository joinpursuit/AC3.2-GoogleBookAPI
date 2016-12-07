//
//  GooglebookTableViewController.swift
//  GoogleBookAPI
//
//  Created by Annie Tung on 12/4/16.
//  Copyright © 2016 Annie Tung. All rights reserved.
//

import UIKit

class GooglebookTableViewController: UITableViewController, UISearchBarDelegate {
    
    var googlebookArr = [Googlebook]()
    var searchQuery = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lookForBananaAPIPoint()
        searchBar()
    }
    
    // MARK: - Method
    func lookForBananaAPIPoint() {
        APIRequestManager.manager.getDataFrom(endPoint: "https://www.googleapis.com/books/v1/volumes?q=banana") { (data: Data?) in
            guard let validData = data else { return }
            if let googlebookObj = Googlebook.parse(jsonData: validData) {
                self.googlebookArr = googlebookObj
                self.tableView.reloadData()
            }
        }
    }
    
    func getSearchBarResults(for searchQuery: String) {
        APIRequestManager.manager.getDataFrom(endPoint: "https://www.googleapis.com/books/v1/volumes?q=\(searchQuery)") { (data: Data?) in
            guard let validData = data else { return }
            if let validObj = Googlebook.parse(jsonData: validData) {
                self.googlebookArr = validObj
                self.tableView.reloadData()
            }
        }
    }
    
    // MARK: - Search Bar
    func searchBar() {
        let searchBar = UISearchBar()
        searchBar.delegate = self
        searchBar.showsCancelButton = false
        searchBar.placeholder = "Search for book here"
        self.navigationItem.titleView = searchBar
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.searchQuery = (searchBar.text?.replacingOccurrences(of: " ", with: ""))!
        getSearchBarResults(for: searchQuery)
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
