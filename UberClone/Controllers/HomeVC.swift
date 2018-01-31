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

class HomeVC: UIViewController {
    
    @IBOutlet weak var actionButton: RoundedShadowButton!
    @IBOutlet weak var mapView: MKMapView!
    
    var delegate: CenterVCDelegate?
    
    let revealSplashView = RevealingSplashView(iconImage: UIImage(named: "launchScreenIcon")!, iconInitialSize: CGSize(width:80, height:80), backgroundColor: UIColor.white)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        
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
    
    
}

extension HomeVC: MKMapViewDelegate {
    
    
}

