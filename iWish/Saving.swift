//
//  Saving.swift
//  iWish
//
//  Created by 卡卡 on 3/9/16.
//  Copyright © 2016 All-Nighters. All rights reserved.
//

import Foundation
import RealmSwift

class Saving: Object {
    dynamic var save = 0.00
    dynamic var saveNotes = ""
    dynamic var date = NSDate()
    
    convenience init(save: Double, saveNotes: String, date: NSDate) {
        self.init()
        
        self.save = save
        self.saveNotes = saveNotes
        self.date = date
    }
}
