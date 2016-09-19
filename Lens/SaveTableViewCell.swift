//
//  SaveTableViewCell.swift
//  Lens
//
//  Created by admin on 19.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

protocol SaveButtonTapp:class {
    func saveButtonTapp(cell:SaveTableViewCell)
}

class SaveTableViewCell: UITableViewCell {

    var delegate:SaveButtonTapp!
    
    @IBAction func saveActionTap(sender: AnyObject) {
        self.delegate.saveButtonTapp(self)
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
