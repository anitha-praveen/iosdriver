//
//  HistoryVC.swift
//  Captain Car
//
//  Created by Spextrum on 04/07/19.
//  Copyright © 2019 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import Charts
import NVActivityIndicatorView

class DBHistoryVC: UIViewController {
    
    let totalValLbl = UILabel(), monthlyValLbl = UILabel(), weeklyValLbl = UILabel()
    let cashValLbl = UILabel(), creditValLbl = UILabel(), walletValLbl = UILabel()
    
    var pieChartView = PieChartView()
    
    var cashChart = Double()
    var creditChart = Double()
    var walletChart = Double()
    
    var sumAmountLbl = UILabel()

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
        
        if let totaltrip = dict["total_trips"] as? [String:Any] {
            if let tripsCompleted = totaltrip["is_completed"] {
                self.totalValLbl.text = "\(tripsCompleted)"
            }
            if let amount = totaltrip["amount"] as? [String:Any] {
                if let cash = amount["cash"] {
                    self.sumAmountLbl.text = String(format: "%@ %0.2f", self.currency, amount)
                }
            }
        }
        if let weeklytrip = dict["weekly_trips"] as? [String:Any] {
            if let tripsCompleted = weeklytrip["is_completed"] {
                self.weeklyValLbl.text = "\(tripsCompleted)"
            }
        }
        if let monthlytrip = dict["monthly_trips"] as? [String:Any] {
            if let tripsCompleted = monthlytrip["is_completed"] {
                self.monthlyValLbl.text = "\(tripsCompleted)"
            }
        }
        
        if let totalTrip = dict["total_trips"] as? [String: AnyObject] {
            if let isCompleted = totalTrip["is_completed"] as? Int,
               let isCancelled = totalTrip["is_cancelled"] as? Int {
                let Total = isCompleted + isCancelled
//                    self.totPcValueLbl.text = "\(totalTrip)"
            }
            if let sumAmount = totalTrip["total_amount"], let totalAmt = Double("\(sumAmount)") {
                self.sumAmountLbl.text = String(format: "%@ %0.2f", self.currency, totalAmt)
            }
            
            if let amount = totalTrip["amount"] as? [String: AnyObject] {
                
                if let totalCash = amount["cash"], let cash = Double("\(totalCash)") {
                    self.cashValLbl.text = String(format: "%@ %0.2f", self.currency, cash)
                    self.cashChart = cash
                }
                if let totalcredit = amount["card"], let card = Double("\(totalcredit)") {
                    self.creditValLbl.text = String(format: "%@ %0.2f", self.currency, card)
                    self.creditChart = card
                }
                if let totalwallet = amount["wallet"], let wallet = Double("\(totalwallet)") {
                    self.walletValLbl.text = String(format: "%@ %0.2f", self.currency, wallet)
                    self.walletChart = wallet
                }
                
                if self.cashChart == 0 && self.creditChart == 0 && self.walletChart == 0 {
                    self.pieChartView.isHidden = true
                } else {
                    self.pieChartView.isHidden = false
                    let players = ["txt_cash".localize() , "txt_card".localize() , "txt_wallet".localize()]
                    let goals = [self.cashChart, self.creditChart, self.walletChart]
                    let arr = zip(players,goals).map { (name: $0, value: $1) }.filter { $0.1 > 0 }
                    self.customizeChart(data: arr)
                }
            }
        }
    }
    // MARK:Adding new UI Elements in setupViews
    func setupViews() {
        var layoutDic = [String: Any]()

        let scrollView = UIScrollView()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        layoutDic["scrollView"] = scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        let contentView = UIView()
        contentView.backgroundColor = .hexToColor("F2F2F2")
        contentView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["contentView"] = contentView
        scrollView.addSubview(contentView)
        
        if #available(iOS 11.0, *) {
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        } else {
            scrollView.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 0).isActive = true
            scrollView.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor, constant: 0).isActive = true
        }
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(0)-[scrollView]-(0)-|", options: [], metrics: nil, views: layoutDic))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: [], metrics: nil, views: layoutDic))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView]|", options: [], metrics: nil, views: layoutDic))
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let height = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        height.priority = .defaultLow
        height.isActive = true
        
        pieChartView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["pieChartView"] = pieChartView
        contentView.addSubview(pieChartView)
    
        
     /* let headerLbl = UILabel()
        headerLbl.textAlignment = APIHelper.appTextAlignment
        headerLbl.numberOfLines = 0
        headerLbl.lineBreakMode = .byWordWrapping
        headerLbl.textColor = .txtColor
        headerLbl.font = UIFont.appRegularFont(ofSize: 15)
        headerLbl.text = "text_history_header".localize()
        headerLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["headerLbl"] = headerLbl
        contentView.addSubview(headerLbl) */
        
        let totalView = RoundedShadowView()
        totalView.backgroundColor = .secondaryColor
        totalView.addBorder(edges: .bottom, colour: .themeColor, thickness: 3.0)  //hexToColor("FB4A46")
        totalView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["totalView"] = totalView
        contentView.addSubview(totalView)
        
        let totalLbl = UILabel()
        totalLbl.adjustsFontSizeToFitWidth = true
        totalLbl.minimumScaleFactor = 0.1
        totalLbl.textAlignment = APIHelper.appTextAlignment
        totalLbl.textColor = .txtColor
        totalLbl.font = UIFont.appMediumFont(ofSize: 13)
        totalLbl.text = "total_trips".localize()
        totalLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["totalLbl"] = totalLbl
        totalView.addSubview(totalLbl)
        
        totalValLbl.adjustsFontSizeToFitWidth = true
        totalValLbl.minimumScaleFactor = 0.1
        totalValLbl.textAlignment = APIHelper.appTextAlignment
        totalValLbl.textColor = .themeColor //hexToColor("FB4A46")
        totalValLbl.font = UIFont.appMediumFont(ofSize: 20)
        totalValLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["totalValLbl"] = totalValLbl
        totalView.addSubview(totalValLbl)
        
        let totalNoteLbl = UILabel()
        totalNoteLbl.textAlignment = APIHelper.appTextAlignment
        totalNoteLbl.textColor = .hexToColor("979797")
        totalNoteLbl.font = UIFont.appMediumFont(ofSize: 12)
        totalNoteLbl.text = "txt_completed".localize()
        totalNoteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["totalNoteLbl"] = totalNoteLbl
        totalView.addSubview(totalNoteLbl)

        let weeklyTripView = RoundedShadowView()
        weeklyTripView.addBorder(edges: .bottom, colour: .hexToColor("00AE73"), thickness: 3.0)
        weeklyTripView.backgroundColor = .secondaryColor
        weeklyTripView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["weeklyTripView"] = weeklyTripView
        contentView.addSubview(weeklyTripView)
        
        let weeklyTitleLbl = UILabel()
        weeklyTitleLbl.adjustsFontSizeToFitWidth = true
        weeklyTitleLbl.minimumScaleFactor = 0.1
        weeklyTitleLbl.textAlignment = APIHelper.appTextAlignment
        weeklyTitleLbl.textColor = .txtColor
        weeklyTitleLbl.font = UIFont.appMediumFont(ofSize: 13)
        weeklyTitleLbl.text = "txt_weekly_trip".localize()
        weeklyTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["weeklyTitleLbl"] = weeklyTitleLbl
        weeklyTripView.addSubview(weeklyTitleLbl)
        
        weeklyValLbl.adjustsFontSizeToFitWidth = true
        weeklyValLbl.minimumScaleFactor = 0.1
        weeklyValLbl.textAlignment = APIHelper.appTextAlignment
        weeklyValLbl.textColor = .themeColor //hexToColor("00AE73")
        weeklyValLbl.font = UIFont.appMediumFont(ofSize: 20)
        weeklyValLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["weeklyValLbl"] = weeklyValLbl
        weeklyTripView.addSubview(weeklyValLbl)
        
        let weeklyNoteLbl = UILabel()
        weeklyNoteLbl.textAlignment = APIHelper.appTextAlignment
        weeklyNoteLbl.textColor = .hexToColor("979797")
        weeklyNoteLbl.font = UIFont.appMediumFont(ofSize: 12)
        weeklyNoteLbl.text = "txt_completed".localize()
        weeklyNoteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["weeklyNoteLbl"] = weeklyNoteLbl
        weeklyTripView.addSubview(weeklyNoteLbl)
        
        let monthlyTitleView = RoundedShadowView()
        monthlyTitleView.addBorder(edges: .bottom, colour: .hexToColor("5497FF"), thickness: 3.0)
        monthlyTitleView.backgroundColor = .secondaryColor
        monthlyTitleView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["monthlyTitleView"] = monthlyTitleView
        contentView.addSubview(monthlyTitleView)
        
        let monthlyTitleLbl = UILabel()
        monthlyTitleLbl.adjustsFontSizeToFitWidth = true
        monthlyTitleLbl.minimumScaleFactor = 0.1
        monthlyTitleLbl.textAlignment = APIHelper.appTextAlignment
        monthlyTitleLbl.textColor = .txtColor
        monthlyTitleLbl.font = UIFont.appMediumFont(ofSize: 13)
        monthlyTitleLbl.text = "txt_monthly_trip".localize()
        monthlyTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["monthlyTitleLbl"] = monthlyTitleLbl
        monthlyTitleView.addSubview(monthlyTitleLbl)
        
        monthlyValLbl.adjustsFontSizeToFitWidth = true
        monthlyValLbl.minimumScaleFactor = 0.1
        monthlyValLbl.textAlignment = APIHelper.appTextAlignment
        monthlyValLbl.textColor = .hexToColor("5497FF")
        monthlyValLbl.font = UIFont.appMediumFont(ofSize: 20)
        monthlyValLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["monthlyValLbl"] = monthlyValLbl
        monthlyTitleView.addSubview(monthlyValLbl)
        
        let monthlyNoteLbl = UILabel()
        monthlyNoteLbl.textAlignment = APIHelper.appTextAlignment
        monthlyNoteLbl.textColor = .hexToColor("979797")
        monthlyNoteLbl.font = UIFont.appMediumFont(ofSize: 12)
        monthlyNoteLbl.text = "txt_completed".localize()
        monthlyNoteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["monthlyNoteLbl"] = monthlyNoteLbl
        monthlyTitleView.addSubview(monthlyNoteLbl)
        
        let headerLbl1 = UILabel()
        headerLbl1.textAlignment = APIHelper.appTextAlignment
        headerLbl1.numberOfLines = 0
        headerLbl1.lineBreakMode = .byWordWrapping
        headerLbl1.textColor = .txtColor
        headerLbl1.font = UIFont.appRegularFont(ofSize: 15)
        headerLbl1.text = "text_header1".localize()
        headerLbl1.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["headerLbl1"] = headerLbl1
        contentView.addSubview(headerLbl1)
        
        let cashView = RoundedShadowView()
        cashView.addBorder(edges: .bottom, colour: .themeColor, thickness: 3.0)  //.hexToColor("FB4A46")
        cashView.backgroundColor = .secondaryColor
        cashView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cashView"] = cashView
        contentView.addSubview(cashView)
        
        let cashLbl = UILabel()
        cashLbl.adjustsFontSizeToFitWidth = true
        cashLbl.minimumScaleFactor = 0.1
        cashLbl.textAlignment = .center
        cashLbl.textColor = .txtColor
        cashLbl.font = UIFont.appMediumFont(ofSize: 13)
        cashLbl.text = "txt_cash".localize().uppercased()
        cashLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cashLbl"] = cashLbl
        cashView.addSubview(cashLbl)
        
        let cashImgView = UIImageView()
        cashImgView.contentMode = .scaleAspectFit
        cashImgView.image = UIImage(named: "ic_pay_mode_cash")
        cashImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cashImgView"] = cashImgView
        cashView.addSubview(cashImgView)
        
        cashValLbl.adjustsFontSizeToFitWidth = true
        cashValLbl.minimumScaleFactor = 0.1
        cashValLbl.textAlignment = .center
        cashValLbl.textColor = .txtColor
        cashValLbl.font = UIFont.appMediumFont(ofSize: 15)
        cashValLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cashValLbl"] = cashValLbl
        cashView.addSubview(cashValLbl)
        
        let cashNoteLbl = UILabel()
        cashNoteLbl.textAlignment = .center
        cashNoteLbl.textColor = .hexToColor("979797")
        cashNoteLbl.font = UIFont.appMediumFont(ofSize: 12)
        cashNoteLbl.text = "text_total_amt".localize()
        cashNoteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["cashNoteLbl"] = cashNoteLbl
        cashView.addSubview(cashNoteLbl)
        
     /*   let creditView = RoundedShadowView()
        creditView.addBorder(edges: .bottom, colour: .hexToColor("00AE73"), thickness: 3.0)
        creditView.backgroundColor = .secondaryColor
        creditView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["creditView"] = creditView
        contentView.addSubview(creditView)
        
        let creditLbl = UILabel()
        creditLbl.adjustsFontSizeToFitWidth = true
        creditLbl.minimumScaleFactor = 0.1
        creditLbl.textAlignment = .center
        creditLbl.textColor = .txtColor
        creditLbl.font = UIFont.appMediumFont(ofSize: 13)
        creditLbl.text = "text_credit".localize()
        creditLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["creditLbl"] = creditLbl
        creditView.addSubview(creditLbl)
        
        let creditImgView = UIImageView()
        creditImgView.image = UIImage(named: "ic_dash_credit")
        creditImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["creditImgView"] = creditImgView
        creditView.addSubview(creditImgView)
        
        creditValLbl.adjustsFontSizeToFitWidth = true
        creditValLbl.minimumScaleFactor = 0.1
        creditValLbl.textAlignment = .center
        creditValLbl.textColor = .txtColor
        creditValLbl.font = UIFont.appMediumFont(ofSize: 15)
        creditValLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["creditValLbl"] = creditValLbl
        creditView.addSubview(creditValLbl)
        
        let creditNoteLbl = UILabel()
        creditNoteLbl.textAlignment = .center
        creditNoteLbl.textColor = .hexToColor("979797")
        creditNoteLbl.font = UIFont.appMediumFont(ofSize: 12)
        creditNoteLbl.text = "text_total_amt".localize()
        creditNoteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["creditNoteLbl"] = creditNoteLbl
        creditView.addSubview(creditNoteLbl)
        
        let walletView = RoundedShadowView()
        walletView.addBorder(edges: .bottom, colour: .hexToColor("5497FF"), thickness: 3.0)
        walletView.backgroundColor = .secondaryColor
        walletView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["walletView"] = walletView
        contentView.addSubview(walletView)
        
        let walletLbl = UILabel()
        walletLbl.adjustsFontSizeToFitWidth = true
        walletLbl.minimumScaleFactor = 0.1
        walletLbl.textAlignment = .center
        walletLbl.textColor = .txtColor
        walletLbl.font = UIFont.appMediumFont(ofSize: 13)
        walletLbl.text = "txt_wallet".localize()
        walletLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["walletLbl"] = walletLbl
        walletView.addSubview(walletLbl)
        
        let walletImgView = UIImageView()
        walletImgView.image = UIImage(named: "ic_dash_wallet")
        walletImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["walletImgView"] = walletImgView
        walletView.addSubview(walletImgView)
        
        walletValLbl.adjustsFontSizeToFitWidth = true
        walletValLbl.minimumScaleFactor = 0.1
        walletValLbl.textAlignment = .center
        walletValLbl.textColor = .txtColor
        walletValLbl.font = UIFont.appMediumFont(ofSize: 15)
        walletValLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["walletValLbl"] = walletValLbl
        walletView.addSubview(walletValLbl)
        
        let walletNoteLbl = UILabel()
        walletNoteLbl.textAlignment = .center
        walletNoteLbl.textColor = .hexToColor("979797")
        walletNoteLbl.font = UIFont.appMediumFont(ofSize: 12)
        walletNoteLbl.text = "text_total_amt".localize()
        walletNoteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["walletNoteLbl"] = walletNoteLbl
        walletView.addSubview(walletNoteLbl) */
        
        sumAmountLbl.textAlignment = APIHelper.appTextAlignment
        sumAmountLbl.textColor = .txtColor
        sumAmountLbl.font = UIFont.appMediumFont(ofSize: 12)
        sumAmountLbl.sizeToFit()
        sumAmountLbl.layoutIfNeeded()
        sumAmountLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["sumAmountLbl"] = sumAmountLbl
        pieChartView.addSubview(sumAmountLbl)
        
        let sumAmountNoteLbl = UILabel()
        sumAmountNoteLbl.textAlignment = APIHelper.appTextAlignment
        sumAmountNoteLbl.textColor = .txtColor
        sumAmountNoteLbl.font = UIFont.appMediumFont(ofSize: 12)
        sumAmountNoteLbl.text = "txt_sum_amount".localize()
        sumAmountNoteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["sumAmountNoteLbl"] = sumAmountNoteLbl
        pieChartView.addSubview(sumAmountNoteLbl)
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(22)-[totalView]-(18)-[headerLbl1(>=30)]-(18)-[cashView]-[pieChartView(300)]-(>=10)-|", options: [], metrics: nil, views: layoutDic))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[headerLbl1]-(10)-|", options: [], metrics: nil, views: layoutDic))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[pieChartView]-(10)-|", options: [], metrics: nil, views: layoutDic))

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[totalView]-(10)-[weeklyTripView(==totalView)]-(10)-[monthlyTitleView(==totalView)]-(10)-|", options: [APIHelper.appLanguageDirection, .alignAllTop, .alignAllBottom], metrics: nil, views: layoutDic))

        totalView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[totalLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        totalView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[totalValLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        totalView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[totalNoteLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        totalView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[totalLbl(30)]-(8)-[totalValLbl(30)]-(5)-[totalNoteLbl(21)]-(10)-|", options: [], metrics: nil, views: layoutDic))
        
        weeklyTripView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[weeklyTitleLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        weeklyTripView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[weeklyValLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        weeklyTripView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[weeklyNoteLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        weeklyTripView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[weeklyTitleLbl(30)]-(8)-[weeklyValLbl(30)]-(5)-[weeklyNoteLbl(21)]-(10)-|", options: [], metrics: nil, views: layoutDic))
        
        monthlyTitleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[monthlyTitleLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        monthlyTitleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[monthlyValLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        monthlyTitleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[monthlyNoteLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        monthlyTitleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[monthlyTitleLbl(30)]-(8)-[monthlyValLbl(30)]-(5)-[monthlyNoteLbl(21)]-(10)-|", options: [], metrics: nil, views: layoutDic))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(15)-[cashView]-(15)-|", options: [APIHelper.appLanguageDirection, .alignAllTop, .alignAllBottom], metrics: nil, views: layoutDic))
        
        cashView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[cashLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        cashView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[cashValLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        cashView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[cashNoteLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        cashView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[cashLbl(30)]-5-[cashImgView(30)]-(8)-[cashValLbl(28)]-(5)-[cashNoteLbl(21)]-(10)-|", options: [], metrics: nil, views: layoutDic))
        cashImgView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        cashImgView.centerXAnchor.constraint(equalTo: cashView.centerXAnchor, constant: 0).isActive = true
        
        
     /*   creditView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[creditLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        creditView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[creditValLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        creditView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[creditNoteLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        creditView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[creditLbl(30)]-5-[creditImgView(26)]-(8)-[creditValLbl(30)]-(5)-[creditNoteLbl(21)]-(10)-|", options: [], metrics: nil, views: layoutDic))
        creditImgView.widthAnchor.constraint(equalToConstant: 37).isActive = true
        creditImgView.centerXAnchor.constraint(equalTo: creditView.centerXAnchor, constant: 0).isActive = true
        
        walletView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[walletLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        walletView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[walletValLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        walletView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[walletNoteLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        walletView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[walletLbl(30)]-5-[walletImgView(27)]-(8)-[walletValLbl(30)]-(5)-[walletNoteLbl(21)]-(10)-|", options: [], metrics: nil, views: layoutDic))
        walletImgView.widthAnchor.constraint(equalToConstant: 33).isActive = true
        walletImgView.centerXAnchor.constraint(equalTo: walletView.centerXAnchor, constant: 0).isActive = true */

        sumAmountLbl.centerXAnchor.constraint(equalTo: pieChartView.centerXAnchor, constant: 0).isActive = true
        sumAmountLbl.centerYAnchor.constraint(equalTo: pieChartView.centerYAnchor, constant: -15).isActive = true
        sumAmountNoteLbl.centerXAnchor.constraint(equalTo: sumAmountLbl.centerXAnchor, constant: 0).isActive = true

        sumAmountNoteLbl.centerYAnchor.constraint(equalTo: sumAmountLbl.bottomAnchor, constant: 5).isActive = true

    }
    
    // MARK: Chart Data
    func customizeChart(data: [(name: String, value: Double)]) {

        // 1. Set ChartDataEntry
        var dataEntries: [ChartDataEntry] = []
        for i in data {
            let dataEntry = PieChartDataEntry(value: i.value, label: i.name, data: i.name as AnyObject)
            dataEntries.append(dataEntry)
        }
        // 2. Set ChartDataSet

        let pieChartDataSet = PieChartDataSet(values: dataEntries, label: "")
        pieChartDataSet.colors = [.hexToColor("4CE5B1"), UIColor(red: 254/255.0, green: 181/255.0, blue: 97/255.0, alpha: 1),UIColor(red: 240/255.0, green: 90/255.0, blue: 80/255.0, alpha: 1)]
        // 3. Set ChartData
        let pieChartData = PieChartData(dataSet: pieChartDataSet)
        let format = NumberFormatter()
        format.numberStyle = .none
        let formatter = DefaultValueFormatter(formatter: format)
        pieChartData.setValueFormatter(formatter)
        
        // 4. Assign it to the chart’s data
        pieChartView.data = pieChartData
        
    }
    
   
}

// MARK: UILabel textheights to adjust label
extension UILabel {
    
    func retrieveTextHeight () -> CGFloat {
        let attributedText = NSAttributedString(string: self.text!, attributes: [NSAttributedString.Key.font:self.font])
        
        let rect = attributedText.boundingRect(with: CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude), options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(rect.size.height)
    }
    
}

