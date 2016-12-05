//
//  BookTableViewCell.swift
//  GoogleBookAPI
//
//  Created by Erica Y Stevens on 12/3/16.
//  Copyright © 2016 Erica Stevens. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var bookTitleLabel: UILabel!
    
    @IBOutlet weak var bookAuthorsLabel: UILabel!
    
    @IBOutlet weak var bookImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }

}
