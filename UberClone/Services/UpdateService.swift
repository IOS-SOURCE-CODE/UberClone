//
//  UpdateService.swift
//  UberClone
//
//  Created by Hiem Seyha on 6/27/18.
//  Copyright © 2018 son chanthem. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class UpdateService {
   static var instance = UpdateService()
   
   func updateUserLocation(withCoordinate coordinate: CLLocationCoordinate2D) {
      DataService.instance.REF_USERS.observeSingleEvent(of: .value) { (snapshot) in
         if let userSnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
            for user in userSnapshot {
               if user.key == FIRAuth.auth()?.currentUser?.uid {
                  DataService.instance.REF_USERS.child(user.key).updateChildValues([UserSnapshot.coordinate.rawValue: [coordinate.latitude, coordinate.longitude]])
               }
            }
         }
      }
   }
   
   
   func updateDriverLocation(with coordinate: CLLocationCoordinate2D) {
      DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (snapshot) in
         if let driverSnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
            for driver in driverSnapshot {
               if driver.key == FIRAuth.auth()?.currentUser?.uid {
                  if driver.childSnapshot(forPath: DriverSnapshot.isPickupModeEnable.rawValue).value as? Bool == true {
                     DataService.instance.REF_DRIVERS.child(driver.key).updateChildValues([DriverSnapshot.coordinate.rawValue: [coordinate.latitude, coordinate.longitude]])
                  }
               }
            }
         }
      }
   }
   
}
