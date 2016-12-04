//
//  GoogleBookTableViewController.swift
//  GoogleBookAPI
//
//  Created by C4Q on 12/4/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit

class GoogleBookTableViewController: UITableViewController {

    var books: [Book] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NetworkManager.shared.getBooks(endpoint: "https://www.googleapis.com/books/v1/volumes?q=banana") { (books: [Book]?) in
            guard let b = books else {return}
            self.books = b
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print(self.books.count)
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)
        let currentBook = books[indexPath.row]
        cell.textLabel?.text = currentBook.title
        cell.detailTextLabel?.text = currentBook.subtitle
        NetworkManager.shared.getImage(endpoint: currentBook.thumb) {(data: Data?) in
            if let d = data {
                DispatchQueue.main.async {
                    cell.imageView?.image = UIImage(data: d)
                    cell.setNeedsLayout()
                    
                }
            }
        }

        return cell
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "detailSegueID" {
            let dvc = segue.destination as! DetailViewController
            let book = self.tableView.indexPath(for: sender as! UITableViewCell)!.row
            dvc.book = self.books[book]
        }
    }
}
