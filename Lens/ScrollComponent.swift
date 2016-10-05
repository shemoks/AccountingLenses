//
//  ScrollComponent.swift
//  Lens
//
//  Created by Mac on 9/28/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import RealmSwift

class ScrollComponent: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIGestureRecognizerDelegate {

    @IBOutlet weak var holeView: UIView!
    @IBOutlet weak var slider: UIView!
    @IBOutlet weak var collection: UICollectionView!
    var view: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    var arrayOfPasks: Results<Pask>!
    var arrayOfDates: [massDates] = []
    var currentDate: NSDate = NSDate()
    var coordFirst: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var nibName: String = "ScrollComponent"
    var frameHole: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    var frameCell: CGRect = CGRect(x: 0, y: 0, width: 0, height: 0)
    typealias ButtonAction = () -> ()
    var onTouch: ButtonAction?
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
        
    }
    
    func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        frameHole = holeView.frame
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
        
        addSubview(view)
        let swipeRight = UIPanGestureRecognizer(target: self,action: #selector(handleLongPress(_:)))
        slider.addGestureRecognizer(swipeRight)
        self.collection.registerNib(UINib(nibName: "DateCell",bundle: nil), forCellWithReuseIdentifier: "DateCell")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 120, height: 64)
        self.collection.scrollEnabled = false
        layout.scrollDirection = .Horizontal
        self.collection.setCollectionViewLayout(layout, animated: false)
        self.collection.delegate = self
        self.collection.dataSource = self
        self.collection.reloadData()
        
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
   
    @IBAction func buttonClick(sender: AnyObject) {
        let  numberDays = 0
        let add = collection.contentOffset.x
        print("\(add)")
        print("\(frameHole.origin.x)")
        if add > 0 {
            var index = lroundf(Float(add/120))
            if index > Int(arrayOfDates.count/2) {
                index = index - 1
            }
            print ("\(index)")
            if index < arrayOfDates.count - 1 && index > 0 {
                print ("\(numberDays)")
                HelperPask().addValueToDate(self.arrayOfDates[1].date, value: index, pasks: self.arrayOfPasks)
                 UIApplication.sharedApplication().cancelAllLocalNotifications()
                 HelperPask.sendNotifications()
            }
            
        }
        onTouch?()
    }
    
    func handleLongPress(recognizer:UIPanGestureRecognizer) {
        //    collection.contentOffset = coordFirst
        let translation = recognizer.translationInView(self.view)
        
        recognizer.setTranslation(CGPointZero, inView: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y )
          
        }
        switch(recognizer.state) {
            
        case UIGestureRecognizerState.Began:
            if translation.x > 0 {
                //                if collection.contentOffset.x <= 4 * (view.center.x) {
                //                   collection!.setContentOffset(CGPoint(x: collection.contentOffset.x + 120, y: -(view.center.y) ), animated: true)
                let add = collection.contentOffset.x
              
                let index = lroundf(Float(add/120)) + 2
                  if index < arrayOfDates.count {
                collection.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
                  } else {
                      collection.scrollToItemAtIndexPath(NSIndexPath(forItem: index - 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
                }
            } else {
                //               if collection.contentOffset.x >= -(view.center.x )/2 {
                //                    collection!.setContentOffset(CGPoint(x: collection.contentOffset.x - 120 , y: -(view.center.y) ), animated: true)
                let add = collection.contentOffset.x
                let index = lroundf(Float(add/120))
                collection.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)

                //                }
            }
          
//            collection!.setContentOffset(CGPoint(x: view.center.x - translation.x, y: -(view.center.y) ), animated: true)

        case UIGestureRecognizerState.Changed:
            if translation.x > 0 {
//                if collection.contentOffset.x <= 4 * (view.center.x) {
//                   collection!.setContentOffset(CGPoint(x: collection.contentOffset.x + 120, y: -(view.center.y) ), animated: true)
                    let add = collection.contentOffset.x
                    let index = lroundf(Float(add/120)) + 2
                if index < arrayOfDates.count {
                    collection.scrollToItemAtIndexPath(NSIndexPath(forItem: index, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
                } else {
                    collection.scrollToItemAtIndexPath(NSIndexPath(forItem: index - 1, inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
                }

            } else {
//               if collection.contentOffset.x >= -(view.center.x )/2 {
//                    collection!.setContentOffset(CGPoint(x: collection.contentOffset.x - 120 , y: -(view.center.y) ), animated: true)
                let add = collection.contentOffset.x
                let index = Int(add/120)
                if index <= arrayOfDates.count{
                collection.scrollToItemAtIndexPath(NSIndexPath(forItem: index , inSection: 0), atScrollPosition: UICollectionViewScrollPosition.CenteredHorizontally, animated: true)
                }             }
            
        case UIGestureRecognizerState.Ended:
            let velocity = recognizer.velocityInView(self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
            
            let slideFactor = 0.1 * slideMultiplier
            var finalPoint = CGPoint(x:view.center.x ,
                                     y:recognizer.view!.center.y + (velocity.y * slideFactor))
            finalPoint.x = view.center.x + translation.x
            finalPoint.y = view.center.y
            
            UIView.animateWithDuration(Double(slideFactor * 2),
                                       delay: 0,
                                       options: UIViewAnimationOptions.CurveEaseOut,
                                       animations: {recognizer.view!.center = finalPoint },
                                       completion: nil)
           
       
            
            
        default:
            collection.cancelInteractiveMovement()
        }
        
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrayOfDates.count
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, shouldHighlightItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        if   arrayOfDates[indexPath.item].enabled == false {
            return false
        }
        return true
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("DateCell", forIndexPath: indexPath) as! DateCell
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        cell.textLabel.textColor = arrayOfDates[indexPath.item].color
        cell.textLabel.text = dateFormatter.stringFromDate(arrayOfDates[indexPath.item].date)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
//        let dateFormatter = NSDateFormatter()
//        dateFormatter.dateFormat = "dd MMM yyyy"
//        let alertController = UIAlertController(title: "Change date", message:
//            "you select \(dateFormatter.stringFromDate(arrayOfDates[indexPath.item].date)) date", preferredStyle: UIAlertControllerStyle.Alert)
//        let okButton = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
//            
//            let numberDays = HelperDates.subtructCustomDates(self.arrayOfDates[7].date, second: self.arrayOfDates[indexPath.item].date)
//            HelperPask().addValueToDate(self.arrayOfDates[7].date, value: numberDays, pasks: self.arrayOfPasks)
//        }
//        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
//            
//        }))
//        alertController.addAction(okButton)
//            self.onTouch!(alertController)
 }
    

}
