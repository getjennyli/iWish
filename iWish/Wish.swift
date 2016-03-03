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
    dynamic var price = 0
    dynamic var isCompleted = false
    // dynamic var image = NSData()

    convenience init(name: String, price: Int, isCompleted: Bool) {
        self.init()

        self.name = name
        self.price = price
        self.isCompleted = false
    }
}
