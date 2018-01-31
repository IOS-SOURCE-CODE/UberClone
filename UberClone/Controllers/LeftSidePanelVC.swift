//
//  LeftSidePanelVC.swift
//  UberClone
//
//  Created by son chanthem on 12/19/17.
//  Copyright © 2017 son chanthem. All rights reserved.
//

import UIKit

class LeftSidePanelVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func SignUpLoginButton(_ sender: Any) {
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginVC
        self.present(vc, animated: true, completion: nil)
    }
}
