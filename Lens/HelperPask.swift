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
    
    static func getActivePask() ->  Results<Pask> {
        let objs: Results<Pask> = {
            try! Realm().objects(Pask).filter("isActive = true")
        }()
        return objs
    }
    
    static func removePasc() ->  Results<Pask> {
        let objs: Results<Pask> = {
            try! Realm().objects(Pask).filter("isActive = true")
        }()
        try! Realm().write() {
            for obj in objs {
                var lastDateStructure = dateStruct(day: 0, month: 0, year: 0)
                var nowDateStructure = dateStruct(day: 0, month: 0, year: 0)
                let lastDate = obj.dateFinish
                lastDateStructure = HelperDates.getDateAsStruct(lastDate)
                nowDateStructure = HelperDates.getDateAsStruct(NSDate())
                if lastDateStructure.year == nowDateStructure.year && lastDateStructure.day < nowDateStructure.day && lastDateStructure.month == nowDateStructure.month {
                    obj.isActive = false
                    try! Realm().add(obj, update: true)
                    
                }
            }
        }
        let obj: Results<Pask> = {
            try! Realm().objects(Pask).filter("isActive = true")
        }()
        return obj
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
    //    static func removeLens(obj: Pask){
    //        var numberOfLens = obj.numberOfLens
    //        numberOfLens -= 1
    //        obj.numberOfLens = numberOfLens
    //        try! Realm().write() {
    //            try! Realm().add(obj, update: true)
    //        }
    //    }
    
    func arrayOfDates(arrayOfPasks: Results<Pask>) -> [NSDate] {
        var array: [NSDate] = []
        
        for pask in arrayOfPasks {
            for dates in pask.dates {
                array.append(dates.dateChange)
            }
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
            let tomorrow =  HelperDates.addValueToDate(date, value: newNumberOfDay)
            self.arrayDates.append(tomorrow)
            let newNumberOfLenses = numberOfLenses - 2
            datesForOnePask(newNumberOfLenses, numberOfDeys: newNumberOfDay, dateOfBuy: tomorrow)
            
        }
        return arrayDates
    }
    
    func addValueToDate(dateValue: NSDate, value: Int, pasks: Results<Pask>) {
        if !pasks.isEmpty {
            var k = 0
            let listDates = List<Dates>()
            try! Realm().write() {
                for pask in pasks {
                    for dates in pask.dates {
                        if HelperDates.compareDates(dateValue, secondDate: dates.dateChange) == "=" || k > 0 {
                            k += 1
                            dates.dateChange = HelperDates.addValueToDate(dates.dateChange, value: value)
                            listDates.append(dates)
                        }
                    }
                    pask.dates = listDates
                    try! Realm().add(pask, update: true)
                }
            }
        }
    }
    
    static func validation(obj: Pask, minDatePicker: NSDate) -> Bool{
        //  let now = NSDate()
        if obj.dateBuy == minDatePicker || obj.name == "" || obj.numberOfLens == 0 || obj.lenses[0].termOfUsing == 0 || obj.lenses[0].opticalPower == 0 {
            //|| now.compare(obj.dateBuy) == NSComparisonResult.OrderedAscending
            return false
        }
        return true
    }
    
    static func numberOfLenses(pasks: Results<Pask>) -> [Collection] {
        var numberOfLensesNow: [Collection] = []
        let minDateBuy = pasks.filter("isActive = true").first?.dateBuy
        for pask in pasks {
            var numberOfLenses = pask.numberOfLens
            let collection = Collection()
            if HelperDates.compareDates(pask.dateBuy, secondDate: minDateBuy!) == "=" {
                for date in pask.dates {
                    if HelperDates.compareDates(date.dateChange, secondDate: NSDate()) == "<" {
                        numberOfLenses = pask.numberOfLens - 2
                    }
                }
            }
            collection.number = numberOfLenses
            collection.name = pask.name
            numberOfLensesNow.append(collection)
        }
        return numberOfLensesNow
    }
}