//
//  ViewController.swift
//  UberClone
//
//  Created by son chanthem on 12/15/17.
//  Copyright © 2017 son chanthem. All rights reserved.
//

import UIKit
import MapKit
import RevealingSplashView
import CoreLocation
import Firebase

class HomeVC: UIViewController {
   
   @IBOutlet weak var actionButton: RoundedShadowButton!
   @IBOutlet weak var mapView: MKMapView!
   
   var delegate: CenterVCDelegate?
   var manager: CLLocationManager?
   var regionRadius: CLLocationDistance = 1000
   
   let revealSplashView = RevealingSplashView(iconImage: UIImage(named: "launchScreenIcon")!, iconInitialSize: CGSize(width:80, height:80), backgroundColor: UIColor.white)
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      manager = CLLocationManager()
      manager?.delegate = self
      manager?.desiredAccuracy = kCLLocationAccuracyBest
      
      checkLocationAuthStatus()
      
      mapView.delegate = self
      
      centerMapOnUserLocation()
      
      self.view.addSubview(revealSplashView)
      revealSplashView.animationType = .heartBeat
      revealSplashView.startAnimation()
      revealSplashView.heartAttack = true
   }
   
   @IBAction func didPressMenuButton(_ sender: Any) {
      delegate?.toggleLeftPanel()
   }
   
   @IBAction func actionButton(_ sender: Any) {
      actionButton.animateButton(shouldLoad: true, withMessage: nil)
   }
   
   
   @IBAction func wasPresssCenterMap(_ sender: Any) {
      centerMapOnUserLocation()
   }
   
   fileprivate func loadDriverAnnotationsFromFB() {
      DataService.instance.REF_DRIVERS.observe(.value) { (snapshot) in
         if let driverSnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
            for driver in driverSnapshot {
               if driver.hasChild("coordinate") {
                  if driver.childSnapshot(forPath: "isPickupModeEnabled").value as? Bool == true {
                     if let driverDict = driver.value as? [String: Any] {
                        let coordinateArray = driverDict["coordinate"] as! NSArray
                     }
                  }
               }
            }
         }
      }
   }
   
}


// MARK: Location Manager
extension HomeVC : CLLocationManagerDelegate{
   
   fileprivate func checkLocationAuthStatus() {
      if CLLocationManager.authorizationStatus() == .authorizedAlways {
       
         manager?.startUpdatingLocation()
      } else {
         manager?.requestAlwaysAuthorization()
      }
   }
   
   fileprivate func centerMapOnUserLocation() {
    
     let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, regionRadius * 2.0, regionRadius * 2.0)
      mapView.setRegion(coordinateRegion, animated: true)
   }
   
   
   func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
      
      if status == .authorizedAlways {
         mapView.showsUserLocation = true
         mapView.userTrackingMode = .follow
      }
   }
}


extension HomeVC: MKMapViewDelegate {
   func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {  
      UpdateService.instance.updateDriverLocation(with: userLocation.coordinate)
      UpdateService.instance.updateUserLocation(withCoordinate: userLocation.coordinate)
   }
   
   func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
      if let annotation = annotation as? DriverAnnotation {
         let identifier = "driver"
         var view: MKAnnotationView
         view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
         view.image = UIImage(named: "driverAnnotation")
         return view
      }
      
      return nil
   }
}

