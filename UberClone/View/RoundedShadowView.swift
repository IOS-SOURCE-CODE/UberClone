//
//  RoundedShadowView.swift
//  UberClone
//
//  Created by son chanthem on 12/17/17.
//  Copyright © 2017 son chanthem. All rights reserved.
//

import UIKit

class RoundedShadowView: UIView {
    
    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = 5.0
        self.layer.shadowRadius = 5.0
        self.layer.shadowOpacity = 0.3
        self.layer.shadowColor = UIColor.darkGray.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 5)
    }

}
