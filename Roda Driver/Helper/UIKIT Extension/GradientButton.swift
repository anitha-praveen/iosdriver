//
//  GradientButton.swift
//  Captain Car
//
//  Created by Spextrum on 04/07/19.
//  Copyright © 2019 nPlus. All rights reserved.
//

import UIKit

class GradientButton: UIButton {
    override var isSelected: Bool {
        didSet {
            if isSelected {
                layer.insertSublayer(gradient, at: 0)
            } else {
                gradient.removeFromSuperlayer()
            }
        }
    }
    let gradient: CAGradientLayer = CAGradientLayer()
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        applyGradient()
    }
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        applyGradient()
    }
    func applyGradient() {
        gradient.colors = [UIColor(red: 25/255.0, green: 123/255.0, blue: 203/255.0, alpha: 1).cgColor, UIColor(red: 48/255.0, green: 92/255.0, blue: 166/255.0, alpha: 1).cgColor]
        gradient.locations = [0.0,1.0]
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
//        layer.insertSublayer(gradient, at: 0)
    }
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        gradient.frame = self.bounds
    }
}
