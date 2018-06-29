//
//  PassengerAnnotation.swift
//  UberClone
//
//  Created by Hiem Seyha on 6/29/18.
//  Copyright © 2018 son chanthem. All rights reserved.
//

import Foundation
import MapKit


class PassengerAnnotation: NSObject, MKAnnotation {
   dynamic var coordinate: CLLocationCoordinate2D
   
   var key: String
   
   init(coordinate: CLLocationCoordinate2D, key: String) {
      self.coordinate = coordinate
      self.key = key
      super.init()
   }
   
   
}
