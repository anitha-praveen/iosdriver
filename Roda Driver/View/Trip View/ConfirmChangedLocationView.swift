//
//  ConfirmChangedLocationView.swift
//  Taxiappz Driver
//
//  Created by Apple on 10/03/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import UIKit

class ConfirmChangedLocationView: UIView {
    
    let viewContent = UIView()
    let lblHeader = UILabel()
    
    let lblHint = UILabel()
    
    let lblAddress = UILabel()
    
    let btnCancel = UIButton()
    
    let btnConfirm = UIButton()
    
    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        
        viewContent.layer.cornerRadius = 10
        viewContent.backgroundColor = .secondaryColor
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewContent)
        
        lblHeader.text = APIHelper.shared.appName
        lblHeader.textColor = .themeColor
        lblHeader.textAlignment = .center
        lblHeader.font = UIFont.appSemiBold(ofSize: 20)
        layoutDict["lblHeader"] = lblHeader
        lblHeader.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblHeader)
        
        lblHint.text = "change_drop_request".localize()
        lblHint.numberOfLines = 0
        lblHint.lineBreakMode = .byWordWrapping
        lblHint.textColor = .txtColor
        lblHint.textAlignment = .center
        lblHint.font = UIFont.appRegularFont(ofSize: 18)
        layoutDict["lblHint"] = lblHint
        lblHint.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblHint)
        
        lblAddress.numberOfLines = 0
        lblAddress.lineBreakMode = .byWordWrapping
        lblAddress.textColor = .txtColor
        lblAddress.textAlignment = .center
        lblAddress.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["lblAddress"] = lblAddress
        lblAddress.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblAddress)
        
        
        btnCancel.setTitle("text_cancel".localize(), for: .normal)
        btnCancel.layer.cornerRadius = 5
        btnCancel.layer.borderWidth = 1
        btnCancel.layer.borderColor = UIColor.themeColor.cgColor
        btnCancel.setTitleColor(.txtColor, for: .normal)
        btnCancel.backgroundColor = .secondaryColor
        btnCancel.titleLabel?.font = UIFont.appSemiBold(ofSize: 15)
        layoutDict["btnCancel"] = btnCancel
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnCancel)
        
        btnConfirm.setTitle("txt_confirm".localize(), for: .normal)
        btnConfirm.layer.cornerRadius = 5
        btnConfirm.layer.borderWidth = 1
        btnConfirm.layer.borderColor = UIColor.themeColor.cgColor
        btnConfirm.setTitleColor(.secondaryColor, for: .normal)
        btnConfirm.backgroundColor = .themeColor
        btnConfirm.titleLabel?.font = UIFont.appSemiBold(ofSize: 15)
        layoutDict["btnConfirm"] = btnConfirm
        btnConfirm.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnConfirm)
        
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[viewContent]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.viewContent.centerYAnchor.constraint(equalTo: baseView.centerYAnchor, constant: 0).isActive = true
        
        self.viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblHeader]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblHint]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblAddress]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
         self.viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[lblHeader(30)]-8-[lblHint]-8-[lblAddress]-20-[btnConfirm(40)]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
         self.viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[btnCancel]-10-[btnConfirm(==btnCancel)]-10-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
        
    }
}
