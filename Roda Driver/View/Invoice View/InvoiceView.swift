//
//  InvoiceView.swift
//  Taxiappz Driver
//
//  Created by spextrum on 23/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit
import HCSStarRatingView


class InvoiceView: UIView {
    

    let billAmountView = UIView()
    let billAmountLabel = UILabel()
    let billAmountTitleLabel = UILabel()
    
    let continueButton = UIButton()
    
    let waitingForPaymentView = UIView()
    let lblWaitingForPayment = UILabel()
    
    var layoutDict = [String:AnyObject]()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        billAmountView.backgroundColor = .themeColor
        layoutDict["billAmountView"] = billAmountView
        billAmountView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(billAmountView)
        
        billAmountLabel.textColor = .txtColor
        billAmountLabel.textAlignment = .center
        billAmountLabel.font = UIFont.boldSystemFont(ofSize: 40)
        layoutDict["billAmountLabel"] = billAmountLabel
        billAmountLabel.translatesAutoresizingMaskIntoConstraints = false
        billAmountView.addSubview(billAmountLabel)
        
        billAmountTitleLabel.text = "txt_collect_cash".localize()
        billAmountTitleLabel.textColor = .txtColor
        billAmountTitleLabel.textAlignment = .center
        billAmountTitleLabel.font = UIFont.appSemiBold(ofSize: 18)
        layoutDict["billAmountTitleLabel"] = billAmountTitleLabel
        billAmountTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        billAmountView.addSubview(billAmountTitleLabel)
        
        continueButton.setTitle("Txt_Continue".localize().uppercased(), for: .normal)
        continueButton.titleLabel?.font = UIFont.appSemiBold(ofSize: 15)
        continueButton.setTitleColor(.themeTxtColor, for: .normal)
        continueButton.backgroundColor = .themeColor
        continueButton.layer.cornerRadius = 5
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["continueButton"] = continueButton
        baseView.addSubview(continueButton)
        
        waitingForPaymentView.isHidden = true
        waitingForPaymentView.backgroundColor = .secondaryColor
        waitingForPaymentView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["waitingForPaymentView"] = waitingForPaymentView
        baseView.addSubview(waitingForPaymentView)
        
        lblWaitingForPayment.numberOfLines = 0
        lblWaitingForPayment.lineBreakMode = .byWordWrapping
        lblWaitingForPayment.textAlignment = .center
        lblWaitingForPayment.textColor = .txtColor
        lblWaitingForPayment.font = UIFont.appRegularFont(ofSize: 20)
        lblWaitingForPayment.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblWaitingForPayment"] = lblWaitingForPayment
        waitingForPaymentView.addSubview(lblWaitingForPayment)

        billAmountView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor).isActive = true
        billAmountView.bottomAnchor.constraint(equalTo: baseView.centerYAnchor).isActive = true
        
        continueButton.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[continueButton(40)]", options: [], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[billAmountView]|", options: [], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[continueButton]-20-|", options: [], metrics: nil, views: layoutDict))
        
        
        billAmountView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[billAmountLabel]-10-|", options: [], metrics: nil, views: layoutDict))
        
        billAmountView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[billAmountTitleLabel]-10-|", options: [], metrics: nil, views: layoutDict))
        
        billAmountLabel.centerYAnchor.constraint(equalTo: billAmountView.centerYAnchor, constant: -20).isActive = true
        
        billAmountView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[billAmountLabel]-17-[billAmountTitleLabel]", options: [], metrics: nil, views: layoutDict))
        
        
        waitingForPaymentView.bottomAnchor.constraint(equalTo: continueButton.bottomAnchor, constant: 0).isActive = true
        waitingForPaymentView.topAnchor.constraint(equalTo: billAmountView.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[waitingForPaymentView]|", options: [], metrics: nil, views: layoutDict))
        
        
        waitingForPaymentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-32-[lblWaitingForPayment]-32-|", options: [], metrics: nil, views: layoutDict))
        lblWaitingForPayment.centerYAnchor.constraint(equalTo: waitingForPaymentView.centerYAnchor, constant: 0).isActive = true
        
    }
}

/*
class InvoiceView: UIView {

    let scrollview = Myscrollview()
    let containerView = UIView()
    let titleLbl = UILabel()
    let invoiceImgView = UIImageView()
    let pickupaddrlbl = UILabel()
    let dropupaddrlbl = UILabel()
    let separator1 = UIView()

    let driverprofilepicture = UIImageView()
    let dateTimeLbl = UILabel()
    let tripTimeLbl = UILabel()
    let drivernamelbl = UILabel()
    
    let rating = HCSStarRatingView()
    let ratingLbl = UILabel()
    var resIdLbl = UILabel()
    let separator2 = UIView()
    
    let totalFareDisLbl = UILabel()
    let totalamtlbl = UILabel()
    let distancelbl = UILabel()
    
    let billdetailslbl = UILabel()
    
    let separator3 = UIView()
    
    let listBgView = UITableView(frame: .zero, style: .plain)

    let conformBtn = UIButton()
    
    var layoutDict = [String:AnyObject]()
        
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = .secondaryColor
        
        billdetailslbl.text = "text_bill_details".localize()
        
        driverprofilepicture.image = UIImage(named: "historyProfilePlaceholder")

        self.drivernamelbl.textAlignment = APIHelper.appTextAlignment
        self.drivernamelbl.font = UIFont.appSemiBold(ofSize: 16)
        self.tripTimeLbl.font = UIFont.appSemiBold(ofSize: 12)
        self.tripTimeLbl.textAlignment = APIHelper.appTextAlignment
        self.totalFareDisLbl.font = UIFont.appRegularFont(ofSize: 17)
        self.totalamtlbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        self.distancelbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        self.totalamtlbl.font = UIFont.appSemiBold(ofSize: 22)
        self.distancelbl.font = UIFont.appSemiBold(ofSize: 15)
        self.pickupaddrlbl.textAlignment = APIHelper.appTextAlignment
        self.dropupaddrlbl.textAlignment = APIHelper.appTextAlignment
        self.billdetailslbl.textAlignment = APIHelper.appTextAlignment
        self.billdetailslbl.font = UIFont.appSemiBold(ofSize: 17)
        
     
        baseView.addSubview(scrollview)
        self.scrollview.addSubview(containerView)
        
        titleLbl.text = "text_invoice".localize().capitalized
        titleLbl.font = .appSemiBold(ofSize: 30)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDict["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        
        pickupaddrlbl.textColor = .hexToColor("222B45")
        pickupaddrlbl.font = UIFont.appRegularFont(ofSize: 14)
        
        dropupaddrlbl.textColor = .hexToColor("000000")
        dropupaddrlbl.font = UIFont.appRegularFont(ofSize: 14)
        
        invoiceImgView.image = UIImage(named: "historyPickDropSideimg")
        invoiceImgView.contentMode = .scaleAspectFill
        separator1.backgroundColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1)
        separator2.backgroundColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1)
        separator3.backgroundColor = UIColor(red: 0.894, green: 0.914, blue: 0.949, alpha: 1)
        [titleLbl,pickupaddrlbl,dropupaddrlbl,separator1,driverprofilepicture,dateTimeLbl,tripTimeLbl,ratingLbl,separator2,billdetailslbl,listBgView,drivernamelbl,invoiceImgView,totalFareDisLbl,totalamtlbl,distancelbl,rating,conformBtn].forEach { containerView.addSubview($0) }
        
        dateTimeLbl.font = UIFont.appSemiBold(ofSize: 12)
        dateTimeLbl.textColor = .txtColor
        dateTimeLbl.textAlignment = APIHelper.appTextAlignment
        dateTimeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["dateTimeLbl"] = dateTimeLbl
        
        tripTimeLbl.textColor = .txtColor
        tripTimeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["tripTimeLbl"] = tripTimeLbl
        
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
        
       
        
        resIdLbl.font = UIFont.appRegularFont(ofSize: 14)
        resIdLbl.textColor = .themeColor
        resIdLbl.textAlignment = APIHelper.appTextAlignment
        resIdLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["resIdLbl"] = resIdLbl
        containerView.addSubview(resIdLbl)
        
        totalFareDisLbl.text = "txt_your_trip_dis".localize()
        totalFareDisLbl.numberOfLines = 0
        totalFareDisLbl.lineBreakMode = .byWordWrapping
        totalFareDisLbl.textAlignment = APIHelper.appTextAlignment
        totalFareDisLbl.textColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1)
        
        scrollview.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["scrollview"] = scrollview
        containerView.backgroundColor = .secondaryColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["containerView"] = containerView
        
        
        listBgView.alwaysBounceVertical = false
        listBgView.separatorStyle = .none
        listBgView.allowsSelection = false
        listBgView.rowHeight = UITableView.automaticDimension
        listBgView.showsVerticalScrollIndicator = false
        listBgView.backgroundColor = .clear
        listBgView.estimatedRowHeight = 40
        listBgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["listBgView"] = listBgView
        listBgView.reloadData()
        
        driverprofilepicture.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["driverprofilepicture"] = driverprofilepicture
        drivernamelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["drivernamelbl"] = drivernamelbl
        totalFareDisLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["totalFareDisLbl"] = totalFareDisLbl
        //        totalamtlbl.adjustsFontSizeToFitWidth = true
        totalamtlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["totalamtlbl"] = totalamtlbl
        distancelbl.adjustsFontSizeToFitWidth = true
        distancelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["distancelbl"] = distancelbl
        pickupaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["pickupaddrlbl"] = pickupaddrlbl
        dropupaddrlbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["dropupaddrlbl"] = dropupaddrlbl
        separator1.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["separator1"] = separator1
        separator2.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["separator2"] = separator2
        separator3.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["separator3"] = separator3
        invoiceImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["invoiceImgView"] = invoiceImgView
        billdetailslbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["billdetailslbl"] = billdetailslbl
        listBgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["listBgView"] = listBgView
        
        conformBtn.setTitle("txt_confirm".localize().uppercased(), for: .normal)
        conformBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        conformBtn.setTitleColor(.secondaryColor, for: .normal)
        conformBtn.backgroundColor = .themeColor
        conformBtn.layer.cornerRadius = 5
        conformBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["conformBtn"] = conformBtn
        
        scrollview.backgroundColor = .clear
       
        scrollview.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        scrollview.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor).isActive = true
       
       
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|", options: [], metrics: nil, views: layoutDict))
        scrollview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.widthAnchor.constraint(equalTo: baseView.widthAnchor).isActive = true
        let containerViewHgt = containerView.heightAnchor.constraint(equalTo: baseView.heightAnchor)
        containerViewHgt.priority = UILayoutPriority(rawValue: 250)
        containerViewHgt.isActive = true
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[titleLbl(40)]-(20)-[pickupaddrlbl(40)]-(5)-[dropupaddrlbl(40)]-(10)-[separator1(1)]-10-[driverprofilepicture(45)]-(5)-[rating(15)]-(10)-[separator2(1)]-(10)-[totalamtlbl][distancelbl]-(20)-[billdetailslbl(20)]-(10)-[listBgView]-(20)-[conformBtn(50)]-(15)-|", options: [], metrics: nil, views: layoutDict))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[titleLbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))

        invoiceImgView.topAnchor.constraint(equalTo: pickupaddrlbl.centerYAnchor, constant: -3).isActive = true
        invoiceImgView.bottomAnchor.constraint(equalTo: dropupaddrlbl.centerYAnchor, constant: 5).isActive = true
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[invoiceImgView(10)]-(10)-[pickupaddrlbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[invoiceImgView(10)]-(10)-[dropupaddrlbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[separator1]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        drivernamelbl.heightAnchor.constraint(equalToConstant: 20).isActive = true
        dateTimeLbl.heightAnchor.constraint(equalToConstant: 14).isActive = true
        dateTimeLbl.topAnchor.constraint(equalTo: drivernamelbl.topAnchor, constant: -5).isActive = true
        
        tripTimeLbl.heightAnchor.constraint(equalToConstant: 13).isActive = true
        tripTimeLbl.centerYAnchor.constraint(equalTo: resIdLbl.topAnchor, constant: 0).isActive = true
        
      
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[dateTimeLbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[tripTimeLbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))

        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[drivernamelbl(23)]-(2)-[resIdLbl(22)]", options: [], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[driverprofilepicture(45)]-(15)-[drivernamelbl]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop], metrics: nil, views: layoutDict))
       
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[rating(15)]-(5)-[ratingLbl(35)]-(10)-[resIdLbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        ratingLbl.centerYAnchor.constraint(equalTo: rating.centerYAnchor, constant: 0).isActive = true
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[separator2]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[totalFareDisLbl]-(>=8)-[totalamtlbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[distancelbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        totalFareDisLbl.topAnchor.constraint(equalTo: totalamtlbl.topAnchor, constant: 0).isActive = true
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[billdetailslbl]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[listBgView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        listBgView.reloadData() //After Tableviews datasource methods are loaded add height constraint to tableview
        listBgView.layoutIfNeeded()
        let invoiceTblViewHgt = listBgView.heightAnchor.constraint(equalToConstant: listBgView.contentSize.height)
        invoiceTblViewHgt.isActive = true

        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(20)-[conformBtn]-(20)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))

        baseView.layoutIfNeeded()
        baseView.setNeedsLayout()
    }
}
*/

class Myscrollview: UIScrollView {
    override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return point.y > 0
    }
}

class InvoiceCell:UITableViewCell {

    var layoutDict = [String:AnyObject]()
    let stackView = UIStackView()
    let keyValueView = UIView()
    let keyLbl = UILabel()
    let valueLbl = UILabel()
    let noteLbl = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    func setupViews() {

        stackView.alignment = .fill
        stackView.distribution = .equalSpacing
        stackView.spacing = 2
        stackView.axis = .vertical
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["stackView"] = stackView
        addSubview(stackView)

        keyValueView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["keyValueView"] = keyValueView
        stackView.addArrangedSubview(keyValueView)

        keyLbl.numberOfLines = 0
        keyLbl.lineBreakMode = .byWordWrapping
        keyLbl.textAlignment = APIHelper.appTextAlignment
        keyLbl.font = UIFont.appRegularFont(ofSize: 14)
        keyLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["keyLbl"] = keyLbl
        keyValueView.addSubview(keyLbl)

        valueLbl.adjustsFontSizeToFitWidth = true
        valueLbl.minimumScaleFactor = 0.1
        valueLbl.textAlignment = APIHelper.appTextAlignment == .left ? .right : .left
        valueLbl.font = UIFont.appRegularFont(ofSize: 14)
        valueLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["valueLbl"] = valueLbl
        keyValueView.addSubview(valueLbl)

        noteLbl.textAlignment = APIHelper.appTextAlignment
        noteLbl.font = UIFont.appFont(ofSize: 14)
        noteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["noteLbl"] = noteLbl
        stackView.addArrangedSubview(noteLbl)

        let noteLblHeight = noteLbl.heightAnchor.constraint(equalToConstant: 21)
        noteLblHeight.priority = UILayoutPriority.defaultLow
        noteLblHeight.isActive = true

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[stackView]|", options: [], metrics: nil, views: layoutDict))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[stackView]-(15)-|", options: [], metrics: nil, views: layoutDict))
        keyValueView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[keyLbl(>=26)]|", options: [], metrics: nil, views: layoutDict))
        keyValueView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[keyLbl]-(5)-[valueLbl]-(0)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        valueLbl.widthAnchor.constraint(equalTo: keyLbl.widthAnchor, multiplier: 0.3).isActive = true

    }
}
