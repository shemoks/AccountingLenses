//
//  PaskController.swift
//  Lens
//
//  Created by Mac on 9/1/16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit
import RealmSwift

public struct InfoForNotification {
    var fireDate: NSDate
    let alertBody: String
}

class PaskController: UIViewController {
    var lastSelectedIndexPath: NSIndexPath? = nil
    var periodForBase = 0
    var arrayInfoNotification = [InfoForNotification]()
    
    @IBOutlet weak var numbersEdit: UITextField!
    @IBOutlet weak var opticalEdit: UITextField!
    @IBOutlet weak var nameEdit: UITextField!
    @IBOutlet weak var dateEdit: UITextField!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func datePicker(sender: AnyObject) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "dd-MM-yyyy"
        let strDate = dateFormatter.stringFromDate(datePicker.date)
        dateEdit.text = String(strDate)
    }
    
    @IBAction func saveClick(sender: AnyObject) {
        let minDate = self.datePicker.minimumDate
        let pask = Pask()
        let lens = Lens()
        let arrayLens = List<Lens>()
    
        if let optical = Double(opticalEdit.text!) {
            lens.opticalPower = optical
        }
        
        let period = self.periodForBase
        lens.termOfUsing = period
        
        if let name = self.nameEdit.text {
            pask.name = name
        }
        
        let expression = NSDateFormatter()
        expression.dateFormat = "dd-MM-yyyy"
        
        if let dateBuy = expression.dateFromString(self.dateEdit.text!) {
            if let numbers = Int(numbersEdit.text!) {
                pask.numberOfLens = numbers
                pask.dateBuy = dateBuy
                let dayCalendarUnit: NSCalendarUnit = [.Day]
                let tomorrow = NSCalendar.currentCalendar()
                    .dateByAddingUnit(
                        dayCalendarUnit,
                        value: period * Int(numbers/2),
                        toDate: dateBuy,
                        options: []
                )
                pask.dateFinish = tomorrow!
            }
        }
        
        pask.number = HelperPask.getNumberPask()
        arrayLens.append(lens)
        pask.lenses = arrayLens
       
        switch HelperPask.validation(pask, minDatePicker: minDate!) {
        case true:
            HelperPask.addToDataBase(pask)
            let info = InfoForNotification(fireDate: pask.dateFinish, alertBody: "You must buy pask of lenses")
            self.arrayInfoNotification.append(info)
            self.sendNotification()
        case false:
            let alertController = UIAlertController(title: "Error", message:
                "Complite all fields and select period!", preferredStyle: UIAlertControllerStyle.Alert)
            let okButton = UIAlertAction(title: "Ok", style: .Default, handler: nil)
            alertController.addAction(okButton)
            self.presentViewController(alertController, animated: true, completion: nil)
        }
    }
    
    func sendNotification() {
        let info = self.arrayInfoNotification
        Notification(atributiesOfNotifications: info).getNotification()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dateEdit.enabled = false
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
extension PaskController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Term.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        cell.textLabel!.text = Term.arrayEnum[indexPath.row].nameOfNumber()
        //     cell.accessoryType = (lastSelectedIndexPath?.row == indexPath.row) ? .Checkmark : .None
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row != lastSelectedIndexPath?.row {
            if let lastSelectedIndexPath = lastSelectedIndexPath {
                let oldCell = tableView.cellForRowAtIndexPath(lastSelectedIndexPath)
                oldCell?.accessoryType = .None
            }
            
            let newCell = tableView.cellForRowAtIndexPath(indexPath)
            newCell?.accessoryType = .Checkmark
            let arrayEnum = Term.arrayEnum
            let period: Term = arrayEnum[indexPath.row]
            self.periodForBase = period.rawValue
            lastSelectedIndexPath = indexPath
        }
    }
}
