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
    dynamic var dateBuy = NSDate(timeIntervalSince1970: 1)
    dynamic var numberOfLens: Int = 0
    var lenses = List<Lens>()
    override static func primaryKey() -> String? {
        return "number"
    }
}