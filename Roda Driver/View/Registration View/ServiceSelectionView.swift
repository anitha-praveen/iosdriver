//
//  ServiceSelectionView.swift
//  Roda Driver
//
//  Created by Apple on 04/04/22.
//

import UIKit

class ServiceSelectionView: UIView {

    private let lblHint = UILabel()
    let tblServiceList = UITableView()
    let btnConfirm = UIButton()
    private var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        lblHint.text = "txt_select_all_services".localize()
        lblHint.numberOfLines = 0
        lblHint.lineBreakMode = .byWordWrapping
        lblHint.textColor = .gray
        lblHint.textAlignment = APIHelper.appTextAlignment
        layoutDict["lblHint"] = lblHint
        lblHint.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lblHint)
        
        tblServiceList.tableFooterView = UIView()
        tblServiceList.alwaysBounceVertical = false
        layoutDict["tblServiceList"] = tblServiceList
        tblServiceList.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(tblServiceList)
        
        btnConfirm.layer.cornerRadius = 5
        btnConfirm.setTitle("txt_confirm".localize(), for: .normal)
        btnConfirm.setTitleColor(.secondaryColor, for: .normal)
        btnConfirm.backgroundColor = .themeColor
        btnConfirm.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        layoutDict["btnConfirm"] = btnConfirm
        btnConfirm.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnConfirm)
        
        lblHint.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
        btnConfirm.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lblHint]-30-[tblServiceList]-20-[btnConfirm(45)]", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblHint]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
    }

}
