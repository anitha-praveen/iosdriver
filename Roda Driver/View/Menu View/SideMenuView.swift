//
//  SideMenuView.swift
//  Taxiappz Driver
//
//  Created by spextrum on 23/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit
import SWRevealViewController

class SideMenuView: UIView {

    let sidemenutopview = UIView()
    let profilepictureiv = UIImageView()
    let profileusernamelbl = UILabel()
    let greetingsLbl = UILabel()
    let menulistTableview = UITableView()

    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView, controller: UIViewController) {
        baseView.backgroundColor = .secondaryColor
        baseView.subviews.forEach({
            $0.removeAllConstraints()
            $0.removeFromSuperview()
        })
       
        sidemenutopview.backgroundColor = .themeColor
        sidemenutopview.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["sidemenutopview"] = sidemenutopview
        baseView.addSubview(sidemenutopview)
        
       // profilepictureiv.contentMode = .scaleAspectFit
        profilepictureiv.layer.masksToBounds = false
        profilepictureiv.layer.cornerRadius = 30
        profilepictureiv.clipsToBounds = true
        profilepictureiv.clipsToBounds = true
        profilepictureiv.backgroundColor = .hexToColor("C4C4C4")
        profilepictureiv.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["profilepictureiv"] = profilepictureiv
        sidemenutopview.addSubview(profilepictureiv)
        
        let nameView = UIView()
        layoutDict["nameView"] = nameView
        nameView.translatesAutoresizingMaskIntoConstraints = false
        sidemenutopview.addSubview(nameView)
        
        profileusernamelbl.textAlignment = APIHelper.appTextAlignment
        profileusernamelbl.adjustsFontSizeToFitWidth = true
        profileusernamelbl.minimumScaleFactor = 0.1
        profileusernamelbl.textColor = .secondaryColor
        profileusernamelbl.font = UIFont.appSemiBold(ofSize: 23)
        profileusernamelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["profileusernamelbl"] = profileusernamelbl
        nameView.addSubview(profileusernamelbl)
        
        greetingsLbl.font = UIFont.appRegularFont(ofSize: 15)
        greetingsLbl.textAlignment = APIHelper.appTextAlignment
        greetingsLbl.textColor = .secondaryColor
        layoutDict["greetingsLbl"] = greetingsLbl
        greetingsLbl.translatesAutoresizingMaskIntoConstraints = false
        nameView.addSubview(greetingsLbl)

        menulistTableview.alwaysBounceVertical = false
        menulistTableview.allowsMultipleSelection = false
        menulistTableview.showsVerticalScrollIndicator = false
        menulistTableview.separatorStyle = .none
        menulistTableview.tableFooterView = UIView()
        menulistTableview.backgroundColor = .secondaryColor
        menulistTableview.register(MenuTableViewCell.self, forCellReuseIdentifier: "menucell")
        menulistTableview.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["menulistTableview"] = menulistTableview
        baseView.addSubview(menulistTableview)


        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[sidemenutopview]-20-[menulistTableview]|", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[menulistTableview(==width)]", options: [APIHelper.appLanguageDirection], metrics: ["width": controller.revealViewController().rearViewRevealWidth], views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[sidemenutopview(==width)]", options: [APIHelper.appLanguageDirection], metrics: ["width": controller.revealViewController().rearViewRevealWidth], views: layoutDict))
        
        sidemenutopview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[profilepictureiv(60)][nameView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        profilepictureiv.heightAnchor.constraint(equalToConstant: 60).isActive = true
        profilepictureiv.centerYAnchor.constraint(equalTo: nameView.centerYAnchor).isActive = true
        nameView.centerYAnchor.constraint(equalTo: sidemenutopview.centerYAnchor).isActive = true
        sidemenutopview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-40-[nameView]-20-|", options: [], metrics: nil, views: layoutDict))
        
        nameView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[profileusernamelbl(30)][greetingsLbl(30)]|", options: [], metrics: nil, views: layoutDict))
        nameView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[profileusernamelbl]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        nameView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[greetingsLbl]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
    }
}
import UIKit

class MenuTableViewCell: UITableViewCell {
    
    var layoutDict = [String:AnyObject]()
    var lblname = UILabel()
    var img = UIImageView()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }
    
    func setUpViews() {
        
        contentView.isUserInteractionEnabled = true
        
        self.subviews.forEach({$0.removeAllConstraints()})
        
        self.selectionStyle = .none
        
        lblname.font = .appSemiBold(ofSize: 17)
        lblname.textColor = .txtColor
        lblname.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblname"] = lblname
        lblname.textAlignment = APIHelper.appTextAlignment
        addSubview(lblname)

        img.tintColor = .txtColor
        img.contentMode = .scaleAspectFit
        img.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["img"] = img
        addSubview(img)

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[img(25)]-(10)-|", options: [], metrics: nil, views: layoutDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[img(25)]-(15)-[lblname]-(15)-|", options: [APIHelper.appLanguageDirection,.alignAllBottom,.alignAllTop], metrics: nil, views: layoutDict))
    }
}
