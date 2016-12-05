//
//  BookTableViewCell.swift
//  GoogleBooksAPI
//
//  Created by Harichandan Singh on 12/4/16.
//  Copyright © 2016 Harichandan Singh. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    //MARK: - Outlets
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }


}
