//
//  DatesModel.swift
//  Lens
//
//  Created by Mac on 9/15/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import RealmSwift

class Dates: Object {
    dynamic var dateChange: NSDate = NSDate()
    dynamic var message: String = ""
    var number: Pask?
}