//
//  LoginVC.swift
//  UberClone
//
//  Created by son chanthem on 12/25/17.
//  Copyright © 2017 son chanthem. All rights reserved.
//

import UIKit
import Firebase

class LoginVC: UIViewController {
    
    @IBOutlet weak var emailTextField: RoundedCornerTextField!
    @IBOutlet weak var passwordTextField: RoundedCornerTextField!
    @IBOutlet weak var authButton: RoundedShadowButton!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Textfield delegation
        emailTextField.delegate = self
        passwordTextField.delegate = self
        
        view.bindToKeyboard()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleScreenTab(sender:)))
        self.view.addGestureRecognizer(tap)
        
    }
    
    @objc func handleScreenTab(sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }

    @IBAction func closeButton(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func authBtnWasPressed(_ sender: Any) {
        if emailTextField.text != nil && passwordTextField.text != nil {
            authButton.animateButton(shouldLoad: true, withMessage: nil)
            self.view.endEditing(true)
            
            if let email = emailTextField.text, let password = passwordTextField.text {
                FIRAuth.auth()?.signIn(withEmail: email, password: password, completion: { (user, error) in
                    
                    if error == nil {
                        if let user = user {
                            if self.segmentedControl.selectedSegmentIndex == 0 {
                                let userData = ["provider": user.providerID] as [String:Any]
                                DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: false)
                            } else {
                                let userData = ["provider": user.providerID, "userIsDriver":true, "isPickupModeEnable": false, "driverIsOnTrip":false] as [String:Any]
                                DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                            }
                        }
                        
                        print("Email successfull")
                        self.dismiss(animated: true, completion: nil)
                    } else {
                        FIRAuth.auth()?.createUser(withEmail: email, password: password, completion: { (user, error) in
                            
                            if error != nil {
                                if let errorCode = FIRAuthErrorCode(rawValue: error!._code) {
                                    switch errorCode {
                                    case .errorCodeInvalidEmail:
                                        print("Email error")
                                    case .errorCodeEmailAlreadyInUse:
                                        print("Eamil already in use")
                                    case .errorCodeWrongPassword:
                                        print("Wrong password")
                                    default:
                                        print("unexpected error")
                                    }
                                }
                            } else {
                                if let user = user {
                                    if self.segmentedControl.selectedSegmentIndex == 0 {
                                        let userData = ["provider": user.providerID] as [String:Any]
                                        DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: false)
                                    } else {
                                        let userData = ["provider": user.providerID, "userIsDriver":true, "isPickupModeEnable": false, "driverIsOnTrip":false] as [String:Any]
                                        DataService.instance.createFirebaseDBUser(uid: user.uid, userData: userData, isDriver: true)
                                    }
                                }
                                print("Success create user")
                                self.dismiss(animated: true, completion: nil)
                            }
                        })
                    }
                })
            }
        }
        
    }
    
}

extension LoginVC: UITextFieldDelegate {
    
    
}
