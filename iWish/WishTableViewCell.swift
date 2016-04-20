//
//  WishTableViewCell.swift
//  iWish
//
//  Created by 卡卡 on 2/20/16.
//  Copyright © 2016 All-Nighters. All rights reserved.
//

import UIKit

class WishTableViewCell: UITableViewCell {

    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    @IBOutlet weak var progressLabel: UILabel!
    @IBOutlet weak var notesLabel: UILabel!
   
    @IBOutlet weak var imgView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
