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
    var arrayOfDates: [NSDate] = []
    
    @IBOutlet weak var sliderView: SliderView!
    override func viewDidLoad() {
        super.viewDidLoad()
        getArrayOfDates { object in
          
          self.sliderView.arrayOfDates = object
            self.sliderView.onTouch = {
                print("hello")
            }
          self.sliderView.collection.reloadData()
            
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
