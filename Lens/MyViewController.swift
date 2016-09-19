//
//  MyViewController.swift
//  Lens
//
//  Created by Mac on 9/19/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import RealmSwift

class MyViewController: UIViewController, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var arrayOfPasks: Results<Pask>!
    var arrayOfDates: [NSDate] = []
    var arrayForCollection: [Collection] = []
    
    @IBOutlet weak var collectionView: View!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let notificationSettings = UIUserNotificationSettings(forTypes: [.Alert , .Badge, .Sound], categories: nil)
        UIApplication.sharedApplication().registerUserNotificationSettings(notificationSettings)
        getArrayOfDates { object in
            self.arrayForCollection = HelperPask.numberOfLenses(self.arrayOfPasks)
            self.collectionView.collectionView.registerNib(UINib(nibName: "CollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
            self.collectionView.collectionView.registerNib(UINib(nibName: "LastCollection",bundle: nil), forCellWithReuseIdentifier: "LastCollection")
            let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
                    layout.sectionInset = UIEdgeInsets(top: 20, left: 10, bottom: 10, right: 10)
                    layout.itemSize = CGSize(width: 70, height: 150)
            self.collectionView.collectionView.setCollectionViewLayout(layout, animated: false)
            self.collectionView.collectionView.delegate = self
            self.collectionView.collectionView.dataSource = self
            self.collectionView.collectionView.reloadData()
        }
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
  
        return arrayOfPasks.count + 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.item == arrayForCollection.count  {
             let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LastCollection", forIndexPath: indexPath) as! LastCollection
            
        return cell
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.nameLabel.text = arrayForCollection[indexPath.item].name
        cell.numberLabel.text = String(arrayForCollection[indexPath.item].number)
        return cell
    }
   
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == arrayForCollection.count  {
    
         performSegueWithIdentifier("tableView", sender: self)
        }
}
}


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }

  */
