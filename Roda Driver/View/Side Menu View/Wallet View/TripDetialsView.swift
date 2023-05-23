//
//  TripDetialsView.swift
//  Roda Driver
//
//  Created by NPlus Technologies on 16/05/22.
//

import UIKit
import GoogleMaps
import HCSStarRatingView



class TripDetialsView: UIView {
    
    let backBtn = UIButton()
    let scrollview = Myscrollview()
    let containerView = UIView()
  //  let mapview = GMSMapView()
    let separator1 = UIView()
    
    let pickupaddrlbl = UILabel()
    let dropupaddrlbl = UILabel()
    
    let invoiceImgView = UIImageView()
    let userprofilepicture = UIImageView()
    let dateTimeLbl = UILabel()
    let usernamelbl = UILabel()
    var requestId = UILabel()
    let rating = HCSStarRatingView()
    let ratingLbl = UILabel()
    var carLbl = UILabel()
    let disputeBtn = UIButton()
    let separator2 = UIView()
    
    let totalFareDisLbl = UILabel()
    let totalamtlbl = UILabel()
    let distancelbl = UILabel()
    
    let billdetailslbl = UILabel()
    let listBgView = UITableView(frame: .zero, style: .plain)

    var paymenttypeheaderLbl = UILabel()
    var paymenttypeLbl = UILabel()
    var paymentamtlbl = UILabel()

    var layoutDict = [String: AnyObject]()
    
    var tableHeight: NSLayoutConstraint!

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
             

        backBtn.setAppImage("BackImage")
        backBtn.contentMode = .scaleAspectFit
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        backBtn.backgroundColor = .clear
        layoutDict["backBtn"] = backBtn
        baseView.addSubview(backBtn)
        
        pickupaddrlbl.textColor = .txtColor
        pickupaddrlbl.font = UIFont.appRegularFont(ofSize: 14)
        pickupaddrlbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["pickupaddrlbl"] = pickupaddrlbl
        pickupaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        
        dropupaddrlbl.textColor = .txtColor
        dropupaddrlbl.font = UIFont.appRegularFont(ofSize: 14)
        dropupaddrlbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["dropupaddrlbl"] = dropupaddrlbl
        dropupaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        
        scrollview.bounces = false
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["scrollview"] = scrollview
        baseView.addSubview(scrollview)
    //    baseView.insertSubview(mapview, belowSubview: scrollview)

        containerView.backgroundColor = .secondaryColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["containerView"] = containerView
        scrollview.addSubview(containerView)

//        mapview.translatesAutoresizingMaskIntoConstraints = false
//        layoutDict["mapview"] = mapview
        
        invoiceImgView.image = UIImage(named: "historyPickDropSideimg")
        invoiceImgView.contentMode = .scaleToFill
        invoiceImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["invoiceImgView"] = invoiceImgView
        
        userprofilepicture.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["userprofilepicture"] = userprofilepicture
        
        
        usernamelbl.translatesAutoresizingMaskIntoConstraints = false
        usernamelbl.textAlignment = APIHelper.appTextAlignment
        usernamelbl.font = UIFont.appSemiBold(ofSize: 16)
        layoutDict["usernamelbl"] = usernamelbl
        
        disputeBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["disputeBtn"] = disputeBtn
        
        totalFareDisLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["totalFareDisLbl"] = totalFareDisLbl
        
        totalamtlbl.font = UIFont.appSemiBold(ofSize: 25)
        //        totalamtlbl.adjustsFontSizeToFitWidth = true
        totalamtlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["totalamtlbl"] = totalamtlbl
        
        distancelbl.font = UIFont.appSemiBold(ofSize: 15)
        distancelbl.adjustsFontSizeToFitWidth = true
        distancelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["distancelbl"] = distancelbl

        separator1.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["separator1"] = separator1
        
        separator2.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["separator2"] = separator2
        
        billdetailslbl.text = "text_bill_details".localize()
        billdetailslbl.textAlignment = APIHelper.appTextAlignment
        billdetailslbl.font = UIFont.appSemiBold(ofSize: 17)
        billdetailslbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["billdetailslbl"] = billdetailslbl
                
        dateTimeLbl.font = UIFont.appSemiBold(ofSize: 12)
        dateTimeLbl.textColor = .txtColor
        dateTimeLbl.textAlignment = APIHelper.appTextAlignment
        dateTimeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["dateTimeLbl"] = dateTimeLbl
        
        rating.tintColor = .orange
        rating.isUserInteractionEnabled = false
        rating.minimumValue = 0
        rating.maximumValue = 1
        rating.value = 1
        rating.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["rating"] = rating
        
        ratingLbl.textAlignment = APIHelper.appTextAlignment
        ratingLbl.font = UIFont.appSemiBold(ofSize: 13)
        ratingLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["ratingLbl"] = ratingLbl
        
        requestId.textColor = .themeColor
        requestId.textAlignment = APIHelper.appTextAlignment
        requestId.font = UIFont.appRegularFont(ofSize: 14)
        requestId.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["requestId"] = requestId
        
        carLbl.isHidden = true
        carLbl.font = UIFont.appRegularFont(ofSize: 14)
        carLbl.textColor = .themeColor
        carLbl.textAlignment = APIHelper.appTextAlignment
        carLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["carLbl"] = carLbl
        containerView.addSubview(carLbl)
        
        disputeBtn.setTitle("txt_any_dispute".localize(), for: .normal)
        disputeBtn.titleLabel?.textAlignment = APIHelper.appTextAlignment
        disputeBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 12)
        disputeBtn.backgroundColor = .themeColor
        disputeBtn.setTitleColor(.themeTxtColor, for: .normal)
        disputeBtn.layer.cornerRadius = 2
        disputeBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["disputeBtn"] = disputeBtn
        containerView.addSubview(disputeBtn)
        
        totalFareDisLbl.text = "txt_your_trip_dis".localize()
        totalFareDisLbl.numberOfLines = 0
        totalFareDisLbl.lineBreakMode = .byWordWrapping
        totalFareDisLbl.font = UIFont.appRegularFont(ofSize: 17)
        totalFareDisLbl.textAlignment = APIHelper.appTextAlignment
        totalFareDisLbl.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        

        listBgView.separatorStyle = .none
        listBgView.allowsSelection = false
        listBgView.rowHeight = UITableView.automaticDimension
        listBgView.showsVerticalScrollIndicator = false
        listBgView.backgroundColor = .clear
        listBgView.estimatedRowHeight = 40
        if #available(iOS 11.0, *) {
            listBgView.contentInsetAdjustmentBehavior = .never
        } else {
            // Fallback on earlier versions
        }
        listBgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["listBgView"] = listBgView
        listBgView.reloadData()
        
        
        paymenttypeheaderLbl.text = "txt_Payment".localize()
        paymenttypeheaderLbl.textAlignment = APIHelper.appTextAlignment
        paymenttypeheaderLbl.font = UIFont.appSemiBold(ofSize: 20)
        paymenttypeheaderLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["paymenttypeheaderLbl"] = paymenttypeheaderLbl
        
        paymenttypeLbl.textAlignment = APIHelper.appTextAlignment
        paymenttypeLbl.font = UIFont.appRegularFont(ofSize: 18)
        paymenttypeLbl.textColor = .darkGray
        paymenttypeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["paymenttypeLbl"] = paymenttypeLbl
        
        paymentamtlbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        paymentamtlbl.font = UIFont.appRegularFont(ofSize: 19)
        paymentamtlbl.textColor = .darkGray
        paymentamtlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["paymentamtlbl"] = paymentamtlbl

        separator1.backgroundColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1)
        separator2.backgroundColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1)
        [pickupaddrlbl,dropupaddrlbl,separator1,invoiceImgView,userprofilepicture,usernamelbl,dateTimeLbl,requestId,ratingLbl,separator2,billdetailslbl,listBgView,totalFareDisLbl,totalamtlbl,distancelbl,rating,paymenttypeheaderLbl,paymenttypeLbl,paymentamtlbl].forEach { $0.removeFromSuperview();containerView.addSubview($0) }

        
        containerView.layer.cornerRadius = 5
        containerView.addShadow()
        scrollview.backgroundColor = .clear
        
//        scrollview.contentInset = UIEdgeInsets(top: 160, left: 0, bottom: 0, right: 0)
        scrollview.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 50).isActive = true
     //   mapview.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor).isActive = true
        backBtn.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor , constant: 10).isActive = true
    //    mapview.heightAnchor.constraint(equalToConstant: 160).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        backBtn.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[backBtn(30)]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[scrollview]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|", options: [], metrics: nil, views: layoutDict))
        scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.widthAnchor.constraint(equalTo: baseView.widthAnchor).isActive = true
        let containerViewHgt = containerView.heightAnchor.constraint(equalTo: baseView.heightAnchor)
        containerViewHgt.priority = UILayoutPriority(rawValue: 250)
        containerViewHgt.isActive = true
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[pickupaddrlbl(25)]-(10)-[dropupaddrlbl(25)]-(10)-[separator1(1)]-10-[userprofilepicture(45)]-(5)-[rating(15)]-(10)-[separator2(1)]-(10)-[totalamtlbl(>=45)][distancelbl]-(10)-[billdetailslbl(20)]-(10)-[listBgView]-(10)-[paymenttypeheaderLbl(25)]-(10)-[paymenttypeLbl(20)]-(15)-|", options: [], metrics: nil, views: layoutDict))
//        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        invoiceImgView.topAnchor.constraint(equalTo: pickupaddrlbl.centerYAnchor, constant: -3).isActive = true
        invoiceImgView.bottomAnchor.constraint(equalTo: dropupaddrlbl.centerYAnchor, constant: 5).isActive = true
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[invoiceImgView(10)]-(10)-[pickupaddrlbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[invoiceImgView(10)]-(10)-[dropupaddrlbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[separator1]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        usernamelbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateTimeLbl.heightAnchor.constraint(equalToConstant: 14).isActive = true
        dateTimeLbl.centerYAnchor.constraint(equalTo: usernamelbl.topAnchor, constant: 0).isActive = true
        requestId.topAnchor.constraint(equalTo: usernamelbl.bottomAnchor, constant: 0).isActive = true
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[dateTimeLbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[usernamelbl(23)]-(2)-[requestId(22)]-0-[carLbl(22)]", options: [], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[userprofilepicture(45)]-(15)-[usernamelbl]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[userprofilepicture(45)]-(15)-[requestId]-10-[disputeBtn(80)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[rating(15)]-(5)-[ratingLbl(35)]-(10)-[carLbl]-10-[disputeBtn(80)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        ratingLbl.centerYAnchor.constraint(equalTo: rating.centerYAnchor, constant: 0).isActive = true
        disputeBtn.topAnchor.constraint(equalTo: requestId.centerYAnchor, constant: 0).isActive = true
        disputeBtn.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[separator2]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[totalFareDisLbl]-(>=8)-[totalamtlbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[distancelbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        totalFareDisLbl.topAnchor.constraint(equalTo: totalamtlbl.topAnchor, constant: 0).isActive = true

        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[billdetailslbl]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[listBgView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[paymenttypeheaderLbl]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[paymenttypeLbl(100)]-(20)-[paymentamtlbl]-(20)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        paymenttypeLbl.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        totalamtlbl.textAlignment = APIHelper.appTextAlignment
        distancelbl.textAlignment = APIHelper.appTextAlignment
        
        self.tableHeight = listBgView.heightAnchor.constraint(equalToConstant: 0)
        self.tableHeight.isActive = true
        listBgView.reloadData() //After Tableviews datasource methods are loaded add height constraint to tableview
        listBgView.layoutIfNeeded()

        baseView.bringSubviewToFront(backBtn)
        
    }

}
