//
//  UIKit Extensions.swift
//  TapNGo Driver
//
//  Created by Admin on 27/03/18.
//  Copyright © 2018 nPlus. All rights reserved.
//

import Foundation
import UIKit
import AVKit
import GoogleMaps
import GooglePlaces
import CoreData
import AWSS3
import AWSCore
import AWSCognito
import SwiftUI

extension UIView {
   
    @discardableResult
    func applyGradient(radius: CGFloat) -> CAGradientLayer {
        return self.applyGradient(colours: [UIColor(red: 0.024, green: 0.027, blue: 0.035, alpha: 1), UIColor(red: 0.173, green: 0.184, blue: 0.212, alpha: 1),UIColor(red: 0.494, green: 0.404, blue: 0.157, alpha: 1)],radius: radius, locations: [0,1])
    }
    @discardableResult
    func applyGradient(colours: [UIColor],radius: CGFloat ,locations: [NSNumber]?) -> CAGradientLayer {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = CGPoint(x: 0.25, y: 0.5)
        gradient.endPoint = CGPoint(x: 0.75, y: 0.5)
        gradient.locations = locations
        gradient.cornerRadius = radius
        self.layer.insertSublayer(gradient, at: 0)
        return gradient
    }
}
// MARK: - Set Borders with extension

extension UIView {
    func addBorder(edges: UIRectEdge, colour: UIColor = UIColor.themeColor, thickness: CGFloat = 1, leftPadding: CGFloat = 0, rightPadding: CGFloat = 0) {
        func border() -> UIView {
            let border = UIView()
            border.backgroundColor = colour
            border.translatesAutoresizingMaskIntoConstraints = false
            return border
        }
        if edges.contains(.top) || edges.contains(.all) {
            let top = border()
            addSubview(top)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[top(==thickness)]",options: [],metrics: ["thickness": thickness],views: ["top": top]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[top]-(0)-|",options: [],metrics: nil,views: ["top": top]))
        }
        
        if edges.contains(.left) || edges.contains(.all) {
            let left = border()
            addSubview(left)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[left(==thickness)]",options: [],metrics: ["thickness": thickness],views: ["left": left]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[left]-(0)-|",options: [],metrics: nil,views: ["left": left]))
        }
        
        if edges.contains(.right) || edges.contains(.all) {
            let right = border()
            addSubview(right)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[right(==thickness)]-(0)-|",options: [],metrics: ["thickness": thickness],views: ["right": right]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(0)-[right]-(0)-|",options: [],metrics: nil,views: ["right": right]))
        }
        
        if edges.contains(.bottom) || edges.contains(.all) {
            let bottom = border()
            addSubview(bottom)
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[bottom(==thickness)]-(0)-|",options: [],metrics: ["thickness": thickness],views: ["bottom": bottom]))
            addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(leftPadding)-[bottom]-(rightPadding)-|",options: [],metrics: ["leftPadding":leftPadding,"rightPadding":rightPadding],views: ["bottom": bottom]))
        }
    }
    
    // MARK: - Set Shadow with extension

    func addShadow(shadowColor: CGColor = UIColor.txtColor.cgColor,
                   shadowOffset: CGSize = CGSize(width: 1.0, height: 1.0),
                   shadowOpacity: Float = 0.4,
                   shadowRadius: CGFloat = 3.0) {
        
        layer.rasterizationScale = UIScreen.main.scale
        layer.shouldRasterize = true
        layer.shadowColor = shadowColor
        layer.shadowOffset = shadowOffset
        layer.shadowOpacity = shadowOpacity
        layer.shadowRadius = shadowRadius
    }
    
    // MARK: - Set AddLoader with extension

    func addLoader(_ color: UIColor = .txtColor)->CALayer {
        self.layoutIfNeeded()
        self.setNeedsLayout()
        let blackLayer = CALayer()
        blackLayer.frame = CGRect(x: 0, y: 0, width: 0, height: 3)
        blackLayer.backgroundColor = UIColor.txtColor.cgColor
        self.layer.addSublayer(blackLayer)
        
        
        let path = UIBezierPath()
        path.move(to: CGPoint(x: self.bounds.minX, y: self.bounds.minY))
        path.addLine(to: CGPoint(x: self.bounds.maxX, y: self.bounds.minY))
        
        let animation = CAKeyframeAnimation(keyPath: "position")
        animation.path = path.cgPath
        animation.duration = 0.5 //* 10
        animation.autoreverses = true
        animation.repeatCount = Float.infinity
        blackLayer.add(animation, forKey: "position")
        
        let anim = CABasicAnimation(keyPath: "bounds")
        anim.duration = 0.25 //* 10
        anim.autoreverses = true
        anim.repeatCount = Float.infinity
        anim.fromValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 10, height: 3))
        anim.toValue = NSValue(cgRect: CGRect(x: 0, y: 0, width: 150, height: 3))
        blackLayer.add(anim, forKey: "bounds")
        return blackLayer
    }
    
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        if #available(iOS 11, *) {
            var cornerMask = CACornerMask()
            if(corners.contains(.topLeft)) {
                 cornerMask.insert(.layerMinXMinYCorner)
            }
            if(corners.contains(.topRight)) {
                cornerMask.insert(.layerMaxXMinYCorner)
            }
            if(corners.contains(.bottomLeft)) {
                cornerMask.insert(.layerMinXMaxYCorner)
            }
            if(corners.contains(.bottomRight)) {
                cornerMask.insert(.layerMaxXMaxYCorner)
            }
            self.layer.cornerRadius = radius
            self.layer.maskedCorners = cornerMask
        } else {
            let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
            let mask = CAShapeLayer()
            mask.path = path.cgPath
            self.layer.mask = mask
        }
    }
}

// MARK: - UIColor with extension
extension UIColor {
    // Rarely Used Color
    static let inkBlue = UIColor(red: 0/255.0, green: 88/255.0, blue: 181/255.0, alpha: 1.0)
    static let turquoise = UIColor(red: 60/255.0, green: 211/255.0, blue: 190/255.0, alpha: 1.0)
    static let orange = UIColor(red: 255/255.0, green: 180/255.0, blue: 98/255.0, alpha: 1.0)
    static let darkGreen = UIColor(red: 0.0/255.0, green: 100.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    
}

// MARK: - Set APP UIColor with extension
extension UIColor {

    class var appThemeColor: UIColor {
       // return UIColor(red: 255.0/255.0, green: 57.0/255.0, blue: 57.0/255.0, alpha: 1.0)
        return UIColor.hexToColor("ffd60b")
    }
    
    static let regTxtColor = UIColor.hexToColor("000000")
    
    static var themeColor: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    
                    return regTxtColor//.hexToColor("021A74")
                } else {
                    
                    return .appThemeColor
                }
            }
        } else {
            
            return .appThemeColor
        }
    }()
    
    static var txtColor: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                  
                    return UIColor.secondaryColor.withAlphaComponent(0.6)
                } else {
                    
                    return .regTxtColor
                }
            }
        } else {
            
            return .regTxtColor
        }
    }()
    
    class var themeTxtColor: UIColor {
        
        return UIColor.hexToColor("000000")
    }
    
    static var secondaryColor: UIColor = {
        if #available(iOS 13, *) {
            return UIColor { (UITraitCollection: UITraitCollection) -> UIColor in
                if UITraitCollection.userInterfaceStyle == .dark {
                    
                    return .secondarySystemBackground//UIColor.hexToColor("121212")//
                    
                } else {
                    
                    return .white
                }
            }
        } else {
            
            return .white
        }
    }()
        
    static func hexToColor (_ hex: String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }

        if ((cString.count) != 6) {
            return UIColor.gray
        }

        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)

        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
}

@IBDesignable
class FormTextField: UITextField {

    @IBInspectable var inset: CGFloat = 0

    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }

    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
}

extension UIImage {
    static func ==(lhs: UIImage, rhs: UIImage)->Bool {
        if let lhsData = lhs.pngData(), let rhsData = rhs.pngData() {
            return lhsData == rhsData
        }
        return false
    }
}

// MARK: - Set Valid with extension

extension String {
    var isBlank:Bool {
            return trimmingCharacters(in: .whitespaces).isEmpty
    }
    var isValidName:Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Za-z]+$").evaluate(with:self)
    }
    var isValidEmail:Bool {
        return NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}").evaluate(with:self)
    }    
    var isValidPhoneNumber:Bool {
        return NSPredicate(format: "SELF MATCHES %@", "^[0-9]{10,14}$").evaluate(with:self)
    }
}

// MARK: - Set UIFont with extension

//Global property for language direction alignment

extension UIFont {
   
    class func appBoldTitleFont(ofSize:CGFloat) -> UIFont {
        return UIFont(name: "SFUIDisplay-Medium", size: ofSize) ?? UIFont.boldSystemFont(ofSize:ofSize)
        
    }
    class func appFont(ofSize:CGFloat) -> UIFont {
        return UIFont(name: "SFUIDisplay-Regular", size: ofSize) ?? UIFont.systemFont(ofSize:ofSize)
        
    }
    class func appRegularFont(ofSize:CGFloat) -> UIFont {
           return UIFont(name: "SFUIDisplay-Regular", size: ofSize) ?? UIFont.systemFont(ofSize:ofSize)
        
    }
    class func appBoldFont(ofSize:CGFloat) -> UIFont {
        return UIFont(name: "SFUIDisplay-Bold", size: ofSize) ?? UIFont.boldSystemFont(ofSize:ofSize)
        
    }
    class func appSemiBold(ofSize:CGFloat) -> UIFont {
          return UIFont(name: "SFUIDisplay-SemiBold", size: ofSize) ?? UIFont.boldSystemFont(ofSize:ofSize)
        
    }
    class func appMediumFont(ofSize:CGFloat) -> UIFont {
           return UIFont(name: "SFUIDisplay-Medium", size: ofSize) ?? UIFont.systemFont(ofSize:ofSize)
    }
  
}

// MARK: - Set Alert with extension

extension UIViewController {
    
    func showAlert(_ title :String? = nil , message: String? = nil) {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        
        if let title = title {
            let titleFont = [NSAttributedString.Key.font: UIFont.appBoldTitleFont(ofSize: 18)]
            let titleAttrString = NSAttributedString(string: title, attributes: titleFont)
            alert.setValue(titleAttrString, forKey: "attributedTitle")
        }
        if let message = message {
            let messageFont = [NSAttributedString.Key.font: UIFont.appFont(ofSize: 16)]
            let messageAttrString = NSAttributedString(string: message, attributes: messageFont)
            alert.setValue(messageAttrString, forKey: "attributedMessage")
        }
        let ok = UIAlertAction(title: "text_ok".localize(), style: .default, handler: nil)
        alert.addAction(ok)
        present(alert, animated: true, completion: nil)
    }
    
    func dismissPresent(_ viewControllerToPresent: UIViewController, animated: Bool, completion: (() -> Void)?) {
        if let presentedViewController = self.presentedViewController {
            presentedViewController.dismiss(animated: false) {
                self.present(viewControllerToPresent, animated: animated, completion: completion)
            }
        } else {
            present(viewControllerToPresent, animated: animated, completion: completion)
        }
        
    }
}

// MARK: - Set Toast with extension

extension UIView {
    func showToast(_ message: String) {
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.secondaryColor
        toastLabel.textAlignment = .center
        toastLabel.font = UIFont.appFont(ofSize: 12)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds  =  true
        self.addSubview(toastLabel)
        toastLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        toastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 35).isActive = true
        toastLabel.centerXAnchor.constraint(equalTo: toastLabel.superview!.centerXAnchor).isActive = true
        toastLabel.centerYAnchor.constraint(equalTo: toastLabel.superview!.bottomAnchor, constant: -200).isActive = true
        toastLabel.superview?.layoutIfNeeded()
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension UIViewController {
    func showToast(_ message:String) {
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.secondaryColor
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont.appFont(ofSize: 12)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        toastLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        toastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 35).isActive = true
        toastLabel.centerXAnchor.constraint(equalTo: toastLabel.superview!.centerXAnchor).isActive = true
        toastLabel.centerYAnchor.constraint(equalTo: toastLabel.superview!.bottomAnchor, constant: -200).isActive = true
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations:
            {
                toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

extension UIWindow {
    func showToast(_ message:String, backgroundColor: UIColor = UIColor.txtColor.withAlphaComponent(0.6), textColor: UIColor = UIColor.secondaryColor) {
        let toastLabel = UILabel()
        toastLabel.translatesAutoresizingMaskIntoConstraints = false
        toastLabel.numberOfLines = 0
        toastLabel.lineBreakMode = .byWordWrapping
        toastLabel.backgroundColor = backgroundColor
        toastLabel.textColor = textColor
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont.appFont(ofSize: 12)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.addSubview(toastLabel)
        toastLabel.widthAnchor.constraint(equalToConstant: 250).isActive = true
        toastLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 35).isActive = true
        toastLabel.centerXAnchor.constraint(equalTo: toastLabel.superview!.centerXAnchor).isActive = true
        toastLabel.centerYAnchor.constraint(equalTo: toastLabel.superview!.bottomAnchor, constant: -200).isActive = true
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    }
}

// MARK: -UINavigation Item Back Button

extension UINavigationItem {
    var backBtnString:String {
        get { return "" }
        set { self.backBarButtonItem = UIBarButtonItem(title: newValue, style: .plain, target: nil, action: nil) }
    }
}

// MARK: - Adding Shadow View

class ShadowView: UIView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setup()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    func setup() {
        self.layer.cornerRadius = 5.0
        self.layer.shadowColor = UIColor.txtColor.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
        self.layer.shadowOpacity = 0.4
        self.layer.shadowRadius = 4.0
    }
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return nil
    }
}

// MARK: - Localize() --> String
extension String {
    func localize() -> String {
        if RJKLocalize.shared.details.isEmpty {
            guard let path = try? FileManager().url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: true) else {
                                                        return ""
            }
            let fooURL = path.appendingPathComponent("lang-\(APIHelper.currentAppLanguage).json")
            guard let data = try? Data(contentsOf: fooURL) else {
                return ""
            }
            do {
                if let details =  try JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions.mutableContainers) as? [String:String] {
                    RJKLocalize.shared.details = details
                    return RJKLocalize.shared.details[self] ?? ""
                }
            }
            catch {
                print("Localize can't parse your file", error)
            }
            return ""

        } else {
            return RJKLocalize.shared.details[self] ?? self//""
        }
    }
}

// MARK: - UITextField add Icon
extension UITextField {
    
    
    func addIcon(_ image: UIImage?) {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        
        let imgView = UIImageView()
        imgView.image = image
        imgView.translatesAutoresizingMaskIntoConstraints = false
        imgView.contentMode = .scaleAspectFit
        view.addSubview(imgView)
        
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(4)-[imgView(20)]-(4)-|", options: [], metrics: nil, views: ["imgView":imgView]))
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[imgView(width)]-(10)-|", options: [], metrics: ["width":image == nil ? 0 : 20], views: ["imgView":imgView]))
        
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            leftViewMode = .always
            leftView = view
        } else {
            rightViewMode = .always
            rightView = view
        }
    }
    
    enum PaddingSide {
        case left(CGFloat)
        case right(CGFloat)
        case both(CGFloat)
    }

    func addPadding(_ padding: PaddingSide) {
        self.leftViewMode = .always
        self.layer.masksToBounds = true

        switch padding {
            case .left(let spacing):
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
                self.leftView = paddingView
                self.rightViewMode = .always

            case .right(let spacing):
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
                self.rightView = paddingView
                self.rightViewMode = .always

            case .both(let spacing):
                let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: spacing, height: self.frame.height))
                // left
                self.leftView = paddingView
                self.leftViewMode = .always
                // right
                self.rightView = paddingView
                self.rightViewMode = .always
        }
    }
    
    func drawFormField(placeholder: String) {
        self.font = .appRegularFont(ofSize: 15)
        self.textColor = .hexToColor("222B45")
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.hexToColor("8F9BB3"), NSAttributedString.Key.font: UIFont.appRegularFont(ofSize: 15)])
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.hexToColor("E4E9F2").cgColor
        self.layer.borderWidth = 1
        self.addPadding(.both(16))
    }
    
    func padding(_ width: CGFloat) {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: width, height: self.frame.size.height)
    
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            leftViewMode = .always
            leftView = view
        } else {
            rightViewMode = .always
            rightView = view
        }
    }
}

extension UITextField {
    func addDropDown(text: String, image: String) {
        
        self.font = .appRegularFont(ofSize: 15)
        self.textColor = .txtColor
        self.textAlignment = APIHelper.appTextAlignment
        self.autocorrectionType = .no
        self.autocapitalizationType = .none
        self.attributedPlaceholder = NSAttributedString(string: text, attributes: [NSAttributedString.Key.foregroundColor: UIColor.hexToColor("8F9BB3"), NSAttributedString.Key.font: UIFont.appRegularFont(ofSize: 15)])
        self.layer.cornerRadius = 4
        self.layer.borderColor = UIColor.hexToColor("E4E9F2").cgColor
        self.layer.borderWidth = 1
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.frame = CGRect(x: 0, y: 0, width: 10, height: self.frame.size.height)
        
        let btn = UIButton()
        btn.setImage(UIImage(named: image), for: .normal)
        btn.addTarget(self, action: #selector(btnPressed(_ :)), for: .touchUpInside)
        btn.frame = CGRect(x: 0, y: 0, width: 25, height: 25)
    
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            leftViewMode = .always
            leftView = view
            
            rightViewMode = .always
            rightView = btn
        } else {
            rightViewMode = .always
            rightView = view
            
            leftViewMode = .always
            leftView = btn
        }
    }
    @objc func btnPressed(_ sender: UIButton) {
        self.becomeFirstResponder()
    }
}

// MARK: - UILabel Inside set Text & Icon
extension UILabel {
    func set(text:String, with icon:UIImage?) {
        let attachment = NSTextAttachment()
        attachment.image = icon
        attachment.bounds = CGRect(x: 0, y: 0, width: 15, height: 15)
        let attachmentStr = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string: "")
        if APIHelper.appSemanticContentAttribute == .forceRightToLeft {
            myString.append(NSAttributedString(string: text))
            myString.append(NSAttributedString(string: " "))
            myString.append(attachmentStr)
        } else {
            myString.append(attachmentStr)
            myString.append(NSAttributedString(string: " "))
            myString.append(NSAttributedString(string: text))
        }
        attributedText = myString
    }
}
extension Dictionary where Key == String {
    func getInAmountFormat(str: String) -> String? {
        if let value = self[str], let amount = Double("\(value)"), amount > 0 {
            return String(format: "%.2f", amount)
        }
        return nil
    }
}

// MARK: - Google Url Components
extension URLComponents {
    
    func googleURLComponents(_ path: String,queryItem: [URLQueryItem]) -> String {
        APIHelper.googleApiComponents.scheme = "https"
        APIHelper.googleApiComponents.host = "maps.googleapis.com"
        APIHelper.googleApiComponents.path = path
        APIHelper.googleApiComponents.queryItems = queryItem
        if let url = APIHelper.googleApiComponents.url {
            return url.absoluteString
        } else {
            return ""
        }
    }
}

// MARK: - UITextField Image Set Left & Right

extension UITextField {
    enum Direction {
        case Left
        case Right
    }
    
    func addImage(direction:Direction,imageName:String,frame:CGRect,backgroundColor:UIColor) {
        let view = UIView(frame: frame)
        view.backgroundColor = backgroundColor
        
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 35, height: 25))
        imageView.center = view.center
        imageView.image = UIImage(named: imageName)
        
        view.addSubview(imageView)
        
        if direction == Direction.Left {
            self.leftViewMode = .always
            self.leftView = view
        } else {
            self.rightViewMode = .always
            self.rightView = view
        }
    }
}

//Haversine function to get bearing between 2 locations
extension CLLocationCoordinate2D {
    func bearing(to point: CLLocationCoordinate2D) -> Double {
        func degreesToRadians(_ degrees: Double) -> Double { return degrees * Double.pi / 180.0 }
        func radiansToDegrees(_ radians: Double) -> Double { return radians * 180.0 / Double.pi }

        let lat1 = degreesToRadians(latitude)
        let lon1 = degreesToRadians(longitude)

        let lat2 = degreesToRadians(point.latitude)
        let lon2 = degreesToRadians(point.longitude)

        let dLon = lon2 - lon1

        let y = sin(dLon) * cos(lat2)
        let x = cos(lat1) * sin(lat2) - sin(lat1) * cos(lat2) * cos(dLon)
        let radiansBearing = atan2(y, x)

        return radiansToDegrees(radiansBearing)
    }
}

// MARK: - Polyline Animate in map

public class AnimatedPolyLine: GMSPolyline {
    var animationPolyline = GMSPolyline()
    var animationPath = GMSMutablePath()
    var i: UInt = 0
    var timer: Timer!
    private var repeats:Bool!
    override init() {
        super.init()
    }
    deinit {
        print("de init called")
    }
    convenience init(_ points: String,repeats:Bool) {
        self.init()
        self.repeats = repeats
        self.path = GMSPath.init(fromEncodedPath: points)!

        self.strokeColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.3)
        self.strokeWidth = 4.0
        if self.timer != nil {
            self.timer.invalidate()
            self.timer = nil
        }
        let count = self.path!.count()
        
        let interval = count < 200 ? 0.001 : 0.000001
        self.timer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(animatePolylinePath), userInfo: nil, repeats: true)
    }
    @objc func animatePolylinePath(_ sender:Timer) {
      
        if self.i < (self.path?.count())! {
            self.animationPath.add((self.path?.coordinate(at: self.i))!)
            self.animationPolyline.path = self.animationPath
            self.animationPolyline.strokeColor = UIColor.txtColor
            self.animationPolyline.strokeWidth = 4
            self.animationPolyline.map = self.map
            self.i += 1
        } else {
            if self.repeats {
                self.i = 0
                self.animationPath = GMSMutablePath()
                self.animationPolyline.map = nil
            }
            else {
                sender.invalidate()
                if self.timer != nil
                {
                    self.timer = nil
                }
            }
        }
        
    }
}

extension Date {
    var millisecondsSince1970:Int64 {
        return Int64((self.timeIntervalSince1970 * 1000.0).rounded())
    }

    init(milliseconds:Int64) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
extension UIView {
    func removeAllConstraints() {
        self.removeConstraints(self.constraints)
        self.subviews.forEach { $0.removeAllConstraints() }
    }
}

extension UIImage {
    func resized(withPercentage percentage: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: size.width * percentage, height: size.height * percentage)
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    func resized(toWidth width: CGFloat) -> UIImage? {
        let canvasSize = CGSize(width: width, height: CGFloat(ceil(width/size.width * size.height)))
        UIGraphicsBeginImageContextWithOptions(canvasSize, false, scale)
        defer { UIGraphicsEndImageContext() }
        draw(in: CGRect(origin: .zero, size: canvasSize))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
}
// To resize the captured image
extension UIImage {
    func fixedOrientation() -> UIImage {

        if imageOrientation == .up {
            return self
        }

        var transform: CGAffineTransform = CGAffineTransform.identity

        switch imageOrientation {
        case .down, .downMirrored:
            transform = transform.translatedBy(x: size.width, y: size.height)
            transform = transform.rotated(by: CGFloat.pi)
        case .left, .leftMirrored:
            transform = transform.translatedBy(x: size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
        case .right, .rightMirrored:
            transform = transform.translatedBy(x: 0, y: size.height)
            transform = transform.rotated(by: CGFloat.pi / -2)
        case .up, .upMirrored:
            break
        @unknown default:
            print("default")
        }

        switch imageOrientation {
        case .upMirrored, .downMirrored:
            transform.translatedBy(x: size.width, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .leftMirrored, .rightMirrored:
            transform.translatedBy(x: size.height, y: 0)
            transform.scaledBy(x: -1, y: 1)
        case .up, .down, .left, .right:
            break
        @unknown default:
            print("default")
        }

        if let cgImage = self.cgImage, let colorSpace = cgImage.colorSpace,
            let ctx: CGContext = CGContext(data: nil, width: Int(size.width), height: Int(size.height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue) {
            ctx.concatenate(transform)

            switch imageOrientation {
            case .left, .leftMirrored, .right, .rightMirrored:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.height, height: size.width))
            default:
                ctx.draw(cgImage, in: CGRect(x: 0, y: 0, width: size.width, height: size.height))
            }
            if let ctxImage: CGImage = ctx.makeImage() {
                return UIImage(cgImage: ctxImage)
            } else {
                return self
            }
        } else {
            return self
        }
    }
}
extension UIButton  {
    func setAppImage(_ imageName: String) {
        self.tintColor = .txtColor
        self.setImage(UIImage(named: imageName)?.withRenderingMode(.alwaysTemplate).imageFlippedForRightToLeftLayoutDirection(), for: .normal)
        
    }
}
extension UIView {
    func removeAllConstraint() {
        self.removeConstraints(self.constraints)
        self.subviews.forEach { $0.removeAllConstraint() }
    }
}
extension Double {
    func roundTo(places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

extension UIApplication {
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
}
extension UIViewController {
    
    func retriveImg(key: String, completion:@escaping(Data)->Void) {
        
        let transferUtility = AWSS3TransferUtility.default()
        let expression = AWSS3TransferUtilityDownloadExpression()
        expression.progressBlock = {(task, progress) in DispatchQueue.main.async(execute: {
            
        })
        }
        transferUtility.downloadData(fromBucket: "", key: key, expression: expression) { (task, url, data, error) in
            if let error = error {
                print("ERROR",error)
            }
            DispatchQueue.main.async(execute: {
                if let imgdata = data {
                    print("IMGDATA",imgdata)
                    completion(imgdata)
                }
            })
            
        }
    }
    
    func retriveImgFromBucket(key: String, completion:@escaping(UIImage)->Void) {
    
        if let cachedImage = ImageCache.shared.object(forKey: key as NSString) {
            print("Image from cache")
            completion(cachedImage)
            return
        }
        let transferUtility = AWSS3TransferUtility.default()
        let expression = AWSS3TransferUtilityDownloadExpression()

        transferUtility.downloadData(fromBucket: "", key: key, expression: expression) { (task, url, data, error) in
            if let error = error {
                print("ERROR",error)
            }
            DispatchQueue.main.async(execute: {
                if let imgdata = data, let image = UIImage(data: imgdata) {
                    print("IMGDATA",imgdata)
                    ImageCache.shared.setObject(image, forKey: key as NSString)
                    completion(image)
                }
            })

        }
        
    }
}
class ImageCache {

    private init() {}

    static let shared = NSCache<NSString, UIImage>()
}

extension UIViewController {
    func checkTime(startTime: Int? = 21,endTime: Int? = 06,completion: @escaping(Bool) ->Void) {
        print("nyt start time",startTime)
        print("nyt end time",endTime)
        var timeExist:Bool = false
        let calendar = Calendar.current
        print(calendar)
        let startTimeComponent = DateComponents(calendar: calendar, hour: startTime, minute: 00)
        let endTimeComponent   = DateComponents(calendar: calendar, hour: endTime, minute: 00)

        let now = Date()
        let startOfToday = calendar.startOfDay(for: now)
        let startTime    = calendar.date(byAdding: startTimeComponent, to: startOfToday)!
        let endTime      = calendar.date(byAdding: endTimeComponent, to: startOfToday)!

        if startTime <= now || now <= endTime {
            timeExist = true
        } else {
            timeExist = false
        }
        completion(timeExist)
    }
}

class ShimmerView: UIView {

    var gradientLayer = CAGradientLayer()
    
    var gradientColorOne : CGColor = UIColor(white: 0.85, alpha: 1.0).cgColor
    var gradientColorTwo : CGColor = UIColor(white: 0.95, alpha: 1.0).cgColor
    
    
    
    func addGradientLayer() -> CAGradientLayer {
        
        
        
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 1.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradientLayer.colors = [gradientColorOne, gradientColorTwo, gradientColorOne]
        gradientLayer.locations = [0.0, 0.5, 1.0]
        self.layer.addSublayer(gradientLayer)
        
        return gradientLayer
    }
    
    
    func addAnimation() -> CABasicAnimation {
       
        let animation = CABasicAnimation(keyPath: "locations")
        animation.fromValue = [-1.0, -0.5, 0.0]
        animation.toValue = [1.0, 1.5, 2.0]
        animation.repeatCount = .infinity
        animation.duration = 0.9
        return animation
    }
    
    func removeAnimation() {
        self.layer.removeAllAnimations()
        gradientLayer.isHidden = true
    }
    
    func startAnimating() {
        
        let gradientLayer = addGradientLayer()
        let animation = addAnimation()
       
        gradientLayer.add(animation, forKey: animation.keyPath)
    }
    
    func stopAnimating() {
        removeAnimation() 
    }

}
