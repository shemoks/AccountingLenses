//
//  OpticalPowerViewController.swift
//  Lens
//
//  Created by admin on 21.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class OpticalPowerViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel = OpticalPowerViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Optical Power"
        self.setupTableView(tableView)
        self.viewModel.getDataFromDataBase()
        self.viewModel.parseLocalJSON()
    }
}

extension OpticalPowerViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("OpticalPowerCell") as! OpticalPowerTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.titleLabel.text = "Tap on me"
            cell.tittleForOpticalPowerLabel.text = ""
        case 1:
            self.viewModel.cellForDataBaseRow(cell, indexPath: indexPath)
        case 2:
            self.viewModel.cellForJSONRow(cell, indexPath: indexPath)
        default:
            print("Error")
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.viewModel.numberOfRow()
        case 2:
            return self.viewModel.arrayOpticalPower.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch indexPath.section {
        case 0:
            self.viewModel.showAlert(self, tableView: tableView)
            print("Tap 1")
        case 1:
            print("Tap 2")
        case 2:
            print("Tap 3")
        default:
            print("Error")
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.viewModel.numberOfSection
    }
}

extension OpticalPowerViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Please enter optical power manual"
        case 1:
            return "Choose from DB"
        case 2:
            return "Choose from popular"
        default:
            print("Error")
        }
        return nil
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        switch section {
        case 0:
            return 30
        case 1:
            return 15
        case 2:
            return 15
        default:
            print("Error")
        }
        return 0
    }
}

private extension OpticalPowerViewController {
    
    func setupTableView(tableView:UITableView) {
        tableView.registerNib(UINib(nibName: "OpticalPowerTableViewCell",bundle: nil), forCellReuseIdentifier: "OpticalPowerCell")
    }
}