//
//  AcceptRejectView.swift
//  Taxiappz Driver
//
//  Created by Apple on 18/08/20.
//  Copyright © 2020 nPlus. All rights reserved.
//

import UIKit
import MTSlideToOpen
import GoogleMaps

class AcceptRejectView: UIView {

    let rejectBtn = MTSlideToOpenView()
    
    let viewAddress = UIView()
    
    let stackAddress = UIStackView()
    
    let pickupView = UIView()
    let viewPickupColor = UIView()
    let lblPickup = UILabel()
    
    let separator = UIView()
    
    let stopView = UIView()
    let viewStopColor = UIView()
    let lblStop = UILabel()
    
    let dropView = UIView()
    let viewDropColor = UIView()
    let lblDrop = UILabel()
    
    let tripDetialsStackView = UIStackView()
    
    let tripStartTimeLabel = UILabel()
    let tripEndTimeLabel = UILabel()
    
    let serviceTypeLabel = UILabel()
    
    let lblCount = UILabel()
    
    let circleAnimationView = CircleAnimationView()

    let acceptButton = UIButton()
 
    let nameView = UIView()
    let lblName = UILabel()
    let lblRating = UILabel()
    
  //  let acceptBtn = MTSlideToOpenView()
    
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base controller: UIViewController) {
        
        controller.view.backgroundColor = .gray
        
        if APIHelper.appLanguageDirection == . directionRightToLeft {
            rejectBtn.appLanguageEnglish = false
        } else {
            rejectBtn.appLanguageEnglish = true
        }
        rejectBtn.textLabelLeadingDistance = 10
        rejectBtn.sliderViewTopDistance = 0
        rejectBtn.sliderCornerRadius = 25
        rejectBtn.sliderBackgroundColor = .hexToColor("ACB1C0")
        rejectBtn.slidingColor = .clear
        rejectBtn.thumbnailViewTopDistance = 0
        rejectBtn.thumbnailViewStartingDistance = 0
        rejectBtn.thumnailImageView.backgroundColor = .secondaryColor
        rejectBtn.thumnailImageView.image = UIImage(named: "ic_reject_cross")
        rejectBtn.labelText = "txt_slide_cancel".localize().uppercased()
        rejectBtn.textFont = UIFont.appSemiBold(ofSize: 18)
        rejectBtn.textColor = .secondaryColor
        layoutDict["rejectBtn"] = rejectBtn
        rejectBtn.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addSubview(rejectBtn)
        
        viewAddress.layer.cornerRadius = 10
        viewAddress.backgroundColor = .secondaryColor
        viewAddress.addShadow()
        layoutDict["viewAddress"] = viewAddress
        viewAddress.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addSubview(viewAddress)
        
        stackAddress.axis = .vertical
        stackAddress.distribution = .fill
        layoutDict["stackAddress"] = stackAddress
        stackAddress.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(stackAddress)
        
        tripDetialsStackView.axis = .vertical
        tripDetialsStackView.distribution = .fill
        layoutDict["tripDetialsStackView"] = tripDetialsStackView
        tripDetialsStackView.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addSubview(tripDetialsStackView)
        
        serviceTypeLabel.isHidden = true
        serviceTypeLabel.textAlignment = .center
        serviceTypeLabel.textColor = .secondaryColor
        serviceTypeLabel.font = UIFont.appSemiBold(ofSize: 18)
        layoutDict["serviceTypeLabel"] = serviceTypeLabel
        serviceTypeLabel.translatesAutoresizingMaskIntoConstraints = false
        tripDetialsStackView.addArrangedSubview(serviceTypeLabel)
        
        tripStartTimeLabel.isHidden = true
        tripStartTimeLabel.textAlignment = .center
        tripStartTimeLabel.textColor = .secondaryColor
        tripStartTimeLabel.font = UIFont.appSemiBold(ofSize: 18)
        layoutDict["tripStartTimeLabel"] = tripStartTimeLabel
        tripStartTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        tripDetialsStackView.addArrangedSubview(tripStartTimeLabel)
        
        tripEndTimeLabel.isHidden = true
        tripEndTimeLabel.textAlignment = .center
        tripEndTimeLabel.textColor = .secondaryColor
        tripEndTimeLabel.font = UIFont.appSemiBold(ofSize: 18)
        layoutDict["tripEndTimeLabel"] = tripEndTimeLabel
        tripEndTimeLabel.translatesAutoresizingMaskIntoConstraints = false
        tripDetialsStackView.addArrangedSubview(tripEndTimeLabel)
        
        
        
        layoutDict["pickupView"] = pickupView
        pickupView.translatesAutoresizingMaskIntoConstraints = false
        stackAddress.addArrangedSubview(pickupView)
        
        viewPickupColor.layer.cornerRadius = 5
        viewPickupColor.backgroundColor = .txtColor
        layoutDict["viewPickupColor"] = viewPickupColor
        viewPickupColor.translatesAutoresizingMaskIntoConstraints = false
        pickupView.addSubview(viewPickupColor)
        
        lblPickup.textColor = .txtColor
        lblPickup.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblPickup"] = lblPickup
        lblPickup.translatesAutoresizingMaskIntoConstraints = false
        pickupView.addSubview(lblPickup)
        
        separator.backgroundColor = .hexToColor("E4E9F2")
        layoutDict["separator"] = separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        stackAddress.addSubview(separator)
        
        layoutDict["stopView"] = stopView
        stopView.translatesAutoresizingMaskIntoConstraints = false
        stackAddress.addArrangedSubview(stopView)
        
        viewStopColor.backgroundColor = .red
        layoutDict["viewStopColor"] = viewStopColor
        viewStopColor.translatesAutoresizingMaskIntoConstraints = false
        stopView.addSubview(viewStopColor)
        
        lblStop.textColor = .txtColor
        lblStop.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblStop"] = lblStop
        lblStop.translatesAutoresizingMaskIntoConstraints = false
        stopView.addSubview(lblStop)
        
        layoutDict["dropView"] = dropView
        dropView.translatesAutoresizingMaskIntoConstraints = false
        stackAddress.addArrangedSubview(dropView)
        
        viewDropColor.backgroundColor = .themeColor
        layoutDict["viewDropColor"] = viewDropColor
        viewDropColor.translatesAutoresizingMaskIntoConstraints = false
        dropView.addSubview(viewDropColor)
        
        lblDrop.textColor = .txtColor
        lblDrop.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblDrop"] = lblDrop
        lblDrop.translatesAutoresizingMaskIntoConstraints = false
        dropView.addSubview(lblDrop)
        
      
        lblCount.textColor = .secondaryColor
        lblCount.font = UIFont.appBoldFont(ofSize: 50)
        layoutDict["lblCount"] = lblCount
        lblCount.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addSubview(lblCount)
        
       
        circleAnimationView.backgroundColor = UIColor.clear
        layoutDict["circleAnimationView"] = circleAnimationView
        circleAnimationView.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addSubview(circleAnimationView)
        
        acceptButton.setTitle("txt_accept".localize(), for: .normal)
        acceptButton.titleLabel?.font = UIFont.boldSystemFont(ofSize: 35)
        acceptButton.setTitleColor(.txtColor, for: .normal)
        acceptButton.backgroundColor = .hexToColor("00AE73")
        layoutDict["acceptButton"] = acceptButton
        acceptButton.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addSubview(acceptButton)
        
        layoutDict["nameView"] = nameView
        nameView.translatesAutoresizingMaskIntoConstraints = false
        controller.view.addSubview(nameView)
        
        lblName.textColor = .secondaryColor
        lblName.font = UIFont.appSemiBold(ofSize: 18)
        layoutDict["lblName"] = lblName
        lblName.translatesAutoresizingMaskIntoConstraints = false
        nameView.addSubview(lblName)
        
        lblRating.textColor = .secondaryColor
        lblRating.font = UIFont.appSemiBold(ofSize: 18)
        layoutDict["lblRating"] = lblRating
        lblRating.translatesAutoresizingMaskIntoConstraints = false
        nameView.addSubview(lblRating)
        
//        if APIHelper.appLanguageDirection == . directionRightToLeft {
//            acceptBtn.appLanguageEnglish = false
//        } else {
//            acceptBtn.appLanguageEnglish = true
//        }
//        acceptBtn.textLabelLeadingDistance = 10
//        acceptBtn.sliderViewTopDistance = 0
//        acceptBtn.sliderCornerRadius = 25
//        acceptBtn.sliderBackgroundColor = .hexToColor("ACB1C0")
//        acceptBtn.slidingColor = .clear
//        acceptBtn.thumbnailViewTopDistance = 0
//        acceptBtn.thumbnailViewStartingDistance = 0
//        acceptBtn.thumnailImageView.backgroundColor = .secondaryColor
//        acceptBtn.thumnailImageView.image = UIImage(named: "ic_accept_tick")
//        acceptBtn.labelText = "txt_slide_to_accept".localize().uppercased()
//        acceptBtn.textFont = UIFont.appSemiBold(ofSize: 18)
//        acceptBtn.textColor = .secondaryColor
//        layoutDict["acceptBtn"] = acceptBtn
//        acceptBtn.translatesAutoresizingMaskIntoConstraints = false
//        controller.view.addSubview(acceptBtn)
        
        rejectBtn.topAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
       // acceptBtn.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
        nameView.bottomAnchor.constraint(equalTo: controller.view.safeAreaLayoutGuide.bottomAnchor, constant: -25).isActive = true
        controller.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-60-[rejectBtn]-60-|", options: [], metrics: nil, views: layoutDict))
        controller.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[rejectBtn(50)]-20-[viewAddress]-20-[tripDetialsStackView]-20-[lblCount(40)]-30-[circleAnimationView]-30-[nameView]", options: [], metrics: nil, views: layoutDict))
        controller.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewAddress]-16-|", options: [], metrics: nil, views: layoutDict))
        controller.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[tripDetialsStackView]-16-|", options: [], metrics: nil, views: layoutDict))
        
        tripStartTimeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        tripEndTimeLabel.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        lblCount.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor, constant: 0).isActive = true
        
        
        circleAnimationView.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor, constant: 0).isActive = true
        circleAnimationView.widthAnchor.constraint(equalTo: circleAnimationView.heightAnchor, constant: 0).isActive = true
        nameView.centerXAnchor.constraint(equalTo: controller.view.centerXAnchor, constant: 0).isActive = true

        nameView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblName]-5-[lblRating]|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
        nameView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblName(30)]|", options: [], metrics: nil, views: layoutDict))
        
      //  controller.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-60-[acceptBtn]-60-|", options: [], metrics: nil, views: layoutDict))
    
        acceptButton.centerXAnchor.constraint(equalTo: circleAnimationView.centerXAnchor, constant: 0).isActive = true
        acceptButton.centerYAnchor.constraint(equalTo: circleAnimationView.centerYAnchor, constant: 0).isActive = true
        acceptButton.widthAnchor.constraint(equalTo: circleAnimationView.widthAnchor, constant: -10).isActive = true
        acceptButton.heightAnchor.constraint(equalTo: circleAnimationView.heightAnchor, constant: -10).isActive = true
    
        
        // -------------------View Address
        
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackAddress]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackAddress]|", options: [], metrics: nil, views: layoutDict))
        
        pickupView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewPickupColor(10)]-16-[lblPickup]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        pickupView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblPickup(30)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewPickupColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        viewPickupColor.centerYAnchor.constraint(equalTo: lblPickup.centerYAnchor, constant: 0).isActive = true
        
        stopView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewStopColor(10)]-16-[lblStop]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        stopView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblStop(30)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewStopColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        viewStopColor.centerYAnchor.constraint(equalTo: lblStop.centerYAnchor, constant: 0).isActive = true
        
        dropView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewDropColor(10)]-16-[lblDrop]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        dropView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblDrop(30)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewDropColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        viewDropColor.centerYAnchor.constraint(equalTo: lblDrop.centerYAnchor, constant: 0).isActive = true
        

    }
    
}
extension UIView {
   func createVerticalDottedLine(width: CGFloat, color: CGColor) {
      let caShapeLayer = CAShapeLayer()
      caShapeLayer.strokeColor = color
      caShapeLayer.lineWidth = width
      caShapeLayer.lineDashPattern = [3,3]
      let cgPath = CGMutablePath()
      let cgPoint = [CGPoint(x: self.frame.width/2, y: 5), CGPoint(x: self.frame.width/2, y: self.frame.height-5)]
      cgPath.addLines(between: cgPoint)
      caShapeLayer.path = cgPath
      layer.addSublayer(caShapeLayer)
   }
}



