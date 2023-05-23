//
//  SelectLanguageView.swift
//  Taxiappz Driver
//
//  Created by spextrum on 20/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit

class SelectLanguageView: UIView {

    let imgView = UIImageView()
    let lblTitle = UILabel()
    let viewLanguage = UIView()
    let lblChooseLanguage = UILabel()
    let tblLanguages = UITableView()
    let btnSetLanguage = UIButton()

    var layoutDict = [String: AnyObject]()
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        imgView.image = UIImage(named: "Logo_Appname")
        imgView.contentMode = .scaleAspectFit
        layoutDict["imgView"] = imgView
        imgView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(imgView)
        
        lblTitle.text = APIHelper.shared.appName?.uppercased()
        lblTitle.textAlignment = .center
        lblTitle.textColor = .txtColor
        lblTitle.font = .appSemiBold(ofSize: 34)
        layoutDict["lblTitle"] = lblTitle
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblTitle)
        
        viewLanguage.backgroundColor = .secondaryColor
        viewLanguage.addShadow()
        viewLanguage.layer.cornerRadius = 10
        layoutDict["viewLanguage"] = viewLanguage
        viewLanguage.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewLanguage)
        
        lblChooseLanguage.textColor = .txtColor
        lblChooseLanguage.font = .appSemiBold(ofSize: 28)
        layoutDict["lblChooseLanguage"] = lblChooseLanguage
        lblChooseLanguage.translatesAutoresizingMaskIntoConstraints = false
        self.viewLanguage.addSubview(lblChooseLanguage)
        
        tblLanguages.alwaysBounceVertical = false
        tblLanguages.allowsMultipleSelection = false
        tblLanguages.showsVerticalScrollIndicator = false
        tblLanguages.register(SelectLanguageCell.self, forCellReuseIdentifier: "languagecell")
        tblLanguages.separatorStyle = .none
        layoutDict["tblLanguages"] = tblLanguages
        tblLanguages.translatesAutoresizingMaskIntoConstraints = false
        self.viewLanguage.addSubview(tblLanguages)
        
        btnSetLanguage.layer.cornerRadius = 5
        btnSetLanguage.titleLabel?.font = .appSemiBold(ofSize: 18)
        btnSetLanguage.setTitleColor(.secondaryColor, for: .normal)
        btnSetLanguage.backgroundColor = .themeColor
        layoutDict["btnSetLanguage"] = btnSetLanguage
        btnSetLanguage.translatesAutoresizingMaskIntoConstraints = false
        self.viewLanguage.addSubview(btnSetLanguage)
        
        
        imgView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        viewLanguage.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[imgView(118)]-10-[lblTitle]-20-[viewLanguage]", options: [], metrics: nil, views: layoutDict))
        imgView.widthAnchor.constraint(equalToConstant: 118).isActive = true
        imgView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblTitle]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewLanguage]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        self.viewLanguage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblChooseLanguage]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.viewLanguage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[tblLanguages]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.viewLanguage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnSetLanguage]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.viewLanguage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[lblChooseLanguage(30)]-10-[tblLanguages]-10-[btnSetLanguage(48)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
    }
}
class SelectLanguageCell: UITableViewCell {
    
    let btnCheck = UIButton()
    let lblLanguage = UILabel()
    let lblIdentifier = UILabel()
    var chooseAction:(()->Void)?
    var layoutDict = [String: AnyObject]()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews() {
        btnCheck.addTarget(self, action: #selector(btnCheckPressed(_ :)), for: .touchUpInside)
        btnCheck.setImage(UIImage(named: "ic_check"), for: .selected)
        btnCheck.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        layoutDict["btnCheck"] = btnCheck
        btnCheck.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(btnCheck)
        
        lblLanguage.textColor = .txtColor
        lblLanguage.font = UIFont.appRegularFont(ofSize: 18)
        layoutDict["lblLanguage"] = lblLanguage
        lblLanguage.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lblLanguage)
        
        lblIdentifier.textColor = .gray
        lblIdentifier.font = UIFont.appRegularFont(ofSize: 18)
        layoutDict["lblIdentifier"] = lblIdentifier
        lblIdentifier.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lblIdentifier)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnCheck(20)]-16-[lblLanguage]-5-[lblIdentifier]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[lblLanguage(30)]-10-|", options: [], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[lblIdentifier(30)]-10-|", options: [], metrics: nil, views: layoutDict))
        btnCheck.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btnCheck.centerYAnchor.constraint(equalTo: lblLanguage.centerYAnchor, constant: 0).isActive = true
    }
    
    @objc func btnCheckPressed(_ sender: UIButton) {
        if let action = self.chooseAction {
            action()
        }
    }
    
}
