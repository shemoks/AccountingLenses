//
//  HelperPask.swift
//  Lens
//
//  Created by Mac on 8/31/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import RealmSwift

class HelperPask{
    static func addToDataBase(obj: Pask) {
        try! Realm().write() {
            try! Realm().add(obj)
        }
    }
    static func getAllPask() ->  Results<Pask> {
        let objs: Results<Pask> = {
            try! Realm().objects(Pask)
        }()
        return objs
    }
    static func removePasc(obj: Pask) {
        try! Realm().write() {
            try! Realm().delete(obj)
        }
    }
    static func getNumberPask() -> Int{
        let realm = try! Realm()
        let RetNext: NSArray = Array(realm.objects(Pask).sorted("number"))
        let last = RetNext.lastObject
        if RetNext.count > 0 {
            let valor = last?.valueForKey("number") as? Int
            return valor! + 1
        } else {
            return 1
        }
    }
    static func removeLens(obj: Pask){
        var numberOfLens = obj.numberOfLens
        numberOfLens -= 1
        obj.numberOfLens = numberOfLens
        try! Realm().write() {
            try! Realm().add(obj, update: true)
        }
    }
//    static func dateOfBuy(arrayOfPasks: Results<Pask>) -> NSDate {
//    
//        
//    }
    static func validation(obj: Pask, minDatePicker: NSDate) -> Bool{
        let now = NSDate()
        if obj.dateBuy == minDatePicker || obj.name == "" || obj.numberOfLens == 0 || obj.lenses[0].termOfUsing == 0 || obj.lenses[0].opticalPower == 0 || now.compare(obj.dateBuy) == NSComparisonResult.OrderedAscending {
        return false
        }
        return true
    }
}