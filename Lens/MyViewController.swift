//
//  MyViewController.swift
//  Lens
//
//  Created by Mac on 9/19/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import RealmSwift

class MyViewController: UIViewController {
    var arrayOfPasks: Results<Pask>!
    var arrayOfDates: [NSDate] = []
    
    @IBOutlet weak var collectionView: View!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert , .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        getArrayOfDates { object in
          
            self.collectionView.arrayOfPasks = HelperPask.numberOfLenses(self.arrayOfPasks)
            self.collectionView.onTouch = { () in
            self.performSegueWithIdentifier("tableView", sender: self)
            }
            self.collectionView.collectionView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getArray(obj: (Results<Pask>) -> ()){
        arrayOfPasks = HelperPask.getAllPask()
        dispatch_async(dispatch_get_main_queue(), {
            obj(self.arrayOfPasks)
        })
    }
    
    func getArrayOfDates(obj: ([NSDate]) -> ()){
        getArray {object in
            if !object.isEmpty {
                self.removeDates {objects in
                    self.arrayOfDates = HelperPask().arrayOfDates(objects)
                }
            }
            dispatch_async(dispatch_get_main_queue(), {
                obj(self.arrayOfDates)
            })
        }
    }
    
    func removeDates(obj: (Results<Pask>) -> ()){
        arrayOfPasks = HelperPask.removePasc()
        dispatch_async(dispatch_get_main_queue(), {
            obj(self.arrayOfPasks)
        })
    }
}

