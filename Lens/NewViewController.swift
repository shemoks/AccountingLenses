//
//  NewViewViewController.swift
//  Lens
//
//  Created by admin on 15.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//


import UIKit

class NewViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var arrayNameTitle = ["Title","Optical Power","Numbers of lens","Purchase date"]
    var arrayPlaceholder = ["NameCompany","Power lins","Count","Date"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView(tableView)
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}

extension NewViewController:UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return arrayNameTitle.count
        case 1:
            return Term.arrayEnum.count
        case 2:
            return 1
        default:
            print("Error")
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        
        switch indexPath.section {
        case 0:
            let aCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! InputDataTableViewCell
            aCell.titleLabel.text = arrayNameTitle[indexPath.row]
            aCell.textField.placeholder = arrayPlaceholder[indexPath.row]
            cell = aCell
        case 1:
            let aCell = tableView.dequeueReusableCellWithIdentifier("Period") as! PeriodTableViewCell
            aCell.labelForPeriod.text = Term.arrayEnum[indexPath.row].nameOfNumber()
            cell = aCell
        case 2:
            let aCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! InputDataTableViewCell
            cell = aCell
        default:
            cell = nil
            print("Error")
        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Must be entered"
        case 1:
            return "Period of using"
        case 2:
            return "Date"
        default:
            print("Error")
        }
        return "Error"
    }
}

extension NewViewController:UITableViewDelegate {
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 70
        case 1:
            return 40
        case 2:
            return 70
        default:
            print("Error")
            return 0
        }
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
}

private extension NewViewController {
    func setupTableView(tableView:UITableView) {
        tableView.registerNib(UINib(nibName:"InputDataTableViewCell",bundle: nil), forCellReuseIdentifier:"Cell")
        tableView.registerNib(UINib(nibName:"PeriodTableViewCell",bundle: nil), forCellReuseIdentifier: "Period")
    }
}
