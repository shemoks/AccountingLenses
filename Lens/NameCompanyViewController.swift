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
        // Do any additional setup after loading the view.
    }
    
}

extension NameCompanyViewController {
    
    func setupTableView(tableView:UITableView) {
        tableView.registerNib(UINib(nibName: "NameCompanyTableViewCell",bundle: nil), forCellReuseIdentifier: "NameCompany")
        tableView.registerNib(UINib(nibName: "CustomNameCompanyTableViewCell",bundle: nil), forCellReuseIdentifier: "CustomCell")
    }
    
}

extension NameCompanyViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return self.viewModel.nameCompany.count
        case 2:
            return self.viewModel.arrayCompanies.count
        default:
            return 0
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell!
        
        switch indexPath.section {
        case 0:
            let aCell = tableView.dequeueReusableCellWithIdentifier("CustomCell") as! CustomNameCompanyTableViewCell
            aCell.nameLabel.text = "Tapp on me"
            cell = aCell
        case 1:
            let aCell = tableView.dequeueReusableCellWithIdentifier("NameCompany") as! NameCompanyTableViewCell
            aCell.nameCompanyLabel.text = self.viewModel.nameCompany.sorted("name")[indexPath.row].name
            cell = aCell
        case 2:
            let aCell = tableView.dequeueReusableCellWithIdentifier("NameCompany") as! NameCompanyTableViewCell
            aCell.nameCompanyLabel.text = self.viewModel.arrayCompanies[indexPath.row].name
            cell = aCell
        default:
            cell = nil
            print("Some Error")
        }
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
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
            print("Tapp 1")
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