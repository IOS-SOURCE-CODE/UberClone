//
//  UIStoryboard.swift
//  UberClone
//
//  Created by Hiem Seyha on 6/27/18.
//  Copyright © 2018 son chanthem. All rights reserved.
//

import UIKit


extension UIStoryboard {
   func mainStoryboard(withIdentifier: String) -> UIViewController {
      let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
      return storyboard.instantiateViewController(withIdentifier: withIdentifier)
   }
}
