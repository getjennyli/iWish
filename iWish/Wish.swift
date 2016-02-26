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
    
   
    /*init(name: String, price: Int) {

        self.name = name
        self.price = price
        
        super.init()

    }*/
   
    convenience init(name: String, price: Int) {
        self.init()

        self.name = name
        self.price = price
        

    }
}
