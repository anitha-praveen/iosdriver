//
//  HistoryView.swift
//  Taxiappz Driver
//
//  Created by spextrum on 23/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit

class HistoryView: UIView {
    
    let backBtn = UIButton()

    let titleView = UIView()
    let titleLbl = UILabel()
    
    let segmentedControl = UISegmentedControl(items: ["txt_completed".localize().uppercased(),"txt_cancelled".localize().uppercased()])


    let historytbv = UITableView()
    
    let imgNoRides = UIImageView()
    let lblNoRides = UILabel()

    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
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
        
        titleLbl.text = "txt_my_rides".localize()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
        
        segmentedControl.layer.cornerRadius = 20
        segmentedControl.layer.masksToBounds = true
        segmentedControl.layer.borderColor = UIColor.themeColor.cgColor
        segmentedControl.layer.borderWidth = 1.0
        segmentedControl.tintColor = .themeColor
        segmentedControl.backgroundColor = .secondaryColor
        segmentedControl.selectedSegmentIndex = 0
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["segmentedControl"] = segmentedControl
        baseView.addSubview(segmentedControl)
        
        
        
        imgNoRides.isHidden = true
        imgNoRides.image = UIImage(named: "img_norides")
        imgNoRides.contentMode = .scaleAspectFit
        imgNoRides.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["imgNoRides"] = imgNoRides
        baseView.addSubview(imgNoRides)
        
        lblNoRides.isHidden = true
        lblNoRides.numberOfLines = 0
        lblNoRides.lineBreakMode = .byWordWrapping
        lblNoRides.text = "txt_no_records".localize() + "\n" + "txt_make_history".localize()
        lblNoRides.textAlignment = .center
        lblNoRides.font = UIFont.appBoldFont(ofSize: 20)
        lblNoRides.textColor = .hexToColor("555555")
        lblNoRides.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblNoRides"] = lblNoRides
        baseView.addSubview(lblNoRides)
        
        historytbv.alwaysBounceVertical = false
        historytbv.showsVerticalScrollIndicator = false
        historytbv.tableFooterView = UIView()
        historytbv.separatorStyle = .none
        historytbv.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["historytbv"] = historytbv
        baseView.addSubview(historytbv)
        
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(40)]-15-[titleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        backBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        
        
        historytbv.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleView]-20-[segmentedControl(40)]-10-[historytbv]", options: [], metrics: nil, views: layoutDict))
        
       
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[segmentedControl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
       
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[historytbv]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        imgNoRides.widthAnchor.constraint(equalToConstant: 180).isActive = true
        imgNoRides.heightAnchor.constraint(equalToConstant: 158).isActive = true
        imgNoRides.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 0).isActive = true
        imgNoRides.centerYAnchor.constraint(equalTo: baseView.centerYAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[imgNoRides]-10-[lblNoRides]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[lblNoRides]-40-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
    }
}

class HistoryTableViewCell: UITableViewCell {
    
    let viewDate = UIView()
    let lblDate = UILabel()
    let lblTime = UILabel()
    let lblRideType = UILabel()

    var viewContent = UIView()
    var tripreqidlbl = UILabel()
    var nameLbl = UILabel()
    var tripcostlbl = UILabel()
    var fromaddrlbl = UILabel()
    var invoiceImgView = UIImageView()
    var toaddrlbl = UILabel()
    var driverimageIv = UIImageView()
    
    
    let stackvw = UIStackView()
    let btnDispute = UIButton()
    let viewCancelReason = UIView()
    let lblCancelReason = UILabel()
    
    let dummyBtn = UIButton()
    
    var disputeAction:(()->Void)?

    var layoutDic = [String:AnyObject]()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setUpViews()
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       
    }
  
    func setUpViews() {
        
        self.contentView.isUserInteractionEnabled = true
        self.selectionStyle = .none
        
        viewDate.layer.cornerRadius = 10
        viewDate.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewDate.backgroundColor = .hexToColor("#48CB90")
        viewDate.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["viewDate"] = viewDate
        self.addSubview(viewDate)
        
        lblDate.textColor = .txtColor
        lblDate.textAlignment = APIHelper.appTextAlignment
        lblDate.font = UIFont.appMediumFont(ofSize: 14)
        lblDate.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblDate"] = lblDate
        viewDate.addSubview(lblDate)
        
        lblTime.textColor = .txtColor
        lblTime.textAlignment = APIHelper.appTextAlignment
        lblTime.font = UIFont.appMediumFont(ofSize: 14)
        lblTime.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblTime"] = lblTime
        viewDate.addSubview(lblTime)
        
        lblRideType.textColor = .txtColor
        lblRideType.textAlignment = .center
        lblRideType.font = UIFont.appMediumFont(ofSize: 14)
        lblRideType.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblRideType"] = lblRideType
        viewDate.addSubview(lblRideType)
        
        viewContent.isUserInteractionEnabled = true
        viewContent.layer.cornerRadius = 8
        viewContent.addShadow()
        viewContent.backgroundColor = .secondaryColor
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["viewContent"] = viewContent
        self.addSubview(viewContent)
        
        
        tripreqidlbl.textAlignment = APIHelper.appTextAlignment
        tripreqidlbl.font = UIFont.appRegularFont(ofSize: 13)
        tripreqidlbl.textColor = .themeColor
        tripreqidlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["tripreqidlbl"] = tripreqidlbl
        viewContent.addSubview(tripreqidlbl)
        
        nameLbl.textAlignment = APIHelper.appTextAlignment
        nameLbl.font = UIFont.appRegularFont(ofSize: 13)
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["nameLbl"] = nameLbl
        viewContent.addSubview(nameLbl)
        
        tripcostlbl.textAlignment = APIHelper.appTextAlignment
        tripcostlbl.font = UIFont.appSemiBold(ofSize: 16)
        tripcostlbl.textColor = UIColor(red: 0.008, green: 0.49, blue: 0.38, alpha: 1)
        tripcostlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["tripcostlbl"] = tripcostlbl
        viewContent.addSubview(tripcostlbl)
        
        fromaddrlbl.textColor = .txtColor
        fromaddrlbl.textAlignment = APIHelper.appTextAlignment
        fromaddrlbl.font = UIFont.appRegularFont(ofSize: 13)
        fromaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["fromaddrlbl"] = fromaddrlbl
        viewContent.addSubview(fromaddrlbl)
        
        invoiceImgView.image = UIImage(named: "historyPickDropSideimg")
        invoiceImgView.contentMode = .scaleAspectFit
        invoiceImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["invoiceImgView"] = invoiceImgView
        viewContent.addSubview(invoiceImgView)
        
     
        
        toaddrlbl.textColor = .txtColor
        toaddrlbl.textAlignment = APIHelper.appTextAlignment
        toaddrlbl.font = UIFont.appRegularFont(ofSize: 13)
        toaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["toaddrlbl"] = toaddrlbl
        viewContent.addSubview(toaddrlbl)
        
        //driverimageIv.contentMode = .scaleAspectFit
        driverimageIv.layer.cornerRadius = 10
        driverimageIv.clipsToBounds = true
        driverimageIv.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["driverimageIv"] = driverimageIv
        viewContent.addSubview(driverimageIv)
        
        stackvw.axis = .vertical
        stackvw.distribution = .fill
        stackvw.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["stackvw"] = stackvw
        viewContent.addSubview(stackvw)
        
        btnDispute.isHidden = true
        bringSubviewToFront(btnDispute)
        btnDispute.addTarget(self, action: #selector(btnDisputePressed(_ :)), for: .touchUpInside)
        btnDispute.layer.cornerRadius = 8
        btnDispute.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        btnDispute.setTitle("txt_any_dispute".localize(), for: .normal)
        btnDispute.setTitleColor(.secondaryColor, for: .normal)
        btnDispute.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnDispute.backgroundColor = .hexToColor("#E76565")
        layoutDic["btnDispute"] = btnDispute
        btnDispute.translatesAutoresizingMaskIntoConstraints = false
        stackvw.addArrangedSubview(btnDispute)
        
        viewCancelReason.isHidden = true
        viewCancelReason.addBorder(edges: .top,colour: .hexToColor("DADADA"),thickness: 0.5)
        viewCancelReason.layer.cornerRadius = 8
        viewCancelReason.layer.maskedCorners = [.layerMinXMaxYCorner,.layerMaxXMaxYCorner]
        layoutDic["viewCancelReason"] = viewCancelReason
        viewCancelReason.translatesAutoresizingMaskIntoConstraints = false
        stackvw.addArrangedSubview(viewCancelReason)
        
        lblCancelReason.textColor = .hexToColor("#E76565")
        lblCancelReason.textAlignment = .center
        lblCancelReason.font = UIFont.appRegularFont(ofSize: 14)
        layoutDic["lblCancelReason"] = lblCancelReason
        lblCancelReason.translatesAutoresizingMaskIntoConstraints = false
        viewCancelReason.addSubview(lblCancelReason)
    
    
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[viewDate][viewContent]-8-|", options: [], metrics: nil, views: layoutDic))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[viewContent]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[viewDate]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        
        viewDate.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[lblDate]-5-[lblRideType]-5-[lblTime]-10-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        viewDate.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblDate(30)]|", options: [], metrics: nil, views: layoutDic))
        lblDate.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        lblTime.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
       
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[driverimageIv(50)]", options: [], metrics: nil, views: layoutDic))

        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-11-[nameLbl(25)]-3-[tripreqidlbl(25)]-8-[fromaddrlbl(30)][toaddrlbl(30)]-8-[stackvw]|", options: [], metrics: nil, views: layoutDic))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(15)-[tripcostlbl(30)]", options: [], metrics: nil, views: layoutDic))
        
        tripcostlbl.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[driverimageIv(50)]-(10)-[nameLbl]-5-[tripcostlbl]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[driverimageIv]-(10)-[tripreqidlbl]-5-[tripcostlbl]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[invoiceImgView(30)]-(10)-[fromaddrlbl]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[invoiceImgView]-(10)-[toaddrlbl]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackvw]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
       
        invoiceImgView.topAnchor.constraint(equalTo: fromaddrlbl.centerYAnchor , constant: -5).isActive = true
        invoiceImgView.bottomAnchor.constraint(equalTo: toaddrlbl.centerYAnchor, constant: 5).isActive = true
        
        
        
        btnDispute.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        viewCancelReason.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblCancelReason]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewCancelReason.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblCancelReason(30)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
       
    }
    
    @objc func btnDisputePressed(_ sender: UIButton) {
       
        if let action = self.disputeAction {
            action()
        }
    }
    
 
}
