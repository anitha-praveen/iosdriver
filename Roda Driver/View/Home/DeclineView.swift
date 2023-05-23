//
//  DeclineView.swift
//  Taxiappz Driver
//
//  Created by spextrum on 22/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit

class DeclineView: UIView {

    // MARK: Driver Declined (Screen UI)
    
    let imgView = UIImageView()
    let lblHint = UILabel()
    let infoLbl = UILabel()
    let closeBtn = UIButton()
    
    var closeBtnBottomConstraint:NSLayoutConstraint?
    var layoutDic = [String:AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: Adding UI Element in setupViews
    
    func setUpViews(_ controller: OnlineOfflineVC) {
        self.backgroundColor = .themeColor
        
        let vBase = UIView()
        vBase.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["vBase"] = vBase
        addSubview(vBase)
        
        let infoView = UIView()
        infoView.backgroundColor = .hexToColor("FB4A46")
        layoutDic["infoView"] = infoView
        infoView.translatesAutoresizingMaskIntoConstraints = false
        vBase.addSubview(infoView)
        
        imgView.tintColor = .themeTxtColor
        imgView.image = UIImage(named: "Timed")?.withRenderingMode(.alwaysTemplate)
        imgView.contentMode = .scaleAspectFit
        layoutDic["imgView"] = imgView
        imgView.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(imgView)
        
        lblHint.textAlignment = .center
        lblHint.text = "txt_thank_u_time".localize()
        lblHint.numberOfLines = 0
        lblHint.lineBreakMode = .byWordWrapping
        lblHint.textColor = .themeTxtColor
        lblHint.font = UIFont.appSemiBold(ofSize: 30)
        layoutDic["lblHint"] = lblHint
        lblHint.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(lblHint)
        
        infoLbl.textAlignment = .center
        infoLbl.numberOfLines = 0
        infoLbl.lineBreakMode = .byWordWrapping
        infoLbl.text = "txt_thanks_create".localize()
        infoLbl.textColor = .themeTxtColor
        infoLbl.font = UIFont.appRegularFont(ofSize: 18)
        layoutDic["infoLbl"] = infoLbl
        infoLbl.translatesAutoresizingMaskIntoConstraints = false
        infoView.addSubview(infoLbl)
        
        closeBtn.layer.cornerRadius = 5
        closeBtn.setTitleColor(.themeColor, for: .normal)
        closeBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        closeBtn.backgroundColor = .secondaryColor
        layoutDic["closeBtn"] = closeBtn
        closeBtn.translatesAutoresizingMaskIntoConstraints = false
        vBase.addSubview(closeBtn)
        
        if #available(iOS 11.0, *) {
            vBase.topAnchor.constraint(equalTo: self.safeAreaLayoutGuide.topAnchor).isActive = true
            vBase.bottomAnchor.constraint(equalTo: self.safeAreaLayoutGuide.bottomAnchor).isActive = true
        } else {
            vBase.topAnchor.constraint(equalTo: controller.topLayoutGuide.bottomAnchor).isActive = true
            vBase.bottomAnchor.constraint(equalTo: controller.bottomLayoutGuide.topAnchor).isActive = true
        }
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[vBase]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        vBase.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-80-[infoView]", options: [], metrics: nil, views: layoutDic))
        vBase.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[infoView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        infoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[imgView(100)]-23-[lblHint]-16-[infoLbl]", options: [], metrics: nil, views: layoutDic))
        infoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblHint]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        infoView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[infoLbl]-32-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        imgView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        imgView.centerXAnchor.constraint(equalTo: self.centerXAnchor, constant: 0).isActive = true
        
        vBase.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[closeBtn(50)]-10-|", options: [], metrics: nil, views: layoutDic))
        vBase.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[closeBtn]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
    }
    
    
}
