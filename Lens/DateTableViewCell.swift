//
//  DateTableViewCell.swift
//  Lens
//
//  Created by admin on 16.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class DateTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: CustomTextField!
    
    @IBAction func textFieldAction(sender: CustomTextField) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}


