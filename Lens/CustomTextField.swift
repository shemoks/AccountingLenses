//
//  CustomTextField.swift
//  Lens
//
//  Created by admin on 16.09.16.
//  Copyright © 2016 Mac. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {
    
    var dateFormatter: NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateStyle = .MediumStyle
        dateFormatter.timeStyle = .ShortStyle
        dateFormatter.doesRelativeDateFormatting = true
        return dateFormatter
        
    }
    
    var yearDateFormatter: NSDateFormatter {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "yyyy"
        return dateFormatter
    }
    
    var viewModel = DatePicker()
    var date: NSDate?
 
    let picker = DatePicker.fromNib()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupDatePicker()
        self.setupTextField()
        
        picker.didSelectDate = { (date: NSDate ) -> () in
            self.text = self.dateFormatter.stringFromDate(date)
        }
    }
}

private extension CustomTextField {
    
    func setupDatePicker()  {
        self.picker.didSelectDate = { [weak self] date in
            self?.date = date
        }
        
        self.picker.doneButtonTapped = { [weak self] datePicker in
            self?.resignFirstResponder()
        }
    }
    
    func setupTextField() {
        self.inputView = self.picker
    }
    
}