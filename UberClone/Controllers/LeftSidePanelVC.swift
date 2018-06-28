//
//  LeftSidePanelVC.swift
//  UberClone
//
//  Created by son chanthem on 12/19/17.
//  Copyright © 2017 son chanthem. All rights reserved.
//

import UIKit
import Firebase



class LeftSidePanelVC: UIViewController {
   
   @IBOutlet weak var userEmailLabel: UILabel!
   @IBOutlet weak var accountTypeLabel: UILabel!
   @IBOutlet weak var userImageView: RoundImageView!
   @IBOutlet weak var pickupModeSwitch: UISwitch!
   @IBOutlet weak var pickupModelLabel: UILabel!
   
   @IBOutlet weak var loginLogoutButton: UIButton!
   
   
   
   
   var currentUserId: String? {
      return  FIRAuth.auth()?.currentUser?.uid
   }

    override func viewDidLoad() {
        super.viewDidLoad()
      

    }
   
   override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      
      
      pickupModeSwitch.isOn = false
      pickupModeSwitch.isHidden = true
      pickupModelLabel.isHidden = true
      
      
      if let currentUser = FIRAuth.auth()?.currentUser {
         
         userEmailLabel.text = currentUser.email
         accountTypeLabel.text = ""
         userImageView.isHidden = false
         loginLogoutButton.setTitle("Logout" , for: .normal)
         pickupModeSwitch.isHidden = false
         pickupModelLabel.isHidden = false
        
      } else {
         
         userEmailLabel.text =  ""
         accountTypeLabel.text = ""
         userImageView.isHidden = true
         loginLogoutButton.setTitle("Sign Up / Login" , for: .normal)
         pickupModeSwitch.isHidden = true
         pickupModelLabel.isHidden = true
         
      }
      
      observePassengerAndDriver()
   }
   
   
   
   func observePassengerAndDriver() {

      DataService.instance.REF_USERS.observeSingleEvent(of: .value, with: { (snapshot) in
         if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
            for snap in snapshot {
               if snap.key == FIRAuth.auth()?.currentUser?.uid {
                  self.accountTypeLabel.text =  AccountType.passenger.value
                  self.pickupModeSwitch.isHidden = true
               }
            }
         }
      })
      
      DataService.instance.REF_DRIVERS.observeSingleEvent(of: .value) { (snapshot) in
         if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
            for snap in snapshot {
               if snap.key == FIRAuth.auth()?.currentUser?.uid {
                  self.accountTypeLabel.text = AccountType.driver.value
                  self.pickupModeSwitch.isHidden = false
                  let switchStatus = snap.childSnapshot(forPath: DriverSnapshot.isPickupModeEnable.rawValue).value as! Bool
                  self.pickupModeSwitch.isOn = switchStatus
                  self.pickupModelLabel.isHidden = false
               }
            }
         }
      }
   }
   
   @IBAction func switchWasToggled(_ sender: Any) {

      if pickupModeSwitch.isOn {
         pickupModelLabel.text = "PICKUP MODE ENABLED"
         DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues([DriverSnapshot.isPickupModeEnable.rawValue: true])
      } else {
         pickupModelLabel.text = "PICKUP MODE DISABLED"
      DataService.instance.REF_DRIVERS.child(currentUserId!).updateChildValues([DriverSnapshot.isPickupModeEnable.rawValue: false])
      }
      
      AppDelegate.getAppDelegate().menuContainerVC.toggleLeftPanel()
      
   }
   

    @IBAction func SignUpLoginButton(_ sender: Any) {
      
      if FIRAuth.auth()?.currentUser == nil {
         let vc = storyboard?.mainStoryboard(withIdentifier: "LoginVC") as! LoginVC
         self.present(vc, animated: true, completion: nil)
      } else {
         do {
            try FIRAuth.auth()?.signOut()
            userEmailLabel.text = ""
            accountTypeLabel.text = ""
            userImageView.isHidden = true
            pickupModelLabel.text = ""
            pickupModeSwitch.isHidden = true
            loginLogoutButton.setTitle("Sign Up / Login", for: .normal)
         } catch (let error) {
            print(error.localizedDescription)
         }
      }
    }
}
