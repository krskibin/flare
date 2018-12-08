//
//  RoundShadowButton.swift
//  pam
//
//  Created by Tobiasz Dobrowolski on 18/10/2018.
//  Copyright © 2018 Krystian Skibiński. All rights reserved.
//

import UIKit

class RoundShadowButton: UIButton {

    var shadowLayer: CAShapeLayer!

    override func layoutSubviews() {
        super.layoutSubviews()

        if shadowLayer == nil {
            shadowLayer = CAShapeLayer()
            shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 31).cgPath
            shadowLayer.fillColor = UIColor(red: 0/0, green: 0/0, blue: 0/0, alpha: 0).cgColor

            shadowLayer.shadowColor = Colors.myRed.cgColor
            shadowLayer.shadowPath = shadowLayer.path
            shadowLayer.shadowOffset = CGSize(width: 0.0, height: 10.0)
            shadowLayer.shadowOpacity = 0.3
            shadowLayer.shadowRadius = 15

            layer.insertSublayer(shadowLayer, at: 0)
        }
    }

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
