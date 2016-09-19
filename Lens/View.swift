//
//  View.swift
//  Lens
//
//  Created by Mac on 9/19/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class View: UIView {
    var view: UIView!
    var arrayOfPasks: [Collection] = []
    typealias CollectionAction = (Bool) -> ()
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
    }
    
    func loadViewFromNib() -> UIView {
        let bundle = NSBundle(forClass: self.dynamicType)
        let nib = UINib(nibName: nibName, bundle: bundle)
        let view = nib.instantiateWithOwner(self, options: nil)[0] as! UIView
        return view
    }

}
