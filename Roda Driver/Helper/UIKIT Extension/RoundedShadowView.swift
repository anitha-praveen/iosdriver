//
//  RoundedShadowView.swift
//  Captain Car
//
//  Created by Spextrum on 05/07/19.
//  Copyright © 2019 nPlus. All rights reserved.
//

import UIKit

class RoundedShadowView: UIView {
    private let shadowLayer = CAShapeLayer()
    internal override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    internal required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    convenience init(_ color: UIColor = UIColor.white) {
        self.init()
        commonInit(color)
    }
    func commonInit(_ color: UIColor = UIColor.white) {
        shadowLayer.fillColor = color.cgColor
        shadowLayer.shadowColor = UIColor.darkGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0.0, height: 0.0)
        shadowLayer.shadowOpacity = 0.4
        shadowLayer.shadowRadius = 2
        layer.insertSublayer(shadowLayer, at: 0)
    }
    override func layoutSublayers(of layer: CALayer) {
        super.layoutSublayers(of: layer)
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 5).cgPath
    }
}
