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
    
    convenience init(save: Double, saveNotes: String) {
        self.init()
        
        self.save = 20
        self.saveNotes = saveNotes
    }
}
