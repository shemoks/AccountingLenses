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
           let buy = arrayDates.count > 1 ? last : pask.dateBuy
           array = self.datesForOnePask(numberOfLenses, numberOfDeys: days, dateOfBuy: buy!)
        }
        return array
    }
    
    func datesForOnePask(numberOfLenses: Int, numberOfDeys: Int, dateOfBuy: NSDate) -> [NSDate] {
        if arrayDates.count == 0 {
            self.arrayDates.append(dateOfBuy)
        }
        if numberOfLenses % 2 == 0 {
            if numberOfLenses > 0 {
                let newNumberOfDay = numberOfDeys
                let dateFormatter = NSDateFormatter()
                dateFormatter.timeStyle = NSDateFormatterStyle.NoStyle
                let gmtTimeZone = NSTimeZone(abbreviation: "GMT")
                dateFormatter.timeZone = gmtTimeZone
                dateFormatter.dateFormat = "dd-MM-YYYY"
                var date = NSDate()
                let calendar = NSCalendar.currentCalendar()
                let dayAfterComponent = NSDateComponents()
                dayAfterComponent.day = numberOfDeys
                date = calendar.dateByAddingComponents(dayAfterComponent, toDate: date, options: NSCalendarOptions.MatchFirst)!
                self.arrayDates.append(date)
                let newNumberOfLenses = numberOfLenses - 2
                print("\(newNumberOfLenses)")
                datesForOnePask(newNumberOfLenses, numberOfDeys: newNumberOfDay, dateOfBuy: date)
            }
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