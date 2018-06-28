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
   @IBOutlet weak var centerMapButton: UIButton!
   @IBOutlet weak var searchLocationTextField: UITextField!
   
   @IBOutlet weak var searchLocationCircleView: CircleView!
   
   
   var delegate: CenterVCDelegate?
   var manager: CLLocationManager?
   var regionRadius: CLLocationDistance = 1000
   
   var tableView = UITableView()
   
   var matchingItems: [MKMapItem] = [MKMapItem]()
   
   let revealSplashView = RevealingSplashView(iconImage: UIImage(named: "launchScreenIcon")!, iconInitialSize: CGSize(width:80, height:80), backgroundColor: UIColor.white)
   
   
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      manager = CLLocationManager()
      manager?.delegate = self
      manager?.desiredAccuracy = kCLLocationAccuracyBest
      
      checkLocationAuthStatus()
      
      mapView.delegate = self
      
      
      searchLocationTextField.delegate = self
      
      centerMapOnUserLocation()
      
      DataService.instance.REF_DRIVERS.observe(.value) { (snapshot) in
         self.loadDriverAnnotationsFromFB()
      }
      
      
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
      centerMapButton.fadeTo(alpha: 0.0, duration: 0.2)
   }
   
   fileprivate func loadDriverAnnotationsFromFB() {
      DataService.instance.REF_DRIVERS.observe(.value) { (snapshot) in
         if let driverSnapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
            for driver in driverSnapshot {
               if driver.hasChild(DriverSnapshot.userIsDriver.rawValue) {
                  if driver.hasChild(DriverSnapshot.coordinate.rawValue) {
                     if driver.childSnapshot(forPath: DriverSnapshot.isPickupModeEnable.rawValue).value as? Bool == true {
                        if let driverDict = driver.value as? [String: Any] {
                           let coordinateArray = driverDict[DriverSnapshot.coordinate.rawValue] as! NSArray
                           let driverCoordinate = CLLocationCoordinate2D(latitude: coordinateArray[0] as! CLLocationDegrees, longitude: coordinateArray[1] as! CLLocationDegrees)
                           let annotation = DriverAnnotation(coordinate: driverCoordinate, withKey: driver.key)
                           var driverIsVisible: Bool {
                              return  self.mapView.annotations.contains(where: { (annotation) -> Bool in
                                 if let driverAnnotation = annotation as? DriverAnnotation {
                                    if driverAnnotation.key == driver.key {
                                       driverAnnotation.update(annotationPosition: driverAnnotation, withCoordinate: driverCoordinate)
                                       return true
                                    }
                                 }
                                 return false
                              })
                           }
                           
                           if !driverIsVisible {
                              self.mapView.addAnnotation(annotation)
                           }
                        }
                     } else {
                        for annotation in self.mapView.annotations {
                           if annotation.isKind(of: DriverAnnotation.self) {
                              if let annotation = annotation as? DriverAnnotation {
                                 if annotation.key == driver.key {
                                    self.mapView.removeAnnotation(annotation)
                                 }
                              }
                           }
                        }
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

// MARK: - Map MKMapViewDelegate
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
   
   func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
      centerMapButton.fadeTo(alpha: 1.0, duration: 0.2)
   }
   
   fileprivate func performSearch() {
      matchingItems.removeAll()
      let request = MKLocalSearchRequest()
      request.naturalLanguageQuery = searchLocationTextField.text
      request.region = self.mapView.region
      let search = MKLocalSearch(request: request)
      search.start { (response, error) in
         if error != nil {
            print(error.debugDescription)
         } else if response?.mapItems.count == 0 {
            print("No results")
         } else {
            _ = response?.mapItems.compactMap { self.matchingItems.append($0) }
            self.tableView.reloadData()
         }
      }
      
   }
}



extension HomeVC: UITextFieldDelegate {
   
   fileprivate func animateTableView(shouldShow: Bool) {
      
      let spaceVertical: CGFloat = 200
      
      if shouldShow {
         
         UIView.animate(withDuration: 0.2) {
            self.tableView.frame = CGRect(x: 20, y: spaceVertical, width: self.view.frame.width - 40, height: self.view.frame.height - (spaceVertical + 50) )
         }
      } else {
         UIView.animate(withDuration: 0.2, animations: {
            self.tableView.frame = CGRect(x: 20, y: self.view.frame.height, width: self.view.frame.width - 40, height: self.view.frame.height - (spaceVertical + 50) )
         }, completion: { _ in
            for subview in self.view.subviews {
               if subview.tag == 20 {
                  subview.removeFromSuperview()
               }
            }
         })
      }
   }
   
   fileprivate func animationSearchCircleView() {
      UIView.animate(withDuration: 0.2) {
         self.searchLocationCircleView.backgroundColor = .red
         self.searchLocationCircleView.borderColor = UIColor.init(red: 199/255, green: 0, blue: 0, alpha: 1.0)
      }
   }
   
   fileprivate func setupTableView() {
      tableView.frame = CGRect(x: 20, y: view.frame.height, width: view.frame.width - 40, height: view.frame.height - 170)
      tableView.layer.cornerRadius = 5.0
      tableView.register(UITableViewCell.self, forCellReuseIdentifier: "locationCell")
      
      tableView.delegate = self
      tableView.dataSource = self
      tableView.rowHeight = 60
      tableView.tag = 20
      
      view.addSubview(tableView)
   }
   
   func textFieldDidBeginEditing(_ textField: UITextField) {
      
      if textField == searchLocationTextField {
         setupTableView()
         animateTableView(shouldShow: true)
         animationSearchCircleView()
      }

   }
   
   func textFieldShouldReturn(_ textField: UITextField) -> Bool {
      
      if textField == searchLocationTextField {
         performSearch()
         view.endEditing(true)
      }
      
      return true
   }
   
   func textFieldDidEndEditing(_ textField: UITextField) {
      if textField == searchLocationTextField {
         if searchLocationTextField.text == "" {
            UIView.animate(withDuration: 0.2) {
               self.searchLocationCircleView.backgroundColor = .lightGray
               self.searchLocationCircleView.borderColor = .darkGray
            }
         }
      }
   }
   
   func textFieldShouldClear(_ textField: UITextField) -> Bool {
      matchingItems = []
      tableView.reloadData()
      centerMapOnUserLocation()
      return true
   }
}

extension HomeVC: UITableViewDelegate, UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return matchingItems.count
   }
   
   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "locationCell")
      let matchingItem =  matchingItems[indexPath.row]
      cell.textLabel?.text = matchingItem.name
      cell.detailTextLabel?.text = matchingItem.placemark.title
      return cell
   }
   
   func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      animateTableView(shouldShow: false)
      tableView.deselectRow(at: indexPath, animated: true)
      view.endEditing(true)
   }
}
