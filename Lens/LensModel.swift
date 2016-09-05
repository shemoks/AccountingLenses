//
//  LensModel.swift
//  Lens
//
//  Created by Mac on 8/31/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import RealmSwift

enum Term: Int {
    case week = 7
    case twoWeeks = 14
    case month = 30
    func nameOfNumber() -> String {
        switch self {
        case .twoWeeks: return "два тижні"
        case .week: return "тиждень"
        case .month: return "місяць"
        }
    }
    static let arrayEnum = [week, twoWeeks, month]
    static let count: Int = arrayEnum.count
}

class Lens: Object {
    dynamic var termOfUsing: Int = 0
    dynamic var opticalPower: Double = 0.0
    var number: Pask?
}
