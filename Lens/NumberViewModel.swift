//
//  NumberViewModel.swift
//  Lens
//
//  Created by admin on 21.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class NumberViewModel {
    
    var resultNumber: Results<NumberModel>!
    var numberOfSection = 3
    var customText = "Tap on me"
    let realm = try! Realm()
    
    var arrayNumber = [Number]()
    
    func parseLocalJSON() -> [Number] {
        if let path = NSBundle.mainBundle().pathForResource("Number", ofType: "json"){
            do{
                let data = try! NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: .DataReadingMappedIfSafe)
                let json = JSON(data:data)
                let numbers = json["numbers"]
                for i in 0..<numbers.count{
                    let number = Number()
                    number.number = numbers[i]["number"].intValue
                    arrayNumber.append(number)
                }
            }
        }
        return arrayNumber
    }
    
    func saveInDb(value:String) {
        let number = NumberModel()
        number.number = Int(value)!
        
        try! realm.write{
            realm.add(number)
        }
    }
    
    func getDataFromDb(){
        resultNumber = realm.objects(NumberModel)
    }
    
    func cellForDataBaseRow(cell:NumberTableViewCell,indexPath:NSIndexPath) {
        if self.resultNumber.isEmpty {
            cell.titileLabel.text = "You don`t have any data in Data Base"
            cell.countLensesLabel.text = ""
        }else{
            cell.titileLabel.text = "Numbers of Lenses"
            cell.countLensesLabel.text = "\(resultNumber.sorted("number")[indexPath.row].number)"
        }
    }
    
    func cellForJson(cell:NumberTableViewCell,indexPath:NSIndexPath) {
        cell.titileLabel.text = "Numbers of Lenses"
        cell.countLensesLabel.text = "\(arrayNumber[indexPath.row].number)"
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
            self.saveInDb(self.customText)
            self.getDataFromDb()
            tableView.reloadData()
        }))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
    
    func numberOfRows() -> Int{
        if resultNumber.isEmpty{
            return 1
        }else{
            return resultNumber.count
        }
    }
}