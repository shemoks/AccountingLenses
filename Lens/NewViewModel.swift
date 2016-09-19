//
//  NewViewModel.swift
//  Lens
//
//  Created by admin on 15.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation

class NewViewModel {
    
    var arrayInfoNotification = [InfoForNotification]()
    var arrayNameTitle = ["Title","Optical Power","Numbers of lens"]
    var arrayPlaceholder = ["NameCompany","Power lins","Count","Date"]
    var dateArray = [String]()
    
    var lastSelectedIndexPath: NSIndexPath? = nil
    
    var date:String!
    let pask = Pask()
    let lens = Lens()
    
    func sendNotification() {
        let info = self.arrayInfoNotification
        Notification(atributiesOfNotifications: info).getNotification()
    }
    
    func saveInDataBase(){
        for i in 0..<dateArray.count{
            print(dateArray[i])
        }
    }

}