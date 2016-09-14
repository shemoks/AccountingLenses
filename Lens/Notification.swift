//
//  Notification.swift
//  Lens
//
//  Created by Mac on 9/13/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class Notification {
    var atribut: [InfoForNotification] = []
    init(atributiesOfNotifications: [InfoForNotification]){
        self.atribut = atributiesOfNotifications
    }
    func getNotification(){
        for info in self.atribut {
            let localNotification = UILocalNotification()
            localNotification.fireDate = info.fireDate
            localNotification.alertBody = info.alertBody
            localNotification.timeZone = NSTimeZone.defaultTimeZone()
            localNotification.alertTitle = "congretulation!"
          localNotification.applicationIconBadgeNumber = UIApplication.sharedApplication().applicationIconBadgeNumber + 1
            UIApplication.sharedApplication().scheduleLocalNotification(localNotification)
        }
    
    }
}
