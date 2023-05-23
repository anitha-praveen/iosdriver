//
//  WalletView.swift
//  Taxiappz Driver
//
//  Created by Apple on 21/02/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import UIKit

class WalletView: UIView {
    
    let backBtn = UIButton()

    let titleView = UIView()
    let titleLbl = UILabel()

    let balanceView = UIView()
    let imgWallet = UIImageView()
    let lblCurrentBalance = UILabel()
    let lblTotalAmount = UILabel()
    
    let viewTxt = UIView()
    let lblCurrency = UILabel()
    let currencyView = UILabel()
    let moneyTfd = UITextField()
    let btnClose = UIButton()
    
    let btn1 = UIButton()
    let btn2 = UIButton()
    
    let addamtbtn = UIButton()
    let lineView = UIImageView()
    let tableView = UITableView()

    var layoutDic: [String:AnyObject] = [:]

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
        layoutDic["backBtn"] = backBtn
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(backBtn)
      
        
        titleView.backgroundColor = .secondaryColor
        titleView.layer.cornerRadius = 8
        titleView.addShadow()
        layoutDic["titleView"] = titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(titleView)
        
        titleLbl.text = "txt_wallet".localize()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDic["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)

        balanceView.backgroundColor = .hexToColor("f3f3f3")
        balanceView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["balanceView"] = balanceView
        baseView.addSubview(balanceView)
        
        imgWallet.contentMode = .scaleAspectFit
        imgWallet.image = UIImage(named: "paymentwallet")
        imgWallet.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["imgWallet"] = imgWallet
        balanceView.addSubview(imgWallet)

        lblCurrentBalance.text = "txt_Wallet_Titlte_home".localize()
        lblCurrentBalance.textAlignment = APIHelper.appTextAlignment
        lblCurrentBalance.textColor = .txtColor
        lblCurrentBalance.font = UIFont.appSemiBold(ofSize: 15)
        lblCurrentBalance.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblCurrentBalance"] = lblCurrentBalance
        balanceView.addSubview(lblCurrentBalance)

        lblTotalAmount.textAlignment = APIHelper.appTextAlignment
        lblTotalAmount.textColor = .txtColor
        lblTotalAmount.font = UIFont.appSemiBold(ofSize: 20)
        lblTotalAmount.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblTotalAmount"] = lblTotalAmount
        balanceView.addSubview(lblTotalAmount)
        
        currencyView.isHidden = true
        currencyView.frame = CGRect(x: 10, y: 0, width: 45, height: 45)
        currencyView.textAlignment = .center
        currencyView.font = UIFont.italicSystemFont(ofSize: 18)
        currencyView.textColor = .txtColor
        
        moneyTfd.isHidden = true
        moneyTfd.leftView = currencyView
        moneyTfd.leftViewMode = .always
     //   moneyTfd.becomeFirstResponder()
        moneyTfd.clearButtonMode = .always
        moneyTfd.placeholder = "0"
        moneyTfd.textAlignment = APIHelper.appTextAlignment
        moneyTfd.font = UIFont.italicSystemFont(ofSize: 18)
        moneyTfd.layer.cornerRadius = 4
        moneyTfd.layer.borderWidth = 1
        moneyTfd.layer.borderColor = UIColor.themeColor.cgColor
        moneyTfd.keyboardType = .numberPad
        moneyTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["moneyTfd"] = moneyTfd
        baseView.addSubview(moneyTfd)
        
        btn1.isHidden = true
        self.btn1.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        btn1.titleLabel?.font = UIFont.italicSystemFont(ofSize: 18)
        btn1.setTitleColor(.txtColor, for: .normal)
        btn1.backgroundColor = .secondaryColor
        btn1.layer.cornerRadius = 3
        btn1.layer.borderWidth = 1
        btn1.layer.borderColor = UIColor.themeColor.cgColor
        btn1.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["btn1"] = btn1
        baseView.addSubview(btn1)
        
        btn2.isHidden = true
        self.btn2.contentEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 8)
        btn2.titleLabel?.font = UIFont.italicSystemFont(ofSize: 18)
        btn2.setTitleColor(.txtColor, for: .normal)
        btn2.backgroundColor = .secondaryColor
        btn2.layer.cornerRadius = 3
        btn2.layer.borderWidth = 1
        btn2.layer.borderColor = UIColor.themeColor.cgColor
        btn2.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["btn2"] = btn2
        baseView.addSubview(btn2)
        
        addamtbtn.isHidden = true
        addamtbtn.setTitle("txt_Add".localize().uppercased(), for: .normal)
        addamtbtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 17)
        addamtbtn.layer.cornerRadius = 5
        addamtbtn.backgroundColor = .themeColor
        addamtbtn.setTitleColor(.secondaryColor, for: .normal)
        addamtbtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["addamtbtn"] = addamtbtn
        baseView.addSubview(addamtbtn)
        

        lineView.isHidden = true
        lineView.image = UIImage(named: "dashLine")
        layoutDic["lineView"] = lineView
        lineView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(lineView)

        tableView.alwaysBounceVertical = false
        tableView.showsVerticalScrollIndicator = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
       // tableView.register(WalletHistoryCell.self, forCellReuseIdentifier: "WalletHistoryCell")
        tableView.separatorStyle = .none
        tableView.backgroundColor = .secondaryColor
        layoutDic["tableView"] = tableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(tableView)
        
      
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(40)]-15-[titleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        backBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        
        
        tableView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleView]-15-[balanceView]-5-[tableView]", options: [], metrics: nil, views: layoutDic))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[balanceView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
       
        balanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[imgWallet(30)]-20-|", options: [], metrics: nil, views: layoutDic))
        balanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[imgWallet(30)]-8-[lblCurrentBalance]-8-[lblTotalAmount]-10-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))
        lblTotalAmount.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tableView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))



    }
}

// MARK: Wallet History Cell
class WalletHistoryCell: UITableViewCell {
    
    var viewContent = UIView()
    var adminCommissionLabel = UILabel()
    var serviceTaxLabel = UILabel()
    var lblDate = UILabel()
  //  var lblTransactionType = UILabel()
  //  var lblAmount = UILabel()
    
    var layoutDict = [String: AnyObject]()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupViews()
    }
    
    func setupViews() {
        
        viewContent.backgroundColor = .secondaryColor
        viewContent.addBorder(edges: .bottom , colour: .lightGray , thickness: 1)
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(viewContent)
        
//        lblTransactionType.textColor = .txtColor
//        lblTransactionType.font = UIFont.appSemiBold(ofSize: 14)
//        layoutDict["lblTransactionType"] = lblTransactionType
//        lblTransactionType.translatesAutoresizingMaskIntoConstraints = false
//        viewContent.addSubview(lblTransactionType)
        
        adminCommissionLabel.textColor = .txtColor
        adminCommissionLabel.font = UIFont.appSemiBold(ofSize: 13)
        layoutDict["adminCommissionLabel"] = adminCommissionLabel
        adminCommissionLabel.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(adminCommissionLabel)
        
        serviceTaxLabel.textColor = .txtColor
        serviceTaxLabel.font = UIFont.appSemiBold(ofSize: 13)
        layoutDict["serviceTaxLabel"] = serviceTaxLabel
        serviceTaxLabel.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(serviceTaxLabel)
        
        lblDate.textColor = .lightGray
        lblDate.font = UIFont.appRegularFont(ofSize: 13)
        layoutDict["lblDate"] = lblDate
        lblDate.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblDate)
        
//        lblAmount.font = UIFont.appSemiBold(ofSize: 14)
//        layoutDict["lblAmount"] = lblAmount
//        lblAmount.translatesAutoresizingMaskIntoConstraints = false
//        viewContent.addSubview(lblAmount)
        
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-3-[viewContent]-3-|", options: [], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[adminCommissionLabel(20)]-10-[serviceTaxLabel(20)]-10-[lblDate(20)]-8-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-18-[adminCommissionLabel]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
//        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[lblTransactionType(30)]-8-[lblDate(30)]-8-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
//         viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[lblAmount]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
//        lblAmount.centerYAnchor.constraint(equalTo: self.viewContent.centerYAnchor, constant: 0).isActive = true
//        lblAmount.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
    }
}
