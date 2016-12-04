//
//  GoogleBookTableViewController.swift
//  GoogleBookAPI
//
//  Created by Eric Chang on 12/4/16.
//  Copyright © 2016 Eric Chang. All rights reserved.
//

import UIKit

class GoogleBookTableViewController: UITableViewController {

    let apiClient = APIManager()
    let url = "https://www.googleapis.com/books/v1/volumes?q=bouldering"
    var books = [Book]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData(endPoint: url)
    }
    
    func getData(endPoint: String) {
        apiClient.getData(endPoint: endPoint) { (data: Data?) in
            if  let validData = data,
                let validObjects = Book.objects(from: validData) {
                self.books = validObjects
                DispatchQueue.main.async {
                    self.tableView?.reloadData()
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "BookCell", for: indexPath) as! BookTableViewCell
        let book = books[indexPath.row]
        
        cell.bookNameTextLabel.text = book.title
        apiClient.downloadImage(urlString: book.thumbnail["smallThumbnail"]!) { (returnedData: Data) in
            DispatchQueue.main.async {
                cell.thumbNailImageView.image = UIImage(data: returnedData)
                cell.setNeedsLayout()
            }
        }

        return cell
    }
    
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = (sender as? UITableViewCell).flatMap(tableView.indexPath) {
            (segue.destination as! BookDetailViewController).thisBook = books[indexPath.row]
        }
    }
    

}
