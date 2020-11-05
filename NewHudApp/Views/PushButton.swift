//
//  PushButton.swift
//  HUDVeloDist
//
//  Created by Владислав Никольский on 21.10.2020.
//  Copyright © 2020 Владислав Никольский. All rights reserved.
//

import UIKit

@IBDesignable


class PushButton: UIButton {
    @IBInspectable var fillColor: UIColor = .green
    @IBInspectable var isAddButton: Bool = false
   
    override func draw(_ rect: CGRect) {
       let path = UIBezierPath(ovalIn: rect)
        fillColor.setFill()
        path.fill()
    }
}



