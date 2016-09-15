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
    
    var viewModel = NewViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupTableView(tableView)
        // Do any additional setup after loading the view.
    }
 
}

extension NewViewController:UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return self.viewModel.arrayNameTitle.count
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
            aCell.titleLabel.text = self.viewModel.arrayNameTitle[indexPath.row]
            aCell.textField.placeholder = self.viewModel.arrayPlaceholder[indexPath.row]
            aCell.selectionStyle = .None
            cell = aCell
        case 1:
            let aCell = tableView.dequeueReusableCellWithIdentifier("Period") as! PeriodTableViewCell
            aCell.labelForPeriod.text = Term.arrayEnum[indexPath.row].nameOfNumber()
            cell = aCell
        case 2:
            let aCell = tableView.dequeueReusableCellWithIdentifier("Cell") as! InputDataTableViewCell
            aCell.selectionStyle = .None
            aCell.titleLabel.text = "Date"
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
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        
        if indexPath.row != self.viewModel.lastSelectedIndexPath?.row {
            if let lastSelectedIndexPath = self.viewModel.lastSelectedIndexPath {
                let oldCell = tableView.cellForRowAtIndexPath(lastSelectedIndexPath)
                oldCell?.accessoryType = .None
            }
            
            let newCell = tableView.cellForRowAtIndexPath(indexPath)
            newCell?.accessoryType = .Checkmark
            let period = Term.arrayEnum[indexPath.row]
            //self.periodForBase = period.rawValue
            self.viewModel.lastSelectedIndexPath = indexPath
        }
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
