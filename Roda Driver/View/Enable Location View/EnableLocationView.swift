//
//  EnableLocationView.swift
//  Taxiappz
//
//  Created by Apple on 06/01/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import UIKit

class EnableLocationView: UIView {
    
    let imgview = UIImageView()
    let lblTitle = UILabel()
    let lblHint = UILabel()
    
    let btnConfirm = UIButton()

    
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        imgview.image = UIImage(named: "img_loc_enable")
        imgview.contentMode = .scaleAspectFit
        layoutDict["imgview"] = imgview
        imgview.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(imgview)
      
        lblTitle.text = APIHelper.shared.appName
        lblTitle.textColor = .txtColor
        lblTitle.textAlignment = .center
        lblTitle.font = UIFont.appSemiBold(ofSize: 30)
        layoutDict["lblTitle"] = lblTitle
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblTitle)
        
        
        lblHint.text = "txt_disclosure".localize()
        lblHint.numberOfLines = 0
        lblHint.lineBreakMode = .byWordWrapping
        lblHint.textColor = .hexToColor("#9B9B9B")
        lblHint.textAlignment = .center
        lblHint.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["lblHint"] = lblHint
        lblHint.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblHint)
        
        
        btnConfirm.setTitle("txt_plain_enable".localize().uppercased(), for: .normal)
        btnConfirm.setTitleColor(.secondaryColor, for: .normal)
        btnConfirm.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnConfirm.backgroundColor = .themeColor
        layoutDict["btnConfirm"] = btnConfirm
        btnConfirm.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnConfirm)
        
      
        
        imgview.bottomAnchor.constraint(equalTo: baseView.centerYAnchor, constant: -30).isActive = true
        imgview.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 0).isActive = true
        imgview.widthAnchor.constraint(equalToConstant: 150).isActive = true
        imgview.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        btnConfirm.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        btnConfirm.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[imgview]-12-[lblTitle(30)]-20-[lblHint]", options: [], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblTitle]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[lblHint]-40-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[btnConfirm]|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
        
       
        
    }
    
    
}
