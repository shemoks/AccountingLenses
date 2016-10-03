//
//  HelperDates.swift
//  Lens
//
//  Created by Mac on 9/16/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation

public struct dateStruct {
    var day: Int
    var month: Int
    var year: Int
}

class HelperDates {
    
    static func addValueToDate (dateValue: NSDate, value: Int) -> NSDate {
        let dayCalendarUnit: NSCalendarUnit = [.Day]
        let tomorrow = NSCalendar.currentCalendar()
            .dateByAddingUnit(
                dayCalendarUnit,
                value: value,
                toDate: dateValue,
                options: []
        )
        
        return tomorrow!
    }
    
    static func getDateAsStruct(dateValue: NSDate) -> dateStruct {
        var structValue = dateStruct(day: 0, month: 0, year: 0)
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: dateValue)
        structValue.year =  components.year
        structValue.month = components.month
        structValue.day = components.day
        
        return structValue
    }
    
    static func subtructDates(dateValue: NSDate) -> Int {
        let dateBegin = getDateAsStruct(dateValue)
        let dateNow = getDateAsStruct(NSDate())
        
        return dateNow.day - dateBegin.day
    }
    
    static func compareDates(firstDate: NSDate, secondDate: NSDate) -> String {
        if firstDate.compare(secondDate) == NSComparisonResult.OrderedSame{
            return "="
        }
        if firstDate.compare(secondDate) == NSComparisonResult.OrderedDescending{
            return ">"
        }
        if firstDate.compare(secondDate) == NSComparisonResult.OrderedAscending{
            return "<"
        }
        return "="
    }
    
    static func subtructCustomDates(first: NSDate,second: NSDate) -> Int {
        let calendar: NSCalendar = NSCalendar.currentCalendar()
        
        // Replace the hour (time) of both dates with 00:00
        let date1 = calendar.startOfDayForDate(first)
        let date2 = calendar.startOfDayForDate(second)
        
        let flags = NSCalendarUnit.Day
        let components = calendar.components(flags, fromDate: date1, toDate: date2, options: [])
        
       return components.day
}
}