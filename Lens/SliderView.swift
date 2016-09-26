//
//  SliderView.swift
//  Lens
//
//  Created by Mac on 9/20/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit


class SliderView: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UIGestureRecognizerDelegate {
    

    @IBOutlet weak var slider: UIView!
    @IBOutlet weak var collection: UICollectionView!
    var view: UIView!
    var arrayOfDates: [NSDate] = []
    var currentDate: NSDate = NSDate()
    var nibName: String = "SliderView"
    typealias CollectionAction = () -> ()
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
        layout.sectionInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        layout.itemSize = CGSize(width: 160, height: 118)
        self.collection.scrollEnabled = false
        layout.scrollDirection = .Horizontal
        self.collection.setCollectionViewLayout(layout, animated: false)
        self.collection.delegate = self
        self.collection.dataSource = self
    }
    
    func loadViewFromNib() -> UIView {
        
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    func handleLongPress(recognizer:UIPanGestureRecognizer) {
        let translation = recognizer.translationInView(self.view)
        if let view = recognizer.view {
            view.center = CGPoint(x:view.center.x + translation.x,
                                  y:view.center.y )
        }
        recognizer.setTranslation(CGPointZero, inView: self.view)
        switch(recognizer.state) {
            
     //   case UIGestureRecognizerState.Began:
       //     self.collection.scrollEnabled = true
         
              //          collection!.setContentOffset(CGPoint(x: (arrayOfDates.count - 1) * 160 , y: 0), animated: true)
          
            
          //  self.collection?.scrollToItemAtIndexPath(NSIndexPath(forItem: 5, inSection: 5), atScrollPosition: .Top, animated: true)
//            guard let selectedIndexPath = self.collection.indexPathForItemAtPoint(recognizer.locationInView(self.collection)) else {
//                break
//            }
//            collection.beginInteractiveMovementForItemAtIndexPath(selectedIndexPath)
        case UIGestureRecognizerState.Changed:
            if translation.x > 0 {
             collection!.setContentOffset(CGPoint(x: (arrayOfDates.count - 1) * 160 , y: 0), animated: true)
            } else {
                 collection!.setContentOffset(CGPoint(x: 160 , y: 0), animated: true)
            }
        case UIGestureRecognizerState.Ended:
            collection.endInteractiveMovement()
            // 1
            let velocity = recognizer.velocityInView(self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            let slideMultiplier = magnitude / 200
            //   println("magnitude: \(magnitude), slideMultiplier: \(slideMultiplier)")
            
            // 2
            let slideFactor = 0.1 * slideMultiplier     //Increase for more of a slide
            // 3
            var finalPoint = CGPoint(x:recognizer.view!.center.x + (velocity.x * slideFactor),
                                     y:recognizer.view!.center.y )
            // 4
            finalPoint.x = view.center.x + translation.x
            finalPoint.y = view.center.y
            
            // 5
            UIView.animateWithDuration(Double(slideFactor * 2),
                                       delay: 0,
                                       // 6
                options: UIViewAnimationOptions.CurveEaseOut,
                animations: {recognizer.view!.center = finalPoint },
                completion: nil)
            collection.endInteractiveMovement()
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
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LastCollection", forIndexPath: indexPath) as! LastCollection
        cell.textLabel.text = String(arrayOfDates[indexPath.item])
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
       
            self.onTouch!()
    }
}


