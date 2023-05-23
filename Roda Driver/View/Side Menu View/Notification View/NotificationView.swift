//
//  NotificationView.swift
//  Taxiappz Driver
//
//  Created by Apple on 18/05/20.
//  Copyright © 2020 nPlus. All rights reserved.
//

import UIKit

class NotificationView: UIView {
    
    let backBtn = UIButton()

    let titleView = UIView()
    let titleLbl = UILabel()
   
    let tblNotification = UITableView()
    
    var layoutDict = [String: AnyObject]()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView, controller: UIViewController) {
        
        baseView.backgroundColor = .secondaryColor
        
        backBtn.contentMode = .scaleAspectFit
        backBtn.setAppImage("backDark")
        backBtn.layer.cornerRadius = 20
        backBtn.addShadow()
        backBtn.backgroundColor = .secondaryColor
        layoutDict["backBtn"] = backBtn
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(backBtn)
      
        
        titleView.backgroundColor = .secondaryColor
        titleView.layer.cornerRadius = 8
        titleView.addShadow()
        layoutDict["titleView"] = titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(titleView)
        
        titleLbl.text = "txt_noitification".localize()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
        
       
        tblNotification.tableFooterView = UIView()
        tblNotification.backgroundColor = .secondaryColor
        tblNotification.separatorStyle = .none
        layoutDict["tblNotification"] = tblNotification
        tblNotification.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(tblNotification)

        
    
        
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(40)]-15-[titleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        backBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        
        
        tblNotification.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tblNotification]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleView]-20-[tblNotification]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
 
    }
}

class NotificationTableCell: UITableViewCell {
    
    let viewContent = UIView()
    let notificationView = UIView()
    let msgView = UIView()
    let imgview = UIImageView()
    let lblTitle = UILabel()
    let lblMsg = UILabel()
    let lblDate = UILabel()
    
    var layoutDict = [String: AnyObject]()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
  
    func setupViews() {
        
        viewContent.backgroundColor = .secondaryColor
        viewContent.layer.cornerRadius = 10
        viewContent.addShadow(shadowColor: UIColor.themeColor.cgColor, shadowOffset: CGSize(width: 1, height: 1), shadowOpacity: 1, shadowRadius: 2)
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewContent)
        
        lblDate.textColor = .gray
        lblDate.font = UIFont.appSemiBold(ofSize: 14)
        layoutDict["lblDate"] = lblDate
        lblDate.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblDate)
        
        notificationView.backgroundColor = .clear
        layoutDict["notificationView"] = notificationView
        notificationView.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(notificationView)
        
        imgview.layer.cornerRadius = 19
        imgview.clipsToBounds = true
        imgview.contentMode = .scaleAspectFit
        layoutDict["imgview"] = imgview
        imgview.translatesAutoresizingMaskIntoConstraints = false
        notificationView.addSubview(imgview)
        
        msgView.backgroundColor = .clear
        layoutDict["msgView"] = msgView
        msgView.translatesAutoresizingMaskIntoConstraints = false
        notificationView.addSubview(msgView)
        
        lblTitle.textColor = .txtColor
        lblTitle.numberOfLines = 0
        lblTitle.lineBreakMode = .byWordWrapping
        lblTitle.font = UIFont.appBoldFont(ofSize: 18)
        layoutDict["lblTitle"] = lblTitle
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        msgView.addSubview(lblTitle)
        
        lblMsg.numberOfLines = 0
        lblMsg.lineBreakMode = .byWordWrapping
        lblMsg.font = UIFont.appFont(ofSize: 14)
        layoutDict["lblMsg"] = lblMsg
        lblMsg.translatesAutoresizingMaskIntoConstraints = false
        msgView.addSubview(lblMsg)
        
        
        
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[viewContent]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[viewContent]-8-|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[lblDate]-3-[notificationView]-8-|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[lblDate]-9-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[notificationView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        notificationView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[msgView]|", options: [], metrics: nil, views: layoutDict))
        
        notificationView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[imgview(30)]-9-[msgView]-15-|", options: [], metrics: nil, views: layoutDict))
        
        imgview.centerYAnchor.constraint(equalTo: msgView.centerYAnchor).isActive = true
        imgview.heightAnchor.constraint(equalToConstant: 34).isActive = true
        
        msgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[lblTitle]-7-[lblMsg]-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        
        msgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[lblTitle]-|", options: [], metrics: nil, views: layoutDict))
    }
}
