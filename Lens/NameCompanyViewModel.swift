//
//  NameCompanyViewModel.swift
//  Lens
//
//  Created by admin on 20.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

import Foundation
import SwiftyJSON

class NameCompanyViewModel {
    
    var arrayCompanies = [NameCompany]()
    
    func parseLocalJSON() -> [NameCompany] {
        if let path = NSBundle.mainBundle().pathForResource("NameCompanyJSON", ofType: "json"){
            do{
                let data = try NSData(contentsOfURL: NSURL(fileURLWithPath: path), options: NSDataReadingOptions.DataReadingMappedIfSafe)
                let json = JSON(data:data)
                let companies = json["companies"]
                for i in 0..<companies.count{
                    var nameCompany = NameCompany()
                    nameCompany.name = companies[i]["name"].stringValue
                    arrayCompanies.append(nameCompany)
                }
            }catch{
                print("Faild Name/Path")
            }
        }
        return arrayCompanies
    }
}