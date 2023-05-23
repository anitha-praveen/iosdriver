//
//  SubscriptionCell.swift
//  Taxiappz Driver
//
//  Created by Apple on 04/03/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import UIKit
import DSGradientProgressView

class SubscriptionCell: UITableViewCell {
    
    let viewContent = UIView()
    let viewValidity = UIView()
    let lblValidity = UILabel()
    let lblName = UIButton()
    let lblDescription = UILabel()
    let viewAmount = UIView()
    let lblAmount = UILabel()
    
    let btnSubscribe = UIButton()
    
    var layoutDict = [String:Any]()
    var subscribeAction:(()->())?
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupViews()
        subscriptionCheck()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    func setupViews() {
        
        contentView.isUserInteractionEnabled = true
        self.selectionStyle = .none
        
        viewContent.layer.cornerRadius = 10
        viewContent.addShadow()
        viewContent.backgroundColor = .secondaryColor
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewContent)
        
        layoutDict["viewValidity"] = viewValidity
        viewValidity.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(viewValidity)
        
        lblValidity.textColor = .txtColor
        lblValidity.textAlignment = .center
        lblValidity.font = UIFont.appBoldFont(ofSize: 26)
        layoutDict["lblValidity"] = lblValidity
        lblValidity.translatesAutoresizingMaskIntoConstraints = false
        viewValidity.addSubview(lblValidity)
        
        lblName.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        lblName.backgroundColor = UIColor.hexToColor("DADADA")
        lblName.layer.cornerRadius = 10
        lblName.setTitleColor(.txtColor, for: .normal)
        lblName.titleLabel?.font = UIFont.appSemiBold(ofSize: 12)
        layoutDict["lblName"] = lblName
        lblName.translatesAutoresizingMaskIntoConstraints = false
        viewValidity.addSubview(lblName)
        
        lblDescription.isHidden = true
        lblDescription.numberOfLines = 0
        lblDescription.lineBreakMode = .byWordWrapping
        lblDescription.textColor = .txtColor
        lblDescription.textAlignment = APIHelper.appTextAlignment
        lblDescription.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblDescription"] = lblDescription
        lblDescription.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblDescription)
        
        layoutDict["viewAmount"] = viewAmount
        viewAmount.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(viewAmount)
        
        lblAmount.textColor = .txtColor
        lblAmount.textAlignment = .center
        lblAmount.font = UIFont.appBoldFont(ofSize: 28)
        layoutDict["lblAmount"] = lblAmount
        lblAmount.translatesAutoresizingMaskIntoConstraints = false
        viewAmount.addSubview(lblAmount)
        
        
        
        btnSubscribe.addTarget(self, action: #selector(btnSubscribePressed(_ :)), for: .touchUpInside)
        btnSubscribe.setTitle("txt_subscribe".localize(), for: .normal)
        btnSubscribe.setTitleColor(.green, for: .normal)
        btnSubscribe.setTitleColor(.lightGray, for: .disabled)
        btnSubscribe.titleLabel?.font = UIFont.appSemiBold(ofSize: 15)
        layoutDict["btnSubscribe"] = btnSubscribe
        btnSubscribe.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnSubscribe)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[viewContent]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[viewContent]-12-|", options: [], metrics: nil, views: layoutDict))
        
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[viewValidity]-8-[btnSubscribe(30)]-8-|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewValidity][viewAmount(==viewValidity)]|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
       
        lblName.centerXAnchor.constraint(equalTo: viewValidity.centerXAnchor, constant: 0).isActive = true
        viewValidity.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[lblValidity]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewValidity.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblValidity]-5-[lblName(20)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btnSubscribe]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewAmount.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblAmount]-12-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewAmount.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblAmount]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
    }
    
    @objc func btnSubscribePressed(_ sender: UIButton) {
        if let action = self.subscribeAction {
            action()
        }
    }
    
    func subscriptionCheck() {
        if LocalDB.shared.isSubscriptionEnabled == true {
            btnSubscribe.isEnabled = true
        } else {
            btnSubscribe.isEnabled = false
            print("DISABLED")
        }
    }
    
}
