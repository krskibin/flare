//
//  OnboardingViewController.swift
//  pam
//
//  Created by Tobiasz Dobrowolski on 07.06.2018.
//  Copyright © 2018 Krystian Skibiński. All rights reserved.
//

import UIKit
import Lottie

class OnboardingViewController: UIViewController {
    
    @IBOutlet weak var continueButton: UIButton!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var lottieView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UIDevice().userInterfaceIdiom == .phone {
            switch UIScreen.main.nativeBounds.height {
            case 1920, 2208, 2436, 2688, 1792:
                print("very big iPhone")
                welcomeLabel.isHidden = false
            case 1136:
                print("retarded iPhone 4-inch")
                welcomeLabel.isHidden = false

            default:
                welcomeLabel.isHidden = true
            }
        }
        
        continueButton.addTextSpacing(2.0)
        continueButton.layer.cornerRadius = continueButton.frame.height / 2
        continueButton.layer.masksToBounds = true
        continueButton.setGradient(first: Colors.myRed, second: Colors.myLightRed)
        
        let animationView = LOTAnimationView(name: "lottie")
        animationView.frame = self.lottieView.frame
        animationView.contentMode = .scaleAspectFit
        animationView.autoReverseAnimation = true
        animationView.loopAnimation = true
        self.view.addSubview(animationView)
        animationView.play()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension UIButton {
    
    func addTextSpacing(_ letterSpacing: CGFloat) {
        let attributedString = NSMutableAttributedString(string: (self.titleLabel?.text!)!)
        attributedString.addAttribute(NSAttributedString.Key.kern, value: letterSpacing, range: NSRange(location: 0, length: (self.titleLabel?.text?.count)!))
        self.setAttributedTitle(attributedString, for: .normal)
    }
}

extension UIView {
    
    func setGradient(first: UIColor, second: UIColor) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [first.cgColor, second.cgColor]
        gradientLayer.locations = [0.0, 1.0]
        gradientLayer.startPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 0.0, y: 0.0)
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}
