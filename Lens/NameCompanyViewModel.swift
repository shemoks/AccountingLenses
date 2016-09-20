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
        
        let realm = try! Realm()
        
        try! realm.write{
            realm.add(nameCompany)
        }
    }
    
    func getDataBase() {
        let realm = try! Realm()
        nameCompany = realm.objects(NameModel)
        nameCompany.sorted("name")
        print(nameCompany.sorted("name"))
    }
    
    func deleteFromDataBase(indexPath:Int) {
        let realm = try! Realm()
        let some = realm.objects(NameModel.self)
        let item = some[indexPath]
        
        try! realm.write{
            realm.delete(item)
        }
    }
    
}