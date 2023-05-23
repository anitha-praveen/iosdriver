//
//  CancelListView.swift
//  Taxiappz Driver
//
//  Created by Apple on 02/02/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import UIKit

/*
class CancelListView: UIView {
    
    let viewContent = UIView()
    let titleLbl = UILabel()
    let warnLbl = UILabel()
    let tableView = UITableView()
    let keepBookingBtn = UIButton()
    let cancelBtn = UIButton()
    
    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews(Base baseView: UIView) {
        
        viewContent.backgroundColor = .secondaryColor
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewContent)
        
        [titleLbl,warnLbl,tableView,keepBookingBtn,cancelBtn].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            viewContent.addSubview($0)
        }
        
        titleLbl.text = "txt_cancel_this_ride".localize().uppercased()
        titleLbl.textAlignment = .center
        titleLbl.font = UIFont.appSemiBold(ofSize: 18)
        layoutDict["titleLbl"] = titleLbl
        
        warnLbl.text = "txt_cancel_fee_applied".localize()
        warnLbl.textColor = .themeColor
        warnLbl.textAlignment = .center
        warnLbl.font = UIFont.appRegularFont(ofSize: 18)
        layoutDict["warnLbl"] = warnLbl
        

        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 60
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["tableView"] = tableView
        tableView.reloadData()
        
        keepBookingBtn.setTitle("txt_keep_booking".localize().uppercased(), for: .normal)
        keepBookingBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        keepBookingBtn.setTitleColor(.secondaryColor, for: .normal)
        keepBookingBtn.backgroundColor = .themeColor
        keepBookingBtn.layer.cornerRadius = 5
        keepBookingBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["keepBookingBtn"] = keepBookingBtn
        
        cancelBtn.setTitle("txt_cancel_ride".localize().uppercased(), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        cancelBtn.setTitleColor(.themeColor, for: .normal)
        cancelBtn.backgroundColor = .secondaryColor
        cancelBtn.layer.borderColor = UIColor.themeColor.cgColor
        cancelBtn.layer.borderWidth = 1
        cancelBtn.layer.cornerRadius = 5
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["cancelBtn"] = cancelBtn
        
        //        viewContent.roundCorners(corners: [.topLeft ,.topRight], radius: 15)
        
        viewContent.clipsToBounds = true
        viewContent.layer.cornerRadius = 10
        viewContent.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]

        viewContent.topAnchor.constraint(equalTo: baseView.centerYAnchor, constant: -150).isActive = true
        viewContent.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[titleLbl(25)]-10-[warnLbl(25)]-15-[tableView]-10-[keepBookingBtn(45)]-10-[cancelBtn(45)]-10-|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]-15-|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[warnLbl]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[tableView]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[keepBookingBtn]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[cancelBtn]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.layoutIfNeeded()
        baseView.setNeedsLayout()
        
    }
}
class CancelListCell: UITableViewCell {
    
    var cancelReasonLbl = UILabel()
    var checkMark = UIImageView()
    var lineView = UIView()
    
    var layoutDict = [String: AnyObject]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setUpViews() { // adding ui elements to superview
        
        cancelReasonLbl.textAlignment = APIHelper.appTextAlignment
        cancelReasonLbl.numberOfLines = 0
        cancelReasonLbl.lineBreakMode = .byWordWrapping
        cancelReasonLbl.translatesAutoresizingMaskIntoConstraints = false
        cancelReasonLbl.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["cancelReasonLbl"] = cancelReasonLbl
        self.addSubview(cancelReasonLbl)
        
        checkMark.image = UIImage(named: "uncheckMarked")
        layoutDict["checkMark"] = checkMark
        checkMark.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(checkMark)

        lineView.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        layoutDict["lineView"] = lineView
        lineView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(lineView)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[cancelReasonLbl]-8-[lineView(1)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[cancelReasonLbl]-10-[checkMark(16)]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[lineView]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        checkMark.centerYAnchor.constraint(equalTo: cancelReasonLbl.centerYAnchor, constant: 0).isActive = true
        checkMark.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
    }

}
*/
class CancelListView: UIView {

    let viewContent = UIView()
    let titleLbl = UILabel()
    let warnLbl = UILabel()
    let tableView = UITableView()
    let keepBookingBtn = UIButton()
    let cancelBtn = UIButton()
    
    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setupViews(Base baseView: UIView) {
        
        viewContent.clipsToBounds = true
        viewContent.layer.cornerRadius = 30
        viewContent.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        viewContent.backgroundColor = .secondaryColor
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewContent)
        
        [titleLbl,warnLbl,tableView,keepBookingBtn,cancelBtn].forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            viewContent.addSubview($0)
        }
        
        titleLbl.text = "txt_cancel_this_ride".localize().uppercased()
        titleLbl.textAlignment = APIHelper.appTextAlignment
        titleLbl.font = UIFont.appSemiBold(ofSize: 18)
        layoutDict["titleLbl"] = titleLbl
        
        warnLbl.text = "txt_cancel_fee_applied".localize()
        warnLbl.textColor = .hexToColor("606060")
        warnLbl.textAlignment = APIHelper.appTextAlignment
        warnLbl.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["warnLbl"] = warnLbl
        
        
        tableView.alwaysBounceVertical = false
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["tableView"] = tableView
        tableView.reloadData()
        
        keepBookingBtn.setTitle("text_no".localize().uppercased(), for: .normal)
        keepBookingBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        keepBookingBtn.setTitleColor(.txtColor, for: .normal)
        keepBookingBtn.backgroundColor = .hexToColor("D9D9D9")
        keepBookingBtn.layer.cornerRadius = 8
        keepBookingBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["keepBookingBtn"] = keepBookingBtn
        
        cancelBtn.setTitle("text_yes".localize().uppercased(), for: .normal)
        cancelBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        cancelBtn.setTitleColor(.themeTxtColor, for: .normal)
        cancelBtn.backgroundColor = .themeColor
        cancelBtn.layer.cornerRadius = 8
        cancelBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["cancelBtn"] = cancelBtn
        
      
        
       // viewContent.topAnchor.constraint(equalTo: baseView.centerYAnchor, constant: -150).isActive = true
        viewContent.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[titleLbl(25)]-5-[warnLbl(25)]-15-[tableView]-10-[cancelBtn(45)]-10-|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]-15-|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[warnLbl]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[tableView]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[keepBookingBtn]-10-[cancelBtn(==keepBookingBtn)]-10-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
       
        
        baseView.layoutIfNeeded()
        baseView.setNeedsLayout()
        
    }
}


class CancelListCell: UITableViewCell {
    
    let viewContent = UIView()
    var cancelReasonLbl = UILabel()
    var checkMark = UIImageView()
    var lineView = UIView()
    
    var layoutDict = [String: AnyObject]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    func setUpViews() { // adding ui elements to superview
        
        contentView.isUserInteractionEnabled = true
        
        viewContent.layer.cornerRadius = 5
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewContent)
        
        cancelReasonLbl.textAlignment = APIHelper.appTextAlignment
        cancelReasonLbl.numberOfLines = 0
        cancelReasonLbl.lineBreakMode = .byWordWrapping
        cancelReasonLbl.translatesAutoresizingMaskIntoConstraints = false
        cancelReasonLbl.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["cancelReasonLbl"] = cancelReasonLbl
        viewContent.addSubview(cancelReasonLbl)
        
        checkMark.image = UIImage(named: "ic_uncheck")
        layoutDict["checkMark"] = checkMark
        checkMark.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(checkMark)

        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[viewContent]-8-|", options: [], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[viewContent]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[cancelReasonLbl(>=30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[cancelReasonLbl]-10-[checkMark(16)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        checkMark.centerYAnchor.constraint(equalTo: cancelReasonLbl.centerYAnchor, constant: 0).isActive = true
        checkMark.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
    }

}
