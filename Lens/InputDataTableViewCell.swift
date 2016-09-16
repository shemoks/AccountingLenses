//
//  InputDataTableViewCell.swift
//  Lens
//
//  Created by admin on 15.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

protocol SwipeToUp: class {
    func swipetoUp(cell:InputDataTableViewCell)
}

class InputDataTableViewCell: UITableViewCell {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var delegate:SwipeToUp!
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
}


extension InputDataTableViewCell : UITextFieldDelegate {
    
    func textFieldDidBeginEditing(textField: UITextField) {
        self.delegate.swipetoUp(self)
    }
    
}