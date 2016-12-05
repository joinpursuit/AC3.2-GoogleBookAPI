//
//  BooksViewController.swift
//  GoogleBookAPI
//
//  Created by Amber Spadafora on 12/3/16.
//  Copyright © 2016 C4Q. All rights reserved.
//

import UIKit
import SDWebImage


class BooksViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellID = "reuseId"
    var books: [Book] = []
    
    
    @IBOutlet weak var bookTable: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        bookTable.dataSource = self
        bookTable.delegate = self
        getBooks()
    }

// MARK: TableView Protocols
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: BookTableViewCell = bookTable.dequeueReusableCell(withIdentifier: cellID, for: indexPath) as! BookTableViewCell
        
        cell.titleLabel.text = books[indexPath.row].title
        cell.thumbNailImage.sd_setImage(with: URL(string:books[indexPath.row].smallThumbnail!))
//        cell.detailTextLabel?.text = books[indexPath.row].title
        
//        let authorString = String(describing: books[indexPath.row].authors)
//        cell.textLabel?.text = authorString
        return cell
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let tappedCell: BookTableViewCell = sender as? BookTableViewCell {
            if segue.identifier == "reuseidss" {
                let destinationVC = segue.destination as! DetailViewController
                let cellIndexPath: IndexPath = self.bookTable.indexPath(for: tappedCell)!
                
                let selectedBook: Book = books[cellIndexPath.row]
                destinationVC.book = selectedBook
                destinationVC.navigationItem.title = selectedBook.title
            }
        }
    }
    
    
    
    
    func getBooks(){
        ApiManager.shared.getData { (Response) in
            self.books = Response as! [Book]
            DispatchQueue.main.async {
                self.bookTable.reloadData()
                print(self.books)
            }
        }
    }
    
    

}
