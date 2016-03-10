//
//  SavingTableViewCell.swift
//  iWish
//
//  Created by 卡卡 on 3/9/16.
//  Copyright © 2016 All-Nighters. All rights reserved.
//

import UIKit

class SavingTableViewCell: UITableViewCell {


    @IBOutlet weak var savingAmtLabel: UILabel!
    @IBOutlet weak var savingNoteLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
