//
//  Wish.swift
//  iWish
//
//  Created by 卡卡 on 2/20/16.
//  Copyright © 2016 All-Nighters. All rights reserved.
//

import Foundation
import RealmSwift

class Wish: Object {
    dynamic var name = ""
    dynamic var price = 0.00
    dynamic var isCompleted = false
    dynamic var progress = 0.00
    dynamic var progressLabel = ""
    dynamic var notes = ""
    // dynamic var image = NSData()

    convenience init(name: String, price: Double, isCompleted: Bool, progress: Double, progressLabel: String, notes: String) {
        self.init()

        self.name = name
        self.price = price
        self.isCompleted = false
        self.progress = 100/price
        self.progressLabel = progressLabel
        self.notes = notes
    }
}
