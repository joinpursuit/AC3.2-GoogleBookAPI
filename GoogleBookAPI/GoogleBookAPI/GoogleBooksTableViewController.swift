//
//  GoogleBooksTableViewController.swift
//  GoogleBookAPI
//
//  Created by Ana Ma on 12/3/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class GoogleBooksTableViewController: UITableViewController {
    var booksArr: [Book] = [Book]()
    var bookCellIdentifier = "bookCellIdentifier"
    var bookDetailViewSegue = "bookDetailViewSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        APIRequestManager.getData(endpoint: "https://www.googleapis.com/books/v1/volumes?q=banana") { (data: Data?) in
            guard let validData = data else { return }
            //dump(validData)
            guard let validBooksArr = Book.getBooks(data: validData) else { return }
            DispatchQueue.main.async {
                self.booksArr = validBooksArr
                dump(self.booksArr)
                self.tableView.reloadData()
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
        return self.booksArr.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: self.bookCellIdentifier, for: indexPath)
        cell.textLabel?.text = booksArr[indexPath.row].title
        APIRequestManager.getData(endpoint: booksArr[indexPath.row].thumbnail!) { (data: Data?) in
            guard let validImageData = data else { return }
            DispatchQueue.main.async {
                cell.imageView?.image = UIImage(data: validImageData)
            }
        }
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "bookDetailViewSegue" {
            let bookDetailViewController = segue.destination as! BookDetailViewController
            if let cell = sender as? UITableViewCell {
                if let indexPath = tableView.indexPath(for: cell) {
                    let selectedBook = booksArr[indexPath.row]
                    bookDetailViewController.selecedBook = selectedBook
                }
            }
        }
    }
}

/*
 Unit 4 Week 3 Homework
 
 Google Book API
 
 Objectives
 
 Perform a search on the Google Book API and display the results in a table
 Segue to a detail
 Steps
 
 Fork and clone https://github.com/C4Q/AC3.2-GoogleBookAPI. Create a new project inside it and name it GoogleBookAPI. (It would be very helpful for us looking at your projects if you follow this naming.)
 
 Read the API as described on https://developers.google.com/books/docs/v1/getting_started.
 
 You'll really only be working with these endpoints:
 
 https://www.googleapis.com/books/v1/volumes?q=banana
 https://www.googleapis.com/books/v1/volumes/cSoVd-o8PmoC
 The parameters 'banana' and 'cSoVd-o8PmoC' are examples.
 Visit https://www.googleapis.com/books/v1/volumes?q=banana in your browser or Postman and inspect the JSON. Use that endpoint in your table view controllerParse out the appropriate data to create an array of native Book objects. Display each book in a cell with a thumbnail.
 
 Segue to a detail view controller passing over a book object. This is the usual pattern.
 
 In addition to displaying the title and author from the original Book object passed in the segue make a new API call to:
 
 https://www.googleapis.com/books/v1/volumes/<id>
 
 You will need to capture the id from the previous call in order to store it a property of the Book object. You will use this id field in the second request.
 
 Inside the result of this second request look for the imageLinks object and display the highest resolution image of the book. The imageLinks object may not exist, in which case do nothing.
 
 Notes:
 
 While these instructions have many details, there might be some missing. Do your best to get some results even if you don't understand something or have to skip something.
 You're going to have to think about the data model, especially now that you will be getting new data about the same object on a second data call.
 */
