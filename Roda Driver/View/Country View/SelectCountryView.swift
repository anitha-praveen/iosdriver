//
//  SelectCountryView.swift
//  Taxiappz Driver
//
//  Created by Realtech Dev Team on 28/07/20.
//  Copyright © 2020 nPlus. All rights reserved.
//

import UIKit

class SelectCountryView: UIView {

    let btnBack = UIButton()
    let lblTitle = UILabel()
    let txtSearch = UITextField()
    let tblCountry = UITableView()
    let countrySearchBar = UISearchBar()
    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView, controller: UIViewController) {
        
        baseView.backgroundColor = .secondaryColor
        
        btnBack.setAppImage("BackImage")
        layoutDict["btnBack"] = btnBack
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnBack)
        
        lblTitle.text = "txt_select_country".localize()
        lblTitle.textColor = .txtColor
        lblTitle.font = UIFont.appSemiBold(ofSize: 40)
        layoutDict["lblTitle"] = lblTitle
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblTitle)
        
        txtSearch.clearButtonMode = .always
        txtSearch.addIcon(UIImage(named: "txtSearch"))
        txtSearch.font = UIFont.appRegularFont(ofSize: 15)
        txtSearch.layer.cornerRadius = 10
        txtSearch.backgroundColor = .hexToColor("EDF1F7")
        txtSearch.placeholder = "text_Search_here".localize()
        layoutDict["txtSearch"] = txtSearch
        txtSearch.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(txtSearch)
        
        tblCountry.alwaysBounceVertical = false
        tblCountry.allowsMultipleSelection = false
        tblCountry.showsVerticalScrollIndicator = false
        tblCountry.separatorStyle = .none
        layoutDict["tblCountry"] = tblCountry
        tblCountry.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(tblCountry)
        
        if #available(iOS 11.0, *) {
            btnBack.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
            tblCountry.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            btnBack.topAnchor.constraint(equalTo: controller.topLayoutGuide.bottomAnchor, constant: 30).isActive = true
            tblCountry.bottomAnchor.constraint(equalTo: controller.bottomLayoutGuide.topAnchor, constant: 0).isActive = true
        }
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnBack(30)]", options: [], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnBack(30)]-20-[lblTitle(45)]-20-[txtSearch(40)]-20-[tblCountry]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblTitle]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[tblCountry]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
         baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[txtSearch]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
                
        layoutIfNeeded()
        setNeedsLayout()
    }
}


import UIKit

class CountryPickerCell: UITableViewCell {
    
    let flagImgView = UIImageView()
    let countryNameLbl = UILabel()
    let isoCodeLbl = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //MARK: - Adding UI Elements

        flagImgView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(flagImgView)
        countryNameLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(countryNameLbl)
        isoCodeLbl.translatesAutoresizingMaskIntoConstraints = false
        addSubview(isoCodeLbl)

        flagImgView.contentMode = .scaleAspectFit
        countryNameLbl.numberOfLines = 0
        countryNameLbl.lineBreakMode = .byWordWrapping
        isoCodeLbl.textColor = .gray
        isoCodeLbl.textAlignment = .right

        isoCodeLbl.setContentCompressionResistancePriority(UILayoutPriority.defaultHigh, for: .horizontal)
        countryNameLbl.setContentCompressionResistancePriority(UILayoutPriority.defaultLow, for: .horizontal)

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(8)-[flagImgView(30)]-(>=8)-|", options: [], metrics: nil, views: ["flagImgView":flagImgView]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(8)-[countryNameLbl(>=30)]-(8)-|", options: [], metrics: nil, views: ["countryNameLbl":countryNameLbl]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(8)-[isoCodeLbl(30)]-(>=8)-|", options: [], metrics: nil, views: ["isoCodeLbl":isoCodeLbl]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[flagImgView(30)]-(5)-[countryNameLbl]-(5)-[isoCodeLbl]-(20)-|", options: [], metrics: nil, views: ["flagImgView":flagImgView,"countryNameLbl":countryNameLbl,"isoCodeLbl":isoCodeLbl]))
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
