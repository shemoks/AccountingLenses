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
    var periodForBase: Int = 0
    var arrayInfoNotification: [InfoForNotification] = []
    var arrayPasks: Results<Pask>!
    
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
        let arrayDays = List<Dates>()
        
        if let optical = Double(self.opticalEdit.text!) {
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
            if let numbers = Int(self.numbersEdit.text!) {
                pask.numberOfLens = numbers
                if self.arrayPasks.count > 0 {
                    let lastValue = self.arrayPasks.last?.dateFinish
                    pask.dateBuy = lastValue!
                } else {
                    pask.dateBuy = dateBuy
                }
                let tomorrow = HelperDates.addValueToDate(pask.dateBuy, value: period * Int(numbers/2))
                pask.dateFinish = tomorrow
                let dates = HelperPask().datesForOnePask(numbers, numberOfDeys: period, dateOfBuy: pask.dateBuy)
                for date in dates {
                    let event = Dates()
                    event.dateChange = date
                    if date != dates.last {
                        event.message = "change lenses"
                    } else {
                        event.message = "change pask"
                    }
                    arrayDays.append(event)
                }
                pask.dates = arrayDays
            }
        }
        pask.number = HelperPask.getNumberPask()
        arrayLens.append(lens)
        pask.lenses = arrayLens
        if  HelperPask.validation(pask, minDatePicker: minDate!) {
            self.arrayInfoNotification = []
            HelperPask.addToDataBase(pask)
            for events in pask.dates {
                let message = events.message
                let date = events.dateChange
                let info = InfoForNotification(fireDate: date, alertBody: message)
                self.arrayInfoNotification.append(info)
                self.sendNotification()
            }
        } else {
            let alertController = UIAlertController(title: "Error", message:
                "Complite all fields and select period!", preferredStyle: UIAlertControllerStyle.Alert)
            let okButton = UIAlertAction(title: "Ok", style: .Default) { action -> Void in
            }
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
        getArray { object in
            self.dateEdit.enabled = false
            self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
            self.tableView.dataSource = self
            self.tableView.delegate = self
            self.tableView.reloadData()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func getArray(obj: (Results<Pask>) -> ()){
        self.arrayPasks = HelperPask.getActivePask()
        dispatch_async(dispatch_get_main_queue(), {
            obj(self.arrayPasks)
        })
    }
}


extension PaskController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let count = Term.count
        return count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let arrayEnum = Term.arrayEnum
        let cell: UITableViewCell = self.tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell
        let row: Term = arrayEnum[indexPath.row]
        let stringForCell = row.nameOfNumber()
        cell.textLabel!.text = stringForCell
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