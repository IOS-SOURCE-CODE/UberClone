//
//  RoundedCornerTextField.swift
//  UberClone
//
//  Created by son chanthem on 12/25/17.
//  Copyright © 2017 son chanthem. All rights reserved.
//

import UIKit

class RoundedCornerTextField: UITextField {
    
    var textRectOffset: CGFloat = 20
    
    private var textRect: CGRect {
        return CGRect(x: 0 + textRectOffset, y: 0 + (textRectOffset / 2), width: self.frame.width - textRectOffset, height: self.frame.height + textRectOffset )
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    
    func setupView() {
        self.layer.cornerRadius = self.frame.height / 2
        self.clipsToBounds = true
    }
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return textRect
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect
    }
    
    override func placeholderRect(forBounds bounds: CGRect) -> CGRect {
        return  CGRect(x: 0 + textRectOffset, y: 0 - (textRectOffset / 2), width: self.frame.width - textRectOffset, height: self.frame.height + textRectOffset )
    }
    
    
    
}
