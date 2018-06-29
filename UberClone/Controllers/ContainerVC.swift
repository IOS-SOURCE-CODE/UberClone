//
//  ContainerVC.swift
//  UberClone
//
//  Created by son chanthem on 12/19/17.
//  Copyright © 2017 son chanthem. All rights reserved.
//

import UIKit
import QuartzCore

enum SlideOutState {
   case collapse
   case leftPanelExpanded
}

enum ShowWhicVC {
   case homeVC
}

var showVC: ShowWhicVC = .homeVC

class ContainerVC: UIViewController {
   
   var homeVC: HomeVC!
   var currentState:SlideOutState = .collapse {
      didSet {
         let shouldShowShadow = (currentState != .collapse)
         shouldShowShadowCenterViewController(shouldShowShadow)
      }
   }
   var leftVC: LeftSidePanelVC!
   var centerController: UIViewController!
   
   var tap: UITapGestureRecognizer!
   
   var isHidden = false
   var centerPanelExpandedOffset: CGFloat = 168
   
   override func viewDidLoad() {
      super.viewDidLoad()
      
      initCenter(screen: showVC)
   }
   
   func initCenter(screen: ShowWhicVC) {
      var presentingViewController: UIViewController
      
      showVC = screen
      
      if homeVC == nil {
         homeVC = UIStoryboard.homeVC()
         homeVC.delegate = self
      }
      
      presentingViewController = homeVC
      
      if let con = centerController {
         con.view.removeFromSuperview()
         con.removeFromParentViewController()
      }
      
      centerController = presentingViewController
      view.addSubview(centerController.view)
      addChildViewController(centerController)
      didMove(toParentViewController: self)
   }
   
   override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
      return UIStatusBarAnimation.slide
   }
   
   override var prefersStatusBarHidden: Bool {
      return isHidden
   }
   
}

extension ContainerVC : CenterVCDelegate {
   func toggleLeftPanel() {
      let notAlreadyExpanded = (currentState != .leftPanelExpanded)
      
      if notAlreadyExpanded {
         addLeftPanelViewController()
      }
      
      animateLeftPanel(shouldExpand: notAlreadyExpanded)
   }
   
   func addLeftPanelViewController() {
      if leftVC == nil {
         leftVC = UIStoryboard.leftSidePanelVC()
         addChildSlidePanelViewController(sidePanelViewController: leftVC)
      }
   }
   
   func addChildSlidePanelViewController(sidePanelViewController: LeftSidePanelVC) {
      view.insertSubview(sidePanelViewController.view, at: 0)
      addChildViewController(sidePanelViewController)
      didMove(toParentViewController: self)
   }
   
   @objc func animateLeftPanel(shouldExpand: Bool) {
      if shouldExpand {
         isHidden = !isHidden
         animateStatusBar()
         setupWhiteCoverView()
         currentState = .leftPanelExpanded
         
         animateCenterPanelXPosition(targetPosition: centerController.view.frame.width - centerPanelExpandedOffset)
      } else {
         
         isHidden = !isHidden
         animateStatusBar()
         hideWhiteCoverView()
         animateCenterPanelXPosition(targetPosition: 0, completion: { (finished) in
            
            if finished == true {
               self.currentState = .collapse
               self.leftVC = nil
            }
         })
      }
   }
   
   func animateCenterPanelXPosition(targetPosition: CGFloat, completion:((Bool)->Void)! = nil) {
      
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
         
         self.centerController.view.frame.origin.x = targetPosition
      }, completion: completion)
   }
   
   func animateStatusBar() {
      UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
         self.setNeedsStatusBarAppearanceUpdate()
      })
   }
   
   func setupWhiteCoverView() {
      let whiteCoverView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
      whiteCoverView.alpha = 0.0
      whiteCoverView.tag = 25
      whiteCoverView.backgroundColor = UIColor.white
      self.centerController.view.addSubview(whiteCoverView)
      whiteCoverView.fadeTo(alpha: 0.75, duration: 0.2)
      
      tap = UITapGestureRecognizer(target: self, action: #selector(animateLeftPanel(shouldExpand:)))
      tap.numberOfTapsRequired = 1
      self.centerController.view.addGestureRecognizer(tap)
   }
   
   func hideWhiteCoverView() {
      self.centerController.view.removeGestureRecognizer(tap)
      for subview in self.centerController.view.subviews {
         if subview.tag == 25 {
            UIView.animate(withDuration: 0.2, animations: {
               subview.alpha = 0
            }, completion: { (finish) in
               if finish == true {
                  subview.removeFromSuperview()
               }
            })
         }
      }
   }
   
   func shouldShowShadowCenterViewController(_ status: Bool) {
      if status {
         centerController.view.layer.shadowOpacity = 0.6
      } else {
         centerController.view.layer.shadowOpacity = 0.0
      }
   }
}

private extension UIStoryboard {
   class func mainStoryboard() -> UIStoryboard {
      return UIStoryboard(name: "Main", bundle: Bundle.main)
   }
   
   class func leftSidePanelVC() -> LeftSidePanelVC? {
      return mainStoryboard().instantiateViewController(withIdentifier: "LeftSidePanelVC") as? LeftSidePanelVC
   }
   
   class func homeVC() -> HomeVC? {
      return mainStoryboard().instantiateViewController(withIdentifier: "HomeVC") as? HomeVC
   }
}











