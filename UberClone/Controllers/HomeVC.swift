//
//  ViewController.swift
//  UberClone
//
//  Created by son chanthem on 12/15/17.
//  Copyright © 2017 son chanthem. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

    @IBOutlet weak var actionButton: RoundedShadowButton!
    
    var delegate: CenterVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
    }

    @IBAction func didPressMenuButton(_ sender: Any) {
        delegate?.toggleLeftPanel()
    }
    @IBAction func actionButton(_ sender: Any) {
        
        actionButton.animateButton(shouldLoad: true, withMessage: nil)
    }
}

