//
//  NewViewModel.swift
//  Lens
//
//  Created by admin on 15.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import RealmSwift

public struct InfoForNotification {
    var fireDate: NSDate
    let alertBody: String
}

struct DataLens {
    var nameCompany:String
    var opticalPower:Double
    var count:Int
}

class NewViewModel {
    
    var arrayInfoNotification = [InfoForNotification]()
    var arrayNameTitle = ["Name Company","Optical Power","Numbers of lens"]
    var arrayPlaceholder = ["NameCompany","Power lins","Count","Date"]
    
    let arrayLens = List<Lens>()
    let arrayDays = List<Dates>()
    var arrayPasks: Results<Pask>!
    var stuc = DataLens(nameCompany: "", opticalPower: 0, count: 0)
    var dateArray = [String]()
    
    var lastSelectedIndexPath: NSIndexPath? = nil
    
    var date:String!
    let pask = Pask()
    let lens = Lens()
    
    func sendNotification() {
        let info = self.arrayInfoNotification
        Notification(atributiesOfNotifications: info).getNotification()
    }
    
    func getArray(obj: (Results<Pask>) -> ()){
        self.arrayPasks = HelperPask.getActivePask()
        dispatch_async(dispatch_get_main_queue(), {
            obj(self.arrayPasks)
        })
    }
    
    
    func setCellInputData(cell:InputDataTableViewCell) -> InputDataTableViewCell{
        if stuc.nameCompany == ""{
            cell.mainTitlelLabel.text = "Tap on me"
            return cell
        }else{
            cell.mainTitlelLabel.text = stuc.nameCompany
            return cell
        }
    }
    
    func setCellOpticalPower(cell:InputDataTableViewCell) -> InputDataTableViewCell{
        if stuc.opticalPower == 0{
            cell.mainTitlelLabel.text = "Tap on me"
            return cell
        }else{
            cell.mainTitlelLabel.text = "\(stuc.opticalPower)"
            return cell
        }
    }
    
    func setCellNumber(cell:InputDataTableViewCell) -> InputDataTableViewCell{
        if stuc.count == 0{
            cell.mainTitlelLabel.text = "Tap on me"
            return cell
        }else{
            cell.mainTitlelLabel.text = "\(stuc.count)"
            return cell
        }
    }
    
    func saveInDataBase(viewController:UIViewController){
        if dateArray.isEmpty != true{
            if dateArray.count != 1 {
                lens.termOfUsing = Int(dateArray[0])!
                pask.name = dateArray[1]
                lens.opticalPower = Double(dateArray[2])!
                print(dateArray)
                let expression = NSDateFormatter()
                expression.dateFormat = "dd-MM-yyyy"
                
                if let dateBuy = expression.dateFromString(dateArray[4]) {
                    
                    if let numbers = Int(dateArray[3]) {
                        pask.numberOfLens = numbers
                        
                        if arrayPasks.count > 0 {
                            let lastValue = self.arrayPasks.last?.dateFinish
                            pask.dateBuy = lastValue!
                        } else {
                            pask.dateBuy = dateBuy
                        }
                        
                        let tomorrow = HelperDates.addValueToDate(pask.dateBuy, value: Int(dateArray[0])! * Int(numbers/2))
                        pask.dateFinish = tomorrow
                        let dates = HelperPask().datesForOnePask(numbers, numberOfDeys: Int(dateArray[0])!, dateOfBuy: pask.dateBuy)
                        
                        for date in dates {
                            let event = Dates()
                            event.dateChange = date
                            
                            if date != dates.last {
                                event.message = "change lenses"
                            } else {
                                event.message = "change pask"
                            }
                            arrayDays.append(event)
                        }
                        pask.dates = arrayDays
                    }
                }
                pask.number = HelperPask.getNumberPask()
                arrayLens.append(lens)
                pask.lenses = arrayLens
                
                let datePikcer = UIDatePicker()
                datePikcer.minimumDate = NSDate()
                
                if  HelperPask.validation(pask, minDatePicker: datePikcer.minimumDate!) {
                    self.arrayInfoNotification = []
                    HelperPask.addToDataBase(pask)
                    for events in pask.dates {
                        let message = events.message
                        let date = events.dateChange
                        let info = InfoForNotification(fireDate: date, alertBody: message)
                        self.arrayInfoNotification.append(info)
                        self.sendNotification()
                    }
                }
                viewController.navigationController?.popViewControllerAnimated(true)
            }
        }else{
            let alertController = UIAlertController(title: "Error", message:
                "Complite all fields and select period!", preferredStyle: UIAlertControllerStyle.Alert)
            let okButton = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            }
            alertController.addAction(okButton)
            viewController.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
}