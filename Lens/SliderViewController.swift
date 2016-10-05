//
//  SliderViewController.swift
//  Lens
//
//  Created by Mac on 9/21/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import RealmSwift

class SliderViewController: UIViewController {
    var arrayOfPasks: Results<Pask>!
    var arrayOfDates: [massDates] = []
    typealias ButtonAction = () -> ()
    var onTouch: ButtonAction?
    
    @IBOutlet weak var sliderView: ScrollComponent!
    override func viewDidLoad() {
        super.viewDidLoad()
          
        self.sliderView.arrayOfDates = self.arrayOfDates
        self.sliderView.arrayOfPasks = self.arrayOfPasks
        self.sliderView.onTouch = self.onTouch       //self.sliderView.collection.reloadData()
//            
//        }
    }

  
        // Do any additional setup after loading the view.

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
