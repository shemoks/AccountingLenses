//
//  OpticalPowerVIewModel.swift
//  Lens
//
//  Created by admin on 21.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class OpticalPowerViewModel {
    var opticalPower: Results<OpticalPowerModel>!
    var numberOfSection = 3
    var customText = "Tapp on me"
    
    var arrayOpticalPower = [OpticalPower]()
    
    let realm = try! Realm()
    
    func parseLocalJSON() -> [OpticalPower]{
        if let path = NSBundle.mainBundle().pathForResource("OpticalPower", ofType: "json"){
            do{
                let data = try! NSData(contentsOfURL: NSURL(fileURLWithPath:path), options: .DataReadingMappedIfSafe)
                let json = JSON(data: data)
                let lenses = json["lenses"]
                for i in 0..<lenses.count{
                    let opticalPower = OpticalPower()
                    opticalPower.opticalPower = lenses[i]["power"].doubleValue
                    arrayOpticalPower.append(opticalPower)
                }
            }
        }
        return arrayOpticalPower
    }
    
    func saveInDB(value:String) {
        let opticalPower = OpticalPowerModel()
        opticalPower.opticalPower = Double(value)!
        
        try! realm.write{
            realm.add(opticalPower)
        }
    }
    
    func getDataFromDataBase(){
        opticalPower = realm.objects(OpticalPowerModel)
    }
    
    func cellForDataBaseRow(cell:OpticalPowerTableViewCell,indexPath:NSIndexPath)   {
        if self.opticalPower.isEmpty {
            cell.tittleForOpticalPowerLabel.text = "You don`t have any data in Data Base"
        }else{
            cell.tittleForOpticalPowerLabel.text = "\(opticalPower[indexPath.row].opticalPower)"
        }
    }
    
    func cellForJSONRow(cell:OpticalPowerTableViewCell,indexPath:NSIndexPath) {
        cell.tittleForOpticalPowerLabel.text = "\(arrayOpticalPower[indexPath.row].opticalPower)"
    }
    
    func numberOfRow() -> Int{
        if self.opticalPower.isEmpty {
            return 1
        }else{
            return self.opticalPower.count
        }
    }
    
    func showAlert(viewController:UIViewController,tableView:UITableView) {
        
        let alert = UIAlertController(title: "Enter Input", message: nil, preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler{(textField) -> Void in
            textField.placeholder = "Please enter data"
            textField.borderStyle = .None
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .Destructive , handler: nil))
        alert.addAction(UIAlertAction(title: "Done", style: .Default, handler: {(action) -> Void in
            let text = alert.textFields![0] as UITextField
            self.customText = text.text!
            self.saveInDB(self.customText)
            self.getDataFromDataBase()
            tableView.reloadData()
        }))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}