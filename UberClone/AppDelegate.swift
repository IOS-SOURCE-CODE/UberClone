//
//  AppDelegate.swift
//  UberClone
//
//  Created by son chanthem on 12/15/17.
//  Copyright © 2017 son chanthem. All rights reserved.
//

import UIKit
import Firebase


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
   
   var window: UIWindow?
   
   fileprivate var containerVC: ContainerVC?
   
   var menuContainerVC: ContainerVC! {
      return containerVC
   }
   
   func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
      
      
     
      FIRApp.configure()
      
      
      containerVC = ContainerVC()
      window?.rootViewController = containerVC
      window?.makeKeyAndVisible()
      
      return true
   }
   
   class func getAppDelegate() -> AppDelegate {
      return UIApplication.shared.delegate as! AppDelegate
   }
}

