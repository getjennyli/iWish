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
    dynamic var notes: String? = nil
    dynamic var image: NSData? = nil

    convenience init(name: String, price: Double, isCompleted: Bool, notes: String, image: NSData) {
        self.init()

        self.name = name
        self.price = price
        self.isCompleted = false
        self.notes = notes ?? ""
        self.image = image
    }
}
