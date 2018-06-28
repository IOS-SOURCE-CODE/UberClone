//
//  AccountType.swift
//  UberClone
//
//  Created by Hiem Seyha on 6/28/18.
//  Copyright © 2018 son chanthem. All rights reserved.
//

import Foundation


enum AccountType : String {
   
   case driver = "DRIVER"
   case passenger = "PASSENGER"
   
   var value: String {
      return self.rawValue
   }
}
