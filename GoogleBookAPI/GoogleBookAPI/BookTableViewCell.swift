//
//  BookTableViewCell.swift
//  GoogleBookAPI
//
//  Created by Eric Chang on 12/4/16.
//  Copyright © 2016 Eric Chang. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {

    @IBOutlet weak var thumbNailImageView: UIImageView!
    @IBOutlet weak var bookNameTextLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
