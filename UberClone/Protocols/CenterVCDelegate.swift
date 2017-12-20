//
//  CenterVCDelegate.swift
//  UberClone
//
//  Created by son chanthem on 12/19/17.
//  Copyright © 2017 son chanthem. All rights reserved.
//

import Foundation


protocol CenterVCDelegate {
    func toggleLeftPanel()
    func addLeftPanelViewController()
    func animateLeftPanel(shouldExpand: Bool)
}
