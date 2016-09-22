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
        self.viewModel.getArray{object in
        
        }
        self.title = "Add New Lens"

        self.setupTableView(tableView)
    }
}

extension NewViewController:UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return self.viewModel.arrayNameTitle.count
        case 1:
            return Term.count
        case 2:
            return 1
        case 3:
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
            if aCell.textField.text != "" {
                self.viewModel.dateArray.append(aCell.textField.text!)
            }
            cell = aCell
        case 1:
            let aCell = tableView.dequeueReusableCellWithIdentifier("Period") as! PeriodTableViewCell
            aCell.labelForPeriod.text = Term.arrayEnum[indexPath.row].nameOfNumber()
            cell = aCell
        case 2:
            let aCell = tableView.dequeueReusableCellWithIdentifier("Date") as! DateTableViewCell
            aCell.selectionStyle = .None
            aCell.titleLabel.text = "Date"
            aCell.textField.placeholder = "Please set up date"
            if aCell.textField.text != "" {
                self.viewModel.dateArray.append(aCell.textField.text!)
            }
            cell = aCell
        case 3:
            let aCell = tableView.dequeueReusableCellWithIdentifier("Save") as! SaveTableViewCell
            aCell.delegate = self
            cell = aCell
        default:
            cell = nil
            print("Error")
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 4
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Must be entered"
        case 1:
            return "Period of using"
        case 2:
            return "Date"
        case 3:
            return nil
        default:
            print("Error")
        }
        return "Error"
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        case 1:
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            
            if indexPath.row != self.viewModel.lastSelectedIndexPath?.row {
                if let lastSelectedIndexPath = self.viewModel.lastSelectedIndexPath {
                    let oldCell = tableView.cellForRowAtIndexPath(lastSelectedIndexPath)
                    oldCell?.accessoryType = .None
                }
                
                let newCell = tableView.cellForRowAtIndexPath(indexPath)
                newCell?.accessoryType = .Checkmark
                self.viewModel.dateArray = []
                self.viewModel.dateArray.append("\(Term.arrayEnum[indexPath.row].rawValue)")
                self.viewModel.lastSelectedIndexPath = indexPath
            }
        default:
            print("Error")
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
        case 3:
            return 40
        default:
            print("Error")
            return 0
        }
    }
   
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        if section == 3{
            return 10
        }
        return 30
    }
}

private extension NewViewController {
    
    func setupTableView(tableView:UITableView) {
        tableView.registerNib(UINib(nibName:"InputDataTableViewCell",bundle: nil), forCellReuseIdentifier:"Cell")
        tableView.registerNib(UINib(nibName:"PeriodTableViewCell",bundle: nil), forCellReuseIdentifier: "Period")
        tableView.registerNib(UINib(nibName:"DateTableViewCell",bundle: nil), forCellReuseIdentifier: "Date")
        tableView.registerNib(UINib(nibName:"SaveTableViewCell",bundle: nil), forCellReuseIdentifier: "Save")
    }
}

extension NewViewController:SaveButtonTapp {
    
    func saveButtonTapp(cell: SaveTableViewCell) {
        tableView.reloadData()
        self.viewModel.saveInDataBase(self)
    }
}
