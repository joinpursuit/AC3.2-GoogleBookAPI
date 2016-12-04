//
//  BookTableViewController.swift
//  GoogleBookAPI
//
//  Created by Tong Lin on 12/4/16.
//  Copyright © 2016 Tong Lin. All rights reserved.
//

import UIKit

class BookTableViewController: UITableViewController {

    let endpoint = "https://www.googleapis.com/books/v1/volumes?q=banana"
    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
    }
    
    func loadData(){
        APIRequestManager.manager.getData(url: self.endpoint) { (someData: Data?) in
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
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return self.books.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //"detailViewSegue"
        
    }
}
