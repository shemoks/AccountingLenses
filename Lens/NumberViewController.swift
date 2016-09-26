//
//  NumberViewController.swift
//  Lens
//
//  Created by admin on 21.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class NumberViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel = NumberViewModel()
    var delegate:PassDataInt!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Numbers of Lenses"
        self.setupTableView(tableView)
        self.viewModel.parseLocalJSON()
        self.viewModel.getDataFromDb()
    }
}

private extension NumberViewController {
    
    func setupTableView(tableView:UITableView) {
        tableView.registerNib(UINib(nibName: "NumberTableViewCell",bundle: nil), forCellReuseIdentifier: "NumberCell")
    }
}

extension NumberViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.viewModel.numberOfRows()
        case 2:
            return self.viewModel.arrayNumber.count
        default:
            print("Error")
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NumberCell") as! NumberTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.countLensesLabel.text = "Tap on me"
        case 1:
            self.viewModel.cellForDataBaseRow(cell, indexPath: indexPath)
        case 2:
            self.viewModel.cellForJson(cell, indexPath: indexPath)
        default:
            print("Error")
        }
        
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selecteIndexPath = tableView.indexPathForSelectedRow
        let currentCell = tableView.cellForRowAtIndexPath(selecteIndexPath!) as! NumberTableViewCell
        
        switch indexPath.section {
        case 0:
            self.viewModel.showAlert(self, tableView: tableView)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        case 1:
            self.delegate.passDataInt(Int(currentCell.countLensesLabel.text!)!)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.navigationController?.popViewControllerAnimated(true)
        case 2:
            self.delegate.passDataInt(Int(currentCell.countLensesLabel.text!)!)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            self.navigationController?.popViewControllerAnimated(true)
        default:
            print("Error")
        }
    }
}

extension NumberViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Please enter number lenses manual"
        case 1:
            return "Choose from DB"
        case 2:
            return "Choose from default"
        default:
            print("Error")
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 55
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 30
        case 1:
            return 30
        case 2:
            return 30
        default:
            print("Error")
        }
        return 0
    }
    
}