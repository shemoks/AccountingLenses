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
    var arrayDates: [NSDate] = []
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
    
    func arrayOfDates(arrayOfPasks: Results<Pask>) -> [NSDate] {
        var array: [NSDate] = []
        
        for pask in arrayOfPasks {
           let last = self.arrayDates.last
           let numberOfLenses = pask.numberOfLens
           let days = pask.lenses[0].termOfUsing
           let dayBuy = pask.dateBuy
           let buy = arrayDates.count > 1 ? last : dayBuy
           array = self.datesForOnePask(numberOfLenses, numberOfDeys: days, dateOfBuy: buy!)
        }
        return array
    }
    
    func datesForOnePask(numberOfLenses: Int, numberOfDeys: Int, dateOfBuy: NSDate) -> [NSDate] {
        if arrayDates.count == 0 {
            self.arrayDates.append(dateOfBuy)
        }
                if numberOfLenses > 1 {
                let newNumberOfDay = numberOfDeys
                let date = dateOfBuy
                let dayCalendarUnit: NSCalendarUnit = [.Day]
                let tomorrow = NSCalendar.currentCalendar()
                    .dateByAddingUnit(
                        dayCalendarUnit,
                        value: numberOfDeys,
                        toDate: date,
                        options: []
                )
                self.arrayDates.append(tomorrow!)
                let newNumberOfLenses = numberOfLenses - 2
                datesForOnePask(newNumberOfLenses, numberOfDeys: newNumberOfDay, dateOfBuy: tomorrow!)

        }
        return arrayDates
    }
    
    static func validation(obj: Pask, minDatePicker: NSDate) -> Bool{
        let now = NSDate()
        if obj.dateBuy == minDatePicker || obj.name == "" || obj.numberOfLens == 0 || obj.lenses[0].termOfUsing == 0 || obj.lenses[0].opticalPower == 0 || now.compare(obj.dateBuy) == NSComparisonResult.OrderedAscending {
            return false
        }
        return true
    }
}