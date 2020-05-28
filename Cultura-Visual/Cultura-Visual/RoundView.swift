//
//  RoundView.swift
//  Cultura-Visual
//
//  Created by user168625 on 5/26/20.
//  Copyright © 2020 CVDevs. All rights reserved.
//

import UIKit

class RoundView: UIView {
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        
         self.layer.cornerRadius = 20 // change this number to get the corners you want
        self.layer.masksToBounds = true
    }
}
