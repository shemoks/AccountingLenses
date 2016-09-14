//
//  PaskModel.swift
//  Lens
//
//  Created by Mac on 8/31/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import RealmSwift

class Pask: Object {
    dynamic var number: Int = 0
    dynamic var name: String = ""
    dynamic var dateBuy = NSDate()
    dynamic var numberOfLens: Int = 0
    dynamic var dateFinish = NSDate()
    dynamic var isActive = true
    var lenses = List<Lens>()
    override static func primaryKey() -> String? {
        return "number"
    }
}