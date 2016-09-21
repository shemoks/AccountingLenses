//
//  NameCompanyViewModel.swift
//  Lens
//
//  Created by admin on 20.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import SwiftyJSON
import RealmSwift

class NameCompanyViewModel {
    
    var nameCompany: Results<NameModel>!
    var numberOfSection = 3
    let realm = try! Realm()
    
    var arrayCompanies = [NameCompany]()
    var textForCustomName = "Tapp on me"
    
    func parseLocalJSON() -> [NameCompany] {
        if let path = NSBundle.mainBundle().pathForResource("NameCompanyJSON", ofType: "json"){
            do{
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let json = JSON(data:data)
                let companies = json["companies"]
                for i in 0..<companies.count{
                    let nameCompany = NameCompany()
                    nameCompany.name = companies[i]["name"].stringValue
                    arrayCompanies.append(nameCompany)
                }
            }catch{
                print("Faild Name/Path")
            }
        }
        return arrayCompanies
    }
    
    func saveInDB(name:String) {
        
        let nameCompany = NameModel()
        nameCompany.name = name
        
        try! realm.write{
            realm.add(nameCompany)
        }
    }
    
    func numberOfRows() -> Int{
       if self.nameCompany.isEmpty == true {
            return 1
       }else {
            return self.nameCompany.count
        }
    }
    
    func cellForRow(cell:NameCompanyTableViewCell,indexPath:NSIndexPath) -> NameCompanyTableViewCell{
        switch self.nameCompany.isEmpty {
        case true:
            cell.nameCompanyLabel.text = "You don`t have any data in Data Base"
        case false:
            cell.nameCompanyLabel.text = nameCompany.sorted("name")[indexPath.row].name
        }
        return cell
    }
    
    func getDataBase() {
        nameCompany = realm.objects(NameModel)
        nameCompany.sorted("name")
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
            self.textForCustomName = text.text!
            self.saveInDB(self.textForCustomName)
            self.getDataBase()
            tableView.reloadData()
        }))
        viewController.presentViewController(alert, animated: true, completion: nil)
    }
}