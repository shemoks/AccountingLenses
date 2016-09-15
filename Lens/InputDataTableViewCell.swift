//
//  InputDataTableViewCell.swift
//  Lens
//
//  Created by admin on 15.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class InputDataTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
