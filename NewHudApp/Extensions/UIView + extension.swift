//
//  UIView + extension.swift
//  NewHudApp
//
//  Created by Владислав Никольский on 05.11.2020.
//  Copyright © 2020 Владислав Никольский. All rights reserved.
//

import Foundation
import UIKit

extension UIView {

func flipY() {
    transform = CGAffineTransform(scaleX: transform.a, y: -transform.d)
}
}
