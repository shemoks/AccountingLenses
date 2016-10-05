//
//  Notification.swift
//  Lens
//
//  Created by Mac on 9/13/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

public struct InfoForNotification {
    var fireDate: NSDate
    let alertBody: String
}

class Notification {
    var atribut: [InfoForNotification] = []
    init(atributiesOfNotifications: [InfoForNotification]){
        self.atribut = atributiesOfNotifications
    }
    
    func getNotification(){
        UIApplication.sharedApplication().cancelAllLocalNotifications()
        for info in self.atribut {
            let localNotification = UILocalNotification()
            localNotification.fireDate = info.fireDate
            localNotification.alertBody = info.alertBody
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
    }
}
