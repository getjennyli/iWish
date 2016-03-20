//
//  HeaderCell.swift
//  iWish
//
//  Created by 卡卡 on 3/10/16.
//  Copyright © 2016 All-Nighters. All rights reserved.
//

import UIKit

class HeaderCell: UITableViewCell {
    @IBOutlet weak var wantsLabel: UILabel!
    @IBOutlet weak var savingLabel: UILabel!
    @IBOutlet weak var completedLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
}
