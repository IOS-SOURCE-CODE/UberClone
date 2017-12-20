//
//  RoundImageView.swift
//  UberClone
//
//  Created by son chanthem on 12/17/17.
//  Copyright © 2017 son chanthem. All rights reserved.
//

import UIKit

class RoundImageView: UIImageView {

    override func awakeFromNib() {
        setupRoundImage()
    }
    
    func setupRoundImage() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }

}
