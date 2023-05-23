//
//  CompanyDetailsView.swift
//  Roda Driver
//
//  Created by Apple on 01/04/22.
//

import UIKit

class CompanyDetailsView: UIView {

    let viewContent = UIView()
    let lblTitle = UILabel()
    let tblCompanyList = UITableView()
    
    private var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.2)
        
        viewContent.backgroundColor = .secondaryColor
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewContent)
        
        lblTitle.text = "txt_choose_company".localize()
        lblTitle.textAlignment = .center
        lblTitle.textColor = .gray
        lblTitle.font = UIFont.appRegularFont(ofSize: 18)
        layoutDict["lblTitle"] = lblTitle
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblTitle)
        
        tblCompanyList.alwaysBounceVertical = false
        layoutDict["tblCompanyList"] = tblCompanyList
        tblCompanyList.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(tblCompanyList)
        
        viewContent.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[viewContent]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tblCompanyList]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblTitle]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[lblTitle(30)]-20-[tblCompanyList]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
    }

}
