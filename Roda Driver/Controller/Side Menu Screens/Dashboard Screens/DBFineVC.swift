//
//  DBFineVC.swift
//  Captain Car
//
//  Created by NPlus Technologies on 18/07/19.
//  Copyright © 2019 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class DBFineVC: UIViewController {
    
    let stackview = UIStackView()
    
    let finesView = UIView()
    let finesLbl = UILabel()
    let finesAmtLbl = UILabel()
    let totalFinesLbl = UILabel()
    let finesReasonLbl = UILabel()
    
    let headerLbl = UILabel()
    
    let cancellationView = UIView()
    let cancelHeaderLbl = UILabel()
    let captainView = UIView()
    let customerView = UIView()
    let netView = UIView()

    let captainLbl = UILabel()
    let captainAmtLbl = UILabel()
    let btnArrowCaptain = UIButton()
    
    let customerLbl = UILabel()
    let customerAmtLbl = UILabel()
    let btnArrowcustomer = UIButton()
    
    let netLbl = UILabel()
    let netAmtLbl = UILabel()
    let btnArrowNet = UIButton()
    
    let bonusView = UIView()
    let bonusLbl = UILabel()
    let bonusAmtLbl = UILabel()
    let bonusReasonLbl = UILabel()
    
    let netProfitView = UIView()
    let netProfitLbl = UILabel()
    let netProfitAmtLbl = UILabel()
    let netProfitReasonLbl = UILabel()

    var currency = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(handleMassage),name: Notification.Name("dashboardData"),object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("dashboardData"), object: nil)
    }
    
    @objc func handleMassage(notification: NSNotification) {
        if let notificationData = notification.object as? [String: AnyObject] {
            self.setupData(notificationData)
        }
    }
    
    func setupData(_ dict: [String: AnyObject]) {
        if let currency = dict["currency"] as? String {
            self.currency = currency
        }
        if let cancelDriverFee = dict["cancellation_fee_amount"], let cancelDriverAmt = Double("\(cancelDriverFee)") {
            self.captainAmtLbl.text = String(format: "%@ %0.2f", self.currency, cancelDriverAmt)
        }
        if let cancelEarnFee = dict["cancellation_earn_amount"], let cancelUserAmt = Double("\(cancelEarnFee)") {
            self.customerAmtLbl.text = String(format: "%@ %0.2f", self.currency, cancelUserAmt)
        }
        if let netAmtFee = dict["balance_cancellation_amount"], let netAmt = Double("\(netAmtFee)") {
            self.netAmtLbl.text = String(format: "%@ %0.2f", self.currency, netAmt)
        }
        if let fineAmtFee = dict["fine_amount"], let fineAmt = Double("\(fineAmtFee)") {
            self.finesAmtLbl.text = String(format: "%@ %0.2f", self.currency, fineAmt)
        }
//        if let fineReason = dict["description"] as? String {
//            self.finesReasonLbl.text = fineReason
//        }
        
    }
    // MARK: Adding new UI Elements in setupViews
    func setupViews() {
        self.view.backgroundColor = .hexToColor("F2F2F2")
        var layoutDic = [String: Any]()
        
        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        layoutDic["scrollView"] = scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["contentView"] = contentView
        scrollView.addSubview(contentView)
        
        stackview.axis = .vertical
        stackview.spacing = 12
        stackview.distribution = .fill
        stackview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["stackview"] = stackview
        contentView.addSubview(stackview)
        
        finesView.backgroundColor = .secondaryColor
        finesView.addShadow()
        finesView.layer.cornerRadius = 5.0
        finesView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["finesView"] = finesView
        stackview.addArrangedSubview(finesView)
        
        finesLbl.text = "txt_fines".localize()
        finesLbl.textColor = UIColor.txtColor//.withAlphaComponent(0.7)
        finesLbl.font = UIFont.appFont(ofSize: 16)
        finesLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["finesLbl"] = finesLbl
        finesView.addSubview(finesLbl)
        
        finesAmtLbl.textColor = .blue
        finesAmtLbl.font = UIFont.appFont(ofSize: 16)
        finesAmtLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["finesAmtLbl"] = finesAmtLbl
        finesView.addSubview(finesAmtLbl)
        
//        totalFinesLbl.isHidden = true
        totalFinesLbl.textAlignment = APIHelper.appTextAlignment
        totalFinesLbl.textColor = .txtColor
        totalFinesLbl.font = UIFont.appFont(ofSize: 12)
        totalFinesLbl.text = "txt_total_fines".localize()
        totalFinesLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["totalFinesLbl"] = totalFinesLbl
        finesView.addSubview(totalFinesLbl)
        
        finesReasonLbl.textColor = UIColor.txtColor.withAlphaComponent(0.7)
        finesReasonLbl.font = UIFont.appFont(ofSize: 14)
        finesReasonLbl.numberOfLines = 0
        finesReasonLbl.lineBreakMode = .byWordWrapping
        finesReasonLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["finesReasonLbl"] = finesReasonLbl
        finesView.addSubview(finesReasonLbl)
        
        headerLbl.text = "txt_cancel_Desc_Fines".localize()
        headerLbl.textColor = .txtColor
        headerLbl.numberOfLines = 0
        headerLbl.font = UIFont.appRegularFont(ofSize: 15)
        headerLbl.lineBreakMode = .byWordWrapping
        headerLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["headerLbl"] = headerLbl
        stackview.addArrangedSubview(headerLbl)
        
        cancellationView.backgroundColor = .secondaryColor
        cancellationView.layer.cornerRadius = 0.0
        cancellationView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cancellationView"] = cancellationView
        stackview.addArrangedSubview(cancellationView)
        
        cancelHeaderLbl.text = "text_cancellation_balance".localize().uppercased()
        cancelHeaderLbl.textColor = UIColor.txtColor
        cancelHeaderLbl.font = UIFont.appMediumFont(ofSize: 15)
        cancelHeaderLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cancelHeaderLbl"] = cancelHeaderLbl
        cancellationView.addSubview(cancelHeaderLbl)
        
        let cancelStackview = UIStackView()
        cancelStackview.axis = .horizontal
        cancelStackview.spacing = 8
        cancelStackview.distribution = .fillEqually
        cancelStackview.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cancelStackview"] = cancelStackview
        cancellationView.addSubview(cancelStackview)
        
     /*   captainView.backgroundColor = .secondaryColor
        captainView.addBorder(edges: .bottom, colour: .hexToColor("FB4A46"), thickness: 3.0)
        captainView.addShadow()
        captainView.layer.cornerRadius = 5.0
        captainView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["captainView"] = captainView
        cancelStackview.addArrangedSubview(captainView)
        
        customerView.backgroundColor = .secondaryColor
        customerView.addBorder(edges: .bottom, colour: .hexToColor("00AE73"), thickness: 3.0)
        customerView.addShadow()
        customerView.layer.cornerRadius = 5.0
        customerView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["customerView"] = customerView
        cancelStackview.addArrangedSubview(customerView) */
        
        netView.backgroundColor = .secondaryColor
        netView.addBorder(edges: .bottom, colour: .hexToColor("5497FF"), thickness: 3.0)
        netView.addShadow()
        netView.layer.cornerRadius = 5.0
        netView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["netView"] = netView
        cancelStackview.addArrangedSubview(netView)
        
        captainLbl.text = "txt_driver".localize()
        captainLbl.textColor = UIColor.txtColor
        captainLbl.textAlignment = .center
        captainLbl.font = UIFont.appMediumFont(ofSize: 13)
        captainLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["captainLbl"] = captainLbl
        captainView.addSubview(captainLbl)
        
        captainAmtLbl.textAlignment = .center
        captainAmtLbl.textColor = .txtColor
        captainAmtLbl.font = UIFont.appMediumFont(ofSize: 15)
        captainAmtLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["captainAmtLbl"] = captainAmtLbl
        captainView.addSubview(captainAmtLbl)
        
        btnArrowCaptain.setImage(UIImage(named: "ic_dash_driver"), for: .normal)
        btnArrowCaptain.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["btnArrowCaptain"] = btnArrowCaptain
        captainView.addSubview(btnArrowCaptain)
        
        let captainBalanceTitle = UILabel()
        captainBalanceTitle.textAlignment = .center
        captainBalanceTitle.text = "txt_balance_small".localize()
        captainBalanceTitle.textColor = .hexToColor("979797")
        captainBalanceTitle.font = UIFont.appMediumFont(ofSize: 12)
        captainBalanceTitle.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["captainBalanceTitle"] = captainBalanceTitle
        captainView.addSubview(captainBalanceTitle)
        
        customerLbl.textAlignment = .center
        customerLbl.text = "text_customer".localize()
        customerLbl.textColor = UIColor.txtColor
        customerLbl.font = UIFont.appMediumFont(ofSize: 13)
        customerLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["customerLbl"] = customerLbl
        customerView.addSubview(customerLbl)
        
        customerAmtLbl.textAlignment = .center
        customerAmtLbl.textColor = UIColor.txtColor
        customerAmtLbl.font = UIFont.appMediumFont(ofSize: 15)
        customerAmtLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["customerAmtLbl"] = customerAmtLbl
        customerView.addSubview(customerAmtLbl)
        
        btnArrowcustomer.setImage(UIImage(named: "ic_dash_customer"), for: .normal)
        btnArrowcustomer.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["btnArrowcustomer"] = btnArrowcustomer
        customerView.addSubview(btnArrowcustomer)
        
        let customerBalanceTitle = UILabel()
        customerBalanceTitle.textAlignment = .center
        customerBalanceTitle.text = "txt_balance_small".localize()
        customerBalanceTitle.textColor = .hexToColor("979797")
        customerBalanceTitle.font = UIFont.appMediumFont(ofSize: 12)
        customerBalanceTitle.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["customerBalanceTitle"] = customerBalanceTitle
        customerView.addSubview(customerBalanceTitle)

        netLbl.textAlignment = .center
        netLbl.text = "txt_net".localize()
        netLbl.textColor = UIColor.txtColor
        netLbl.font = UIFont.appMediumFont(ofSize: 13)
        netLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["netLbl"] = netLbl
        netView.addSubview(netLbl)
        
        netAmtLbl.textAlignment = .center
        netAmtLbl.textColor = .txtColor
        netAmtLbl.font = UIFont.appMediumFont(ofSize: 15)
        netAmtLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["netAmtLbl"] = netAmtLbl
        netView.addSubview(netAmtLbl)
        
        btnArrowNet.setImage(UIImage(named: "ic_dash_wallet"), for: .normal)
        btnArrowNet.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["btnArrowNet"] = btnArrowNet
        netView.addSubview(btnArrowNet)
        
        let netBalanceTitle = UILabel()
        netBalanceTitle.textAlignment = .center
        netBalanceTitle.text = "txt_net_bal".localize()
        netBalanceTitle.textColor = .txtColor //.hexToColor("979797")
        netBalanceTitle.font = UIFont.appMediumFont(ofSize: 12)
        netBalanceTitle.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["netBalanceTitle"] = netBalanceTitle
        netView.addSubview(netBalanceTitle)
        
        bonusView.isHidden = true
        bonusView.addBorder(edges: .bottom,colour: .turquoise,thickness: 2)
        bonusView.backgroundColor = .secondaryColor
        bonusView.addShadow()
        bonusView.layer.cornerRadius = 5.0
        bonusView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["bonusView"] = bonusView
       // stackview.addArrangedSubview(bonusView)
        
        bonusLbl.text = "txt_bonus".localize().uppercased()
        bonusLbl.textColor = UIColor.txtColor.withAlphaComponent(0.7)
        bonusLbl.font = UIFont.appFont(ofSize: 14)
        bonusLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["bonusLbl"] = bonusLbl
        bonusView.addSubview(bonusLbl)
        
        bonusAmtLbl.textColor = .turquoise
        bonusAmtLbl.font = UIFont.appFont(ofSize: 14)
        bonusAmtLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["bonusAmtLbl"] = bonusAmtLbl
        bonusView.addSubview(bonusAmtLbl)
        
        bonusReasonLbl.textColor = UIColor.txtColor.withAlphaComponent(0.7)
        bonusReasonLbl.font = UIFont.appFont(ofSize: 14)
        bonusReasonLbl.numberOfLines = 0
        bonusReasonLbl.lineBreakMode = .byWordWrapping
        bonusReasonLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["bonusReasonLbl"] = bonusReasonLbl
        bonusView.addSubview(bonusReasonLbl)
        
        let bonusTotalTitleLbl = UILabel()
        bonusTotalTitleLbl.adjustsFontSizeToFitWidth = true
        bonusTotalTitleLbl.minimumScaleFactor = 0.2
        bonusTotalTitleLbl.text = "total_of_bonus".localize()
        bonusTotalTitleLbl.textColor = .gray
        bonusTotalTitleLbl.font = UIFont.appFont(ofSize: 12)
        bonusTotalTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["bonusTotalTitleLbl"] = bonusTotalTitleLbl
        bonusView.addSubview(bonusTotalTitleLbl)
        
        netProfitView.isHidden = true
       // netProfitView.addBorder(edges: .bottom,colour: .red,thickness: 2)
        netProfitView.backgroundColor = .secondaryColor
        netProfitView.addShadow()
        netProfitView.layer.cornerRadius = 5.0
        netProfitView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["netProfitView"] = netProfitView
       // stackview.addArrangedSubview(netProfitView)
        
        netProfitLbl.text = "txt_net_profit".localize().uppercased()
        netProfitLbl.textColor = UIColor.txtColor
        netProfitLbl.font = UIFont.appMediumFont(ofSize: 12)
        netProfitLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["netProfitLbl"] = netProfitLbl
        netProfitView.addSubview(netProfitLbl)
        
        netProfitAmtLbl.textColor = .hexToColor("FB4A46")
        netProfitAmtLbl.font = UIFont.appMediumFont(ofSize: 18)
        netProfitAmtLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["netProfitAmtLbl"] = netProfitAmtLbl
        netProfitView.addSubview(netProfitAmtLbl)
        
        netProfitReasonLbl.text = "net_amt_desc".localize()
        netProfitReasonLbl.textColor = UIColor.txtColor
        netProfitReasonLbl.font = UIFont.appRegularFont(ofSize: 15)
        netProfitReasonLbl.numberOfLines = 0
        netProfitReasonLbl.lineBreakMode = .byWordWrapping
        netProfitReasonLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["netProfitReasonLbl"] = netProfitReasonLbl
        netProfitView.addSubview(netProfitReasonLbl)
        
        let netProfitTotalTitleLbl = UILabel()
        netProfitTotalTitleLbl.text = "net_amnt".localize()
        netProfitTotalTitleLbl.textColor = .hexToColor("979797")
        netProfitTotalTitleLbl.font = UIFont.appMediumFont(ofSize: 12)
        netProfitTotalTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["netProfitTotalTitleLbl"] = netProfitTotalTitleLbl
        netProfitView.addSubview(netProfitTotalTitleLbl)
        
        let netProfitSeparator = UIView()
        netProfitSeparator.backgroundColor = .hexToColor("979797")
        netProfitSeparator.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["netProfitSeparator"] = netProfitSeparator
        netProfitView.addSubview(netProfitSeparator)
        
        
        // MARK:Adding UI constraints
       
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
       
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[scrollView]-(0)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView]|", options: [], metrics: nil, views: layoutDic))
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let height = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        height.priority = .defaultLow
        height.isActive = true
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[stackview]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[stackview]-10-|", options: [], metrics: nil, views: layoutDic))
        
        finesView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[finesAmtLbl]-(16)-[finesReasonLbl]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        finesView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[finesLbl]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        finesView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[finesLbl(25)]-5-[finesAmtLbl(20)][totalFinesLbl(20)]", options: [], metrics: nil, views: layoutDic))
        finesView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[finesReasonLbl(>=75)]-(10)-|", options: [], metrics: nil, views: layoutDic))
        finesReasonLbl.centerYAnchor.constraint(equalTo: finesAmtLbl.centerYAnchor).isActive = true
        finesReasonLbl.widthAnchor.constraint(equalTo: finesView.widthAnchor, multiplier: 0.7).isActive = true
        
        finesView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[totalFinesLbl]-(10)-[finesReasonLbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))

        
        cancellationView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[cancelHeaderLbl]-(10)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
         cancellationView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[cancelStackview]-(8)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        cancellationView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(15)-[cancelHeaderLbl(25)]-10-[cancelStackview]-10-|", options: [], metrics: nil, views: layoutDic))
        
        captainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[captainLbl(25)]-5-[btnArrowCaptain(24)]-5-[captainAmtLbl(30)][captainBalanceTitle(15)]-10-|", options: [], metrics: nil, views: layoutDic))
        captainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[captainLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        captainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[captainBalanceTitle]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        captainView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[captainAmtLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        btnArrowCaptain.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btnArrowCaptain.centerXAnchor.constraint(equalTo: captainView.centerXAnchor, constant: 0).isActive = true
        
        
        customerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[customerLbl(25)]-5-[btnArrowcustomer(26)]-5-[customerAmtLbl(25)][customerBalanceTitle(15)]-10-|", options: [], metrics: nil, views: layoutDic))
        customerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[customerLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        customerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[customerBalanceTitle]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        customerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[customerAmtLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        btnArrowcustomer.widthAnchor.constraint(equalToConstant: 31).isActive = true
        btnArrowcustomer.centerXAnchor.constraint(equalTo: customerView.centerXAnchor, constant: 0).isActive = true
        
        
        netView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[netLbl(25)]-5-[btnArrowNet(27)]-5-[netAmtLbl(25)][netBalanceTitle(15)]-10-|", options: [], metrics: nil, views: layoutDic))
        netView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[netLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        netView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[netBalanceTitle]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        netView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[netAmtLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        btnArrowNet.widthAnchor.constraint(equalToConstant: 33).isActive = true
        btnArrowNet.centerXAnchor.constraint(equalTo: netView.centerXAnchor, constant: 0).isActive = true
        
        bonusView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[bonusTotalTitleLbl]-(10)-[bonusReasonLbl]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        bonusView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[bonusLbl]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        bonusView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[bonusAmtLbl]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        bonusView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[bonusLbl(25)][bonusAmtLbl(25)][bonusTotalTitleLbl(25)]", options: [], metrics: nil, views: layoutDic))
        bonusView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[bonusReasonLbl(>=60)]-(>=15)-|", options: [], metrics: nil, views: layoutDic))
        bonusReasonLbl.widthAnchor.constraint(equalTo: bonusView.widthAnchor, multiplier: 0.7).isActive = true
        
        netProfitView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[netProfitAmtLbl]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        netProfitView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[netProfitReasonLbl]-(10)-[netProfitSeparator(1)]-10-[netProfitAmtLbl]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        netProfitLbl.centerXAnchor.constraint(equalTo: netProfitAmtLbl.centerXAnchor, constant: 0).isActive = true
        netProfitTotalTitleLbl.centerXAnchor.constraint(equalTo: netProfitAmtLbl.centerXAnchor, constant: 0).isActive = true
        netProfitView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[netProfitLbl(25)][netProfitAmtLbl(25)][netProfitTotalTitleLbl(25)]", options: [], metrics: nil, views: layoutDic))
        netProfitView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[netProfitReasonLbl(>=60)]-(>=15)-|", options: [], metrics: nil, views: layoutDic))
        
        netProfitSeparator.topAnchor.constraint(equalTo: netProfitView.topAnchor, constant: 20).isActive = true
        netProfitSeparator.bottomAnchor.constraint(equalTo: netProfitView.bottomAnchor, constant: -20).isActive = true

    }
 
}
