//
//  NewViewModel.swift
//  Lens
//
//  Created by admin on 15.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import RealmSwift

struct DataLens {
    var nameCompany:String
    var opticalPower:Double
    var count:Int
    var time:String
}

class NewViewModel {
    
    var arrayNameTitle = ["Name Company","Optical Power","Numbers of lens"]
    var arrayPlaceholder = ["NameCompany","Power lins","Count","Date"]
    
    let arrayLens = List<Lens>()
    let arrayDays = List<Dates>()
    var arrayPasks: Results<Pask>!
    var stuc = DataLens(nameCompany: "", opticalPower: 0, count: 0,time: "")
    var dataArray = [String]()
    
    var lastSelectedIndexPath: NSIndexPath? = nil
    
    var date:String!
    let pask = Pask()
    let lens = Lens()
    
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
    
    func save(text:String) {
        
        dataArray.append(text)
        dataArray.append(stuc.nameCompany)
        dataArray.append("\(stuc.opticalPower)")
        dataArray.append("\(stuc.count)")
    }
    
    
    func saveInDataBase(viewController:UIViewController){
   
          
                if let termin = Int(dataArray[0]) {
                    lens.termOfUsing = termin
                }
                if  dataArray[2] != "" {
                    pask.name = dataArray[2]
                }
                
                if let optical = Double(dataArray[3]) {
                    lens.opticalPower = optical
                }
                
                let expression = NSDateFormatter()
                expression.dateFormat = "dd-MM-yyyy"
                
                if let dateBuy = expression.dateFromString(dataArray[1]) {
                    
                    if let numbers = Int(dataArray[4]) {
                        pask.numberOfLens = numbers
                        
                        if arrayPasks.count > 0 {
                            let lastValue = self.arrayPasks.last?.dates.last?.dateChange
                            pask.dateBuy = lastValue!
                        } else {
                            pask.dateBuy = dateBuy
                        }
                        
                        let tomorrow = HelperDates.addValueToDate(pask.dateBuy, value: Int(dataArray[0])! * Int(numbers/2))
                        pask.dateFinish = tomorrow
                        let dates = HelperPask().datesForOnePask(numbers, numberOfDeys: Int(dataArray[0])!, dateOfBuy: pask.dateBuy)
                        
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
                    HelperPask.addToDataBase(pask)
                    HelperPask.sendNotifications()
                    viewController.navigationController?.popViewControllerAnimated(true)
                }
            
         else {
            let alertController = UIAlertController(title: "Error", message:
                "Complite all fields and select period!", preferredStyle: UIAlertControllerStyle.Alert)
            let okButton = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            }
            alertController.addAction(okButton)
            viewController.presentViewController(alertController, animated: true, completion: nil)
        }
    }
}