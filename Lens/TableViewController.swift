//
//  TableViewController.swift
//  Lens
//
//  Created by Mac on 9/15/16.
//  Copyright © 2016 Mac. All rights reserved.
//


import UIKit
import RealmSwift


class TableViewController: UITableViewController {
    
    var arrayOfPasks: Results<Pask>!
    var number: Int = 0
    var paskFirst = List<Dates>()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.getArray { objects in
            if !objects.isEmpty {
                self.tableView.registerNib(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")
                for object in objects {
                    let dates = object.dates
                    for date in dates {
                        self.paskFirst.append(date)
                    }
                }
                self.tableView.reloadData()
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        
        return paskFirst.count
    }
    
    func getArray(obj: (Results<Pask>) -> ()){
        arrayOfPasks = HelperPask.getActivePask()
        dispatch_async(dispatch_get_main_queue(), {
            obj(self.arrayOfPasks)
        })
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("EventCell", forIndexPath: indexPath) as? TableViewCell
        cell?.dateLabel.text = returnDate(paskFirst[indexPath.row].dateChange)
        cell?.messageLabel.text = paskFirst[indexPath.row].message
        return cell!
    }
    
    func returnDate (date: NSDate) -> String {
        let calendar = NSCalendar.currentCalendar()
        let components = calendar.components([.Day , .Month , .Year], fromDate: date)
        let year =  components.year
        let month = components.month
        let day = components.day
        var result = ""
        switch month {
        case 1: result = "Jenuary"
        case 2: result = "February"
        case 3: result = "March"
        case 4: result = "April"
        case 5: result = "May"
        case 6: result = "June"
        case 7: result = "July"
        case 8: result = "August"
        case 9: result = "September"
        case 10: result = "October"
        case 11: result = "November"
        case 12: result = "Desember"
        default: result = ""
        }
        result = String(day) + " " + result + " " + String(year)
        return result
    }
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
     if editingStyle == .Delete {
     // Delete the row from the data source
     tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
     } else if editingStyle == .Insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
}
