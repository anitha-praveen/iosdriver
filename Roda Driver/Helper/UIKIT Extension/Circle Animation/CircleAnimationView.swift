//
//  CircleAnimationView.swift
//  TapNGo Driver
//
//  Created by Admin on 10/04/18.
//  Copyright © 2018 nPlus. All rights reserved.
//

import UIKit

class CircleAnimationView: UIView {
    
    let outCircle = CAShapeLayer()
    let circle = CAShapeLayer()
    var lineWidth:CGFloat = 15

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        setup()
    }

    init(lineWidth:CGFloat) {
        self.lineWidth = lineWidth
        super.init(frame: CGRect.zero)
    }
     
    // MARK:Adding New UI Elements In Setup
    func setup() {
        self.backgroundColor = .clear
        outCircle.path = UIBezierPath(ovalIn: self.bounds).cgPath
        outCircle.fillColor = UIColor.clear.cgColor
        outCircle.strokeColor = UIColor.themeColor.cgColor  // UIColor.hexToColor("FB4A46").cgColor
        outCircle.lineWidth = self.lineWidth
        outCircle.strokeStart = 0
        outCircle.strokeEnd = 1.0
        self.layer.addSublayer(outCircle)

        circle.path = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: self.bounds.width / 2.0, startAngle: CGFloat(Float.pi / -2.0), endAngle: CGFloat((Float.pi*2)-(Float.pi/2)), clockwise: true).cgPath
        circle.fillColor = UIColor.clear.cgColor
        circle.strokeColor = UIColor.gray.cgColor
        circle.lineWidth = self.lineWidth
        circle.strokeStart = 0
        circle.strokeEnd = 0
        self.layer.addSublayer(circle)
    }
    
    func animateCircle(_ duration:CFTimeInterval, startFrom:Int, repeats:Bool = false) {
        print(duration)//60
        print(startFrom)
        circle.strokeEnd = 1.0
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration = duration - Double(startFrom)
        drawAnimation.fromValue = Double(startFrom)/duration
        if repeats {
            drawAnimation.repeatCount = .greatestFiniteMagnitude
        }
        drawAnimation.toValue   = 1.0
        drawAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        circle.add(drawAnimation, forKey: "drawCircleAnimation")
    }
    
    func animateCircle(from: Double, to: Double) {
        circle.strokeEnd = CGFloat(to)
        let drawAnimation = CABasicAnimation(keyPath: "strokeEnd")
        drawAnimation.duration = 1
        drawAnimation.fromValue = from
        drawAnimation.toValue   = to
        drawAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        circle.add(drawAnimation, forKey: "drawCircleAnimation")
    }
}

