//
//  SliderView.swift
//  Lens
//
//  Created by Mac on 9/20/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import RealmSwift


class SliderView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    

    @IBOutlet weak var slider: UIView!
    @IBOutlet weak var collection: UICollectionView!
    var view: UIView!
    @IBOutlet weak var dateLabel: UILabel!
    var arrayOfPasks: Results<Pask>!
    var arrayOfDates: [massDates] = []
    var currentDate: NSDate = NSDate()
    var coordFirst: CGPoint = CGPoint(x: 0.0, y: 0.0)
    var nibName: String = "SliderView"
    typealias CollectionAction = (UIAlertController) -> ()
    var onTouch: CollectionAction?
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        setup()
        
    }
    
    func setup() {
        view = loadViewFromNib()
        view.frame = bounds
        view.autoresizingMask = [.FlexibleWidth, .FlexibleHeight]
       
        addSubview(view)
        let swipeRight = UIPanGestureRecognizer(target: self,action: #selector(handleLongPress(_:)))
//        swipeRight.minimumPressDuration = 0.5
//        swipeRight.delaysTouchesBegan = true
//        swipeRight.delegate = self
       //                swipe.minimumPressDuration = 0.5
//                swipe.delaysTouchesBegan = true
//                swipe.delegate = self
       
        slider.addGestureRecognizer(swipeRight)
     
        self.collection.registerNib(UINib(nibName: "LastCollection",bundle: nil), forCellWithReuseIdentifier: "LastCollection")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        layout.itemSize = CGSize(width: 400, height: 40)
        self.collection.scrollEnabled = false
        layout.scrollDirection = .Vertical
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
    
    func handleLongPress(recognizer:UIPanGestureRecognizer) {
     //    collection.contentOffset = coordFirst
        let translation = recognizer.translationInView(self.view)
        
        recognizer.setTranslation(CGPointZero, inView: self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:slider.center.x,
                                  y:slider.center.y + translation.y)
        }
        switch(recognizer.state) {
            
        case UIGestureRecognizerState.Began:
            if collection.contentOffset.y + 20 * translation.y < slider.center.y {
        collection!.setContentOffset(CGPoint(x: 0 , y: collection.contentOffset.y + 20 * translation.y), animated: true)
            
            }
        case UIGestureRecognizerState.Changed:
            if translation.y > 0 {
                if collection.contentOffset.y + 20 * translation.y <= view.center.y {
                    collection!.setContentOffset(CGPoint(x: 0 , y: collection.contentOffset.y + 20 * translation.y), animated: true)
            }
            } else {
                if collection.contentOffset.y  + 20 * translation.y >= -(view.center.y) {
                    collection!.setContentOffset(CGPoint(x: 0 , y: collection.contentOffset.y + 20 * translation.y), animated: true)
                }
            }
        case UIGestureRecognizerState.Ended:
            let velocity = recognizer.velocityInView(self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200

            let slideFactor = 0.1 * slideMultiplier
            var finalPoint = CGPoint(x:slider.center.x ,
                                     y:recognizer.view!.center.y + (velocity.y * slideFactor))
            finalPoint.x = slider.center.x
            finalPoint.y = view.center.y + translation.y

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
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LastCollection", forIndexPath: indexPath) as! LastCollection
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        cell.textLabel.textColor = arrayOfDates[indexPath.item].color
       cell.textLabel.text = dateFormatter.stringFromDate(arrayOfDates[indexPath.item].date)

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd MMM yyyy"
        let alertController = UIAlertController(title: "Change date", message:
            "you select \(dateFormatter.stringFromDate(arrayOfDates[indexPath.item].date)) date", preferredStyle: UIAlertControllerStyle.Alert)
        let okButton = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            
          let numberDays = HelperDates.subtructCustomDates(self.arrayOfDates[7].date, second: self.arrayOfDates[indexPath.item].date)
          HelperPask().addValueToDate(self.arrayOfDates[7].date, value: numberDays, pasks: self.arrayOfPasks)
            }
        alertController.addAction(UIAlertAction(title: "Cancel", style: .Cancel, handler: { (action: UIAlertAction!) in
            
        }))
        alertController.addAction(okButton)
  //      self.(alertController, animated: true, completion: nil)
  //   self.dateLabel.text = dateFormatter.stringFromDate(arrayOfDates[indexPath.item].date)
     self.onTouch!(alertController)
    }
}


