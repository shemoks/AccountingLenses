//
//  ViewController.swift
//  Lens
//
//  Created by Mac on 8/31/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    @IBAction func buttonClick(sender: AnyObject) {
       let pasks = HelperPask.getAllPask()
       let arrayDates = HelperPask().arrayOfDates(pasks)
        print("\(arrayDates)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

