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
        print(self.viewModel.arrayCompanies)
        // Do any additional setup after loading the view.
    }

}

extension NameCompanyViewController {
    
    func setupTableView(tableView:UITableView) {
        tableView.registerNib(UINib(nibName: "NameCompanyTableViewCell",bundle: nil), forCellReuseIdentifier: "NameCompany")
    }
    
}

extension NameCompanyViewController: UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.arrayCompanies.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("NameCompany") as! NameCompanyTableViewCell
        cell.nameCompanyLabel.text = self.viewModel.arrayCompanies[indexPath.row].name
        return cell
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 3
    }
    
}


extension NameCompanyViewController: UITableViewDelegate {

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        switch indexPath.section {
        case 0:
            return 45
        default:
            return 0
        }
    }
}