//
//  DatePicker.swift
//  Lens
//
//  Created by admin on 16.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class DatePicker: UIView {

    @IBOutlet weak var datePicker: UIDatePicker!
    
    var didSelectDate:((NSDate) -> Void)?
   
    override func awakeFromNib() {
        super.awakeFromNib()
        datePicker.minimumDate = NSDate()
    }

    @IBAction func datePickerChanges(sender: AnyObject) {
        self.didSelectDate?(self.datePicker.date)
    }
}

