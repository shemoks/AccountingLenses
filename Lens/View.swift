//
//  View.swift
//  Lens
//
//  Created by Mac on 9/19/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class View: UIView, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    var view: UIView!
    var arrayOfPasks: [Collection] = []
    typealias CollectionAction = () -> ()
    @IBOutlet weak var collectionView: UICollectionView!
    var nibName: String = "View"
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
        self.collectionView.registerNib(UINib(nibName: "CollectionViewCell",bundle: nil), forCellWithReuseIdentifier: "CollectionViewCell")
        self.collectionView.registerNib(UINib(nibName: "LastCollection",bundle: nil), forCellWithReuseIdentifier: "LastCollection")
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        layout.itemSize = CGSize(width: 120, height: 118)
        layout.scrollDirection = .Horizontal
        self.collectionView.setCollectionViewLayout(layout, animated: false)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
    }
    
    func loadViewFromNib() -> UIView {
       
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        
        return view
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return arrayOfPasks.count + 1
    }
    
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        if indexPath.item == arrayOfPasks.count  {
            let cell = collectionView.dequeueReusableCellWithReuseIdentifier("LastCollection", forIndexPath: indexPath) as! LastCollection
            
            return cell
        }
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! CollectionViewCell
        cell.nameLabel.text = arrayOfPasks[indexPath.item].name
        cell.numberLabel.text = String(arrayOfPasks[indexPath.item].number)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if indexPath.item == arrayOfPasks.count {
          self.onTouch!()
        }
    }
}
