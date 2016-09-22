//
//  NameCompanyViewController.swift
//  Lens
//
//  Created by admin on 20.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class NameCompanyViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    var viewModel = NameCompanyViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Name Company"
        self.setupTableView(tableView)
        self.viewModel.parseLocalJSON()
        self.viewModel.getDataBase()
    }
}

extension NameCompanyViewController {
    
    func setupTableView(tableView:UITableView) {
        tableView.registerNib(UINib(nibName: "NameCompanyTableViewCell",bundle: nil), forCellReuseIdentifier: "NameCompany")
      }
}

extension NameCompanyViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.viewModel.numberOfRows()
        case 2:
            return self.viewModel.arrayCompanies.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        var cell = tableView.dequeueReusableCellWithIdentifier("NameCompany") as! NameCompanyTableViewCell
        
        switch indexPath.section {
        case 0:
            cell.nameCompanyLabel.text = "Tap on me"
        case 1:
            cell = self.viewModel.cellForRow(cell, indexPath: indexPath)
        case 2:
            cell.nameCompanyLabel.text = self.viewModel.arrayCompanies[indexPath.row].name
        default:
            print("Some Error")
        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.viewModel.numberOfSection
    }
    
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Please enter company manual"
        case 1:
            return "Choose from DB"
        case 2:
            return "Choose from popular"
        default:
            print("Error")
        }
        return nil
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        switch indexPath.section {
        case 0:
            self.viewModel.showAlert(self, tableView: tableView)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        case 1:
            print("Tapp 2")
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        case 2:
            print("Tapp 3")
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
        default:
            print("Error")
        }
    }

}

extension NameCompanyViewController: UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 45
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