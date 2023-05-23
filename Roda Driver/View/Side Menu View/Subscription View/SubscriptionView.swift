//
//  SubscriptionView.swift
//  Taxiappz Driver
//
//  Created by Apple on 04/03/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import UIKit


class SubscriptionView: UIView {

    let tblView = UITableView(frame: .zero, style: .grouped)

    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .themeColor
        
        tblView.alwaysBounceVertical = false
        tblView.separatorStyle = .none
        tblView.backgroundColor = .secondaryColor
        layoutDict["tblView"] = tblView
        tblView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(tblView)
        

        tblView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        tblView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tblView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))

    }
}

class HeaderTableView: UITableViewHeaderFooterView {
    
    let headerView = UIView()
    let topView = UIView()
    let backBtn = UIButton()
    let userImgView = UIImageView()
    let lblName = UILabel()
    let lblChoosePlan = UILabel()
    
    var layoutDict = [String: AnyObject]()
    override init(reuseIdentifier: String?) {
            super.init(reuseIdentifier: reuseIdentifier)
            configureContents()
        }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func configureContents() {
        contentView.isUserInteractionEnabled = true
        
        layoutDict["headerView"] = headerView
        headerView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(headerView)
        
        topView.backgroundColor = .themeColor
        layoutDict["topView"] = topView
        topView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(topView)
        
        backBtn.backgroundColor = .secondaryColor
        backBtn.layer.cornerRadius = 20
        backBtn.setAppImage("BackImage")
        layoutDict["backBtn"] = backBtn
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        topView.addSubview(backBtn)
        
        userImgView.layer.cornerRadius = 10
        userImgView.backgroundColor = .hexToColor("DADADA")
        layoutDict["userImgView"] = userImgView
        userImgView.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(userImgView)
        
       
        lblName.textColor = .gray
        lblName.textAlignment = .center
        lblName.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["lblName"] = lblName
        lblName.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(lblName)
        
        lblChoosePlan.text = "txt_choose_your_plan".localize()
        lblChoosePlan.textColor = .txtColor
        lblChoosePlan.textAlignment = .center
        lblChoosePlan.font = UIFont.systemFont(ofSize: 25)
        layoutDict["lblChoosePlan"] = lblChoosePlan
        lblChoosePlan.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(lblChoosePlan)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[headerView]|", options: [], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[headerView]|", options: [], metrics: nil, views: layoutDict))
        
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[topView]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[topView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        topView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(40)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        topView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[backBtn(40)]-60-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        userImgView.centerYAnchor.constraint(equalTo: topView.bottomAnchor, constant: 0).isActive = true
        userImgView.heightAnchor.constraint(equalToConstant: 70).isActive = true
        userImgView.widthAnchor.constraint(equalToConstant: 70).isActive = true
        userImgView.centerXAnchor.constraint(equalTo: headerView.centerXAnchor, constant: 0).isActive = true
        
        
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[userImgView]-10-[lblName(30)]-5-[lblChoosePlan(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblName]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        headerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblChoosePlan]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
    }
}


