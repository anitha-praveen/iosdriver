//
//  BalanceVC.swift
//  Captain Car
//
//  Created by Spextrum on 04/07/19.
//  Copyright © 2019 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import Charts

class DBBalanceVC: UIViewController {
    
    let hourlyBtn = GradientButton(), dailyBtn = GradientButton(), monthlyBtn = GradientButton()
    let monthValLbl = UILabel(), todayValLbl = UILabel(), totalValLbl = UILabel(), weekValLbl = UILabel(), ydaValLbl = UILabel()
    let todayImgView = UIImageView()
    var yesterDayImgView = UIImageView()
    let chartView = LineChartView()
    var hourlyValues:[(key: String, value: Double)] = []
    var dailyValues:[(key: String, value: Double)] = []
    var monthValues:[(key: String, value: Double)] = []
    
    let viewDayMonth = UIView()
    let lblDayMonth = UILabel()
    let btnDownArrow = UIButton()
    
    let viewTbl = UIView()
    let tblChooseDayMonth = UITableView()
    
    var dailyEarning = [DailyEarning]()
    var selectedEarning: DailyEarning = .hourly
    
    var currency = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.dailyEarning = DailyEarning.allCases

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
        if let todayTrips = dict["today_trips"] as? [String: AnyObject] {
            if let total = todayTrips["total_amount"], let totalAmt = Double("\(total)") {
                self.todayValLbl.text = String(format: "%@ %0.2f", self.currency, totalAmt)
            }
        }
        if let monthlyTrips = dict["monthly_trips"] as? [String: AnyObject] {
            if let total = monthlyTrips["total_amount"], let totalAmt = Double("\(total)") {
                self.monthValLbl.text = String(format: "%@ %0.2f", self.currency, totalAmt)
            }
        }
        if let weeklyTrips = dict["weekly_trips"] as? [String: AnyObject] {
            if let total = weeklyTrips["total_amount"], let totalAmt = Double("\(total)") {
                self.weekValLbl.text = String(format: "%@ %0.2f", self.currency, totalAmt)
            }
        }
        if let yesterdayTrips = dict["yesterday_trips"] as? [String: AnyObject] {
            if let total = yesterdayTrips["total_amount"], let totalAmt = Double("\(total)") {
                self.ydaValLbl.text = String(format: "%@ %0.2f", self.currency, totalAmt)
            }
        }
        if let totalTrips = dict["total_trips"] as? [String:AnyObject] {
            if let total = totalTrips["total_amount"], let totalAmt = Double("\(total)") {
                self.totalValLbl.text = String(format: "%@ %0.2f", self.currency, totalAmt)
            }
        }
        
        if let report = dict["report"] as? [String: AnyObject] {
            if let day = report["hour"] as? [String: AnyObject], let horizontalKeys = day["horizontal_keys"] as? [String],
               let values = day["values"] as? [String] {
                self.hourlyValues = zip(horizontalKeys,values).map{ (key: String($0.prefix(3)), value: Double($1) ?? 0) }
                self.setDataCount(self.hourlyValues)
            }
            if let week = report["day"] as? [String: AnyObject], let horizontalKeys = week["horizontal_keys"] as? [String],
               let values = week["values"] as? [String] {
                self.dailyValues = zip(horizontalKeys,values).map{ (key: String($0.prefix(3)), value: Double($1) ?? 0) }
            }
            if let month = report["month"] as? [String: AnyObject], let horizontalKeys = month["horizontal_keys"] as? [String],
               let values = month["values"] as? [String] {
                self.monthValues = zip(horizontalKeys,values).map{ (key: String($0.prefix(3)), value: Double($1) ?? 0) }
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
        
        let headerLbl = UILabel()
        headerLbl.textAlignment = APIHelper.appTextAlignment
        headerLbl.numberOfLines = 0
        headerLbl.lineBreakMode = .byWordWrapping
        headerLbl.textColor = .systemGray
        headerLbl.font = UIFont.appRegularFont(ofSize: 15)
        headerLbl.text = "text_balance_header".localize()
        headerLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["headerLbl"] = headerLbl
        contentView.addSubview(headerLbl)
        
        let todayView = RoundedShadowView()
        todayView.addBorder(edges: .bottom, colour: .hexToColor("00AE73"), thickness: 3.0)
        todayView.backgroundColor = .secondaryColor
        todayView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["todayView"] = todayView
        contentView.addSubview(todayView)
        
        let todayLbl = UILabel()
        todayLbl.adjustsFontSizeToFitWidth = true
        todayLbl.minimumScaleFactor = 0.1
        todayLbl.textAlignment = .center
        todayLbl.textColor = .txtColor
        todayLbl.font = UIFont.appMediumFont(ofSize: 13)
        todayLbl.text = "text_todays_balance".localize()
        todayLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["todayLbl"] = todayLbl
        todayView.addSubview(todayLbl)
        
        todayValLbl.textAlignment = .center
        todayValLbl.textColor = .txtColor
        todayValLbl.font = UIFont.appMediumFont(ofSize: 15)
        todayValLbl.adjustsFontSizeToFitWidth = true
        todayValLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["todayValLbl"] = todayValLbl
        todayView.addSubview(todayValLbl)
        
        let todayNoteLbl = UILabel()
        todayNoteLbl.textAlignment = .center
        todayNoteLbl.textColor = .hexToColor("979797")
        todayNoteLbl.font = UIFont.appMediumFont(ofSize: 12)
        todayNoteLbl.text = "text_today_note".localize()
        todayNoteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["todayNoteLbl"] = todayNoteLbl
        todayView.addSubview(todayNoteLbl)
        
        todayImgView.image = UIImage(named:"ic_dash_today")
        todayImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["todayImgView"] = todayImgView
        todayView.addSubview(todayImgView)
        
        let ydaView = RoundedShadowView()
        ydaView.addBorder(edges: .bottom, colour: .hexToColor("5497FF"), thickness: 3.0)
        ydaView.backgroundColor = .secondaryColor
        ydaView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["ydaView"] = ydaView
        contentView.addSubview(ydaView)
        
        let ydaLbl = UILabel()
        ydaLbl.adjustsFontSizeToFitWidth = true
        ydaLbl.minimumScaleFactor = 0.1
        ydaLbl.textAlignment = .center
        ydaLbl.textColor = .txtColor
        ydaLbl.font = UIFont.appMediumFont(ofSize: 13)
        ydaLbl.text = "text_yda_balance".localize()
        ydaLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["ydaLbl"] = ydaLbl
        ydaView.addSubview(ydaLbl)
        
        ydaValLbl.textAlignment = .center
        ydaValLbl.textColor = .txtColor
        ydaValLbl.font = UIFont.appMediumFont(ofSize: 15)
        ydaValLbl.adjustsFontSizeToFitWidth = true
        ydaValLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["ydaValLbl"] = ydaValLbl
        ydaView.addSubview(ydaValLbl)
        
        let ydaNoteLbl = UILabel()
        ydaNoteLbl.textAlignment = .center
        ydaNoteLbl.textColor = .hexToColor("979797")
        ydaNoteLbl.font = UIFont.appMediumFont(ofSize: 12)
        ydaNoteLbl.text = "text_yda_note".localize()
        ydaNoteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["ydaNoteLbl"] = ydaNoteLbl
        ydaView.addSubview(ydaNoteLbl)
        
        yesterDayImgView.image = UIImage(named: "ic_dash_sterday")
        yesterDayImgView.contentMode = .scaleAspectFit
        yesterDayImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["yesterDayImgView"] = yesterDayImgView
        ydaView.addSubview(yesterDayImgView)
        
        let weekView = RoundedShadowView(.hexToColor("4CE5B1"))
        weekView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["weekView"] = weekView
        contentView.addSubview(weekView)
        
        let weekLbl = UILabel()
        weekLbl.textAlignment = APIHelper.appTextAlignment
        weekLbl.textColor = .secondaryColor
        weekLbl.font = UIFont.appSemiBold(ofSize: 13)
        weekLbl.text = "text_week_balance".localize()
        weekLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["weekLbl"] = weekLbl
        weekView.addSubview(weekLbl)
        
        weekValLbl.textAlignment = APIHelper.appTextAlignment
        weekValLbl.textColor = .secondaryColor
        weekValLbl.font = UIFont.appMediumFont(ofSize: 20)
        weekValLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["weekValLbl"] = weekValLbl
        weekView.addSubview(weekValLbl)
        
        let weekNoteLbl = UILabel()
        weekNoteLbl.textAlignment = APIHelper.appTextAlignment
        weekNoteLbl.textColor = .secondaryColor
        weekNoteLbl.font = UIFont.appSemiBold(ofSize: 11)
        weekNoteLbl.text = "text_week_note".localize()
        weekNoteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["weekNoteLbl"] = weekNoteLbl
        weekView.addSubview(weekNoteLbl)
        
        let weekImgView = UIImageView(image: UIImage(named: "chart"))
        weekImgView.contentMode = .scaleAspectFit
        weekImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["weekImgView"] = weekImgView
        //weekView.addSubview(weekImgView)
        
        let monthView = RoundedShadowView(.themeColor) //hexToColor("FB4A46")
        monthView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["monthView"] = monthView
        contentView.addSubview(monthView)
        
        let monthLbl = UILabel()
        monthLbl.adjustsFontSizeToFitWidth = true
        monthLbl.minimumScaleFactor = 0.1
        monthLbl.textAlignment = APIHelper.appTextAlignment
        monthLbl.textColor = .secondaryColor
        monthLbl.font = UIFont.appSemiBold(ofSize: 13)
        monthLbl.text = "text_month_balance".localize()
        monthLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["monthLbl"] = monthLbl
        monthView.addSubview(monthLbl)
        
        monthValLbl.textAlignment = APIHelper.appTextAlignment
        monthValLbl.textColor = .secondaryColor
        monthValLbl.font = UIFont.appMediumFont(ofSize: 20)
        monthValLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["monthValLbl"] = monthValLbl
        monthView.addSubview(monthValLbl)
        
        let monthNoteLbl = UILabel()
        monthNoteLbl.textAlignment = APIHelper.appTextAlignment
        monthNoteLbl.textColor = .secondaryColor
        monthNoteLbl.font = UIFont.appSemiBold(ofSize: 11)
        monthNoteLbl.text = "text_month_note".localize()
        monthNoteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["monthNoteLbl"] = monthNoteLbl
        monthView.addSubview(monthNoteLbl)
        
        let monthImgView = UIImageView(image: UIImage(named: "chart"))
        monthImgView.contentMode = .scaleAspectFit
        monthImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["monthImgView"] = monthImgView
       // monthView.addSubview(monthImgView)
        
        let noteLbl = UILabel()
        noteLbl.textAlignment = APIHelper.appTextAlignment
        noteLbl.numberOfLines = 0
        noteLbl.lineBreakMode = .byWordWrapping
        noteLbl.textColor = .systemGray
        noteLbl.font = UIFont.appRegularFont(ofSize: 15)
        noteLbl.text = "text_balance_note".localize()
        noteLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["noteLbl"] = noteLbl
        contentView.addSubview(noteLbl)
        
        totalValLbl.textAlignment = .center
        totalValLbl.textColor = .inkBlue
        totalValLbl.font = UIFont.appBoldFont(ofSize: 18)
        totalValLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["totalValLbl"] = totalValLbl
        contentView.addSubview(totalValLbl)
        
        let totalLbl = UILabel()
        totalLbl.textAlignment = .center
        totalLbl.textColor = .txtColor
        totalLbl.font = UIFont.appRegularFont(ofSize: 18)
        totalLbl.text = "text_total_note".localize()
        totalLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["totalLbl"] = totalLbl
        contentView.addSubview(totalLbl)
        
        let chartBackgroundView = UIView()
        chartBackgroundView.backgroundColor = .secondaryColor
        chartBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["chartBackgroundView"] = chartBackgroundView
        contentView.addSubview(chartBackgroundView)
        
        viewDayMonth.layer.cornerRadius = 3
        viewDayMonth.layer.borderWidth = 1
        viewDayMonth.layer.borderColor = UIColor.hexToColor("DADADA").cgColor
        viewDayMonth.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["viewDayMonth"] = viewDayMonth
        chartBackgroundView.addSubview(viewDayMonth)
        
        let vertLine = UIView()
        vertLine.backgroundColor = .hexToColor("DADADA")
        vertLine.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["vertLine"] = vertLine
        viewDayMonth.addSubview(vertLine)
        
        lblDayMonth.text = self.selectedEarning.title
        lblDayMonth.textColor = .txtColor
        lblDayMonth.font = UIFont.appFont(ofSize: 14)
        lblDayMonth.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["lblDayMonth"] = lblDayMonth
        viewDayMonth.addSubview(lblDayMonth)
        
        btnDownArrow.addTarget(self, action: #selector(openTable(_ :)), for: .touchUpInside)
        btnDownArrow.imageView?.contentMode = .center
        btnDownArrow.setImage(UIImage(named: "downarrow"), for: .normal)
        btnDownArrow.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["btnDownArrow"] = btnDownArrow
        viewDayMonth.addSubview(btnDownArrow)
        
        let stackView = UIStackView()
        stackView.isHidden = true
        stackView.axis = .horizontal
        stackView.distribution = .fillProportionally
        stackView.alignment = .fill
        stackView.spacing = 0
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["stackView"] = stackView
      //  contentView.addSubview(stackView)
        
        hourlyBtn.isSelected = true
        hourlyBtn.layer.cornerRadius = 3.0
        hourlyBtn.layer.masksToBounds = true
        hourlyBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        hourlyBtn.addTarget(self, action: #selector(dayBtnAction(_:)), for: .touchUpInside)
        hourlyBtn.setTitleColor(.txtColor, for: .normal)
        hourlyBtn.setTitleColor(.secondaryColor, for: .selected)
        hourlyBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        hourlyBtn.setTitle("text_day".localize(), for: .normal)
        hourlyBtn.sizeToFit()
        hourlyBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["hourlyBtn"] = hourlyBtn
        stackView.addArrangedSubview(hourlyBtn)

        dailyBtn.layer.cornerRadius = 3.0
        dailyBtn.layer.masksToBounds = true
        dailyBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        dailyBtn.addTarget(self, action: #selector(weekBtnAction(_:)), for: .touchUpInside)
        dailyBtn.setTitleColor(.txtColor, for: .normal)
        dailyBtn.setTitleColor(.secondaryColor, for: .selected)
        dailyBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        dailyBtn.setTitle("text_week".localize(), for: .normal)
        dailyBtn.sizeToFit()
        dailyBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["dailyBtn"] = dailyBtn
        stackView.addArrangedSubview(dailyBtn)
        
        monthlyBtn.layer.cornerRadius = 3.0
        monthlyBtn.layer.masksToBounds = true
        monthlyBtn.contentEdgeInsets = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
        monthlyBtn.addTarget(self, action: #selector(monthBtnAction(_:)), for: .touchUpInside)
        monthlyBtn.setTitleColor(.txtColor, for: .normal)
        monthlyBtn.setTitleColor(.secondaryColor, for: .selected)
        monthlyBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        monthlyBtn.setTitle("text_month".localize(), for: .normal)
        monthlyBtn.sizeToFit()
        monthlyBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["monthlyBtn"] = monthlyBtn
        stackView.addArrangedSubview(monthlyBtn)
        
        chartView.delegate = self
        chartView.chartDescription?.enabled = false
        chartView.dragEnabled = true
        chartView.setScaleEnabled(true)
        chartView.pinchZoomEnabled = false
        chartView.highlightPerDragEnabled = true
        chartView.backgroundColor = .secondaryColor
        chartView.legend.enabled = false
        let xAxis = chartView.xAxis
        xAxis.labelPosition = .bottom
        xAxis.labelFont = .systemFont(ofSize: 10, weight: .light)
        xAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        xAxis.drawAxisLineEnabled = false
        xAxis.drawGridLinesEnabled = false
        xAxis.centerAxisLabelsEnabled = false

        let leftAxis = chartView.leftAxis
        leftAxis.labelPosition = .outsideChart
        leftAxis.labelFont = .systemFont(ofSize: 12, weight: .light)
        leftAxis.drawGridLinesEnabled = true
        leftAxis.granularityEnabled = true
        leftAxis.axisMinimum = 0
        leftAxis.yOffset = -9
        leftAxis.labelTextColor = UIColor(red: 255/255, green: 192/255, blue: 56/255, alpha: 1)
        chartView.rightAxis.enabled = false
        chartView.legend.form = .line
        chartView.animate(xAxisDuration: 2.5)
        chartView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["chartView"] = chartView
        chartBackgroundView.addSubview(chartView)
        
        viewTbl.isHidden = true
        viewTbl.addShadow()
        viewTbl.layer.cornerRadius = 5
        viewTbl.backgroundColor = .secondaryColor
        viewTbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["viewTbl"] = viewTbl
        chartBackgroundView.addSubview(viewTbl)
        
        tblChooseDayMonth.delegate = self
        tblChooseDayMonth.dataSource = self
        tblChooseDayMonth.backgroundColor = .secondaryColor
        tblChooseDayMonth.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["tblChooseDayMonth"] = tblChooseDayMonth
        viewTbl.addSubview(tblChooseDayMonth)
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[headerLbl(>=30)]-(16)-[todayView]-(16)-[weekView]-(16)-[noteLbl(>=30)]-(16)-[totalValLbl(30)]-(5)-[totalLbl(21)]-16-[chartBackgroundView]-(15)-|", options: [], metrics: nil, views: layoutDic))  //[totalValLbl(30)]-(5)-
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[headerLbl]-(10)-|", options: [], metrics: nil, views: layoutDic))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[totalValLbl]-(10)-|", options: [], metrics: nil, views: layoutDic))

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[todayView]-(8)-[ydaView(==todayView)]-(10)-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDic))

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[weekView]-(10)-[monthView(==weekView)]-(10)-|", options: [APIHelper.appLanguageDirection, .alignAllTop, .alignAllBottom], metrics: nil, views: layoutDic))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[noteLbl]-(10)-|", options: [], metrics: nil, views: layoutDic))
      
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[totalLbl]-(10)-|", options: [APIHelper.appLanguageDirection, .alignAllCenterY], metrics: nil, views: layoutDic))
      
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[chartBackgroundView]-(10)-|", options: [], metrics: nil, views: layoutDic))
        

        todayView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[todayLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        todayImgView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        todayImgView.centerXAnchor.constraint(equalTo: todayView.centerXAnchor, constant: 0).isActive = true
        todayView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[todayValLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        todayView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[todayNoteLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        todayView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[todayLbl(30)]-5-[todayImgView(30)]-(10)-[todayValLbl(30)]-(5)-[todayNoteLbl(21)]-(10)-|", options: [], metrics: nil, views: layoutDic))
        
        ydaView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[ydaLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
         ydaView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[ydaValLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        yesterDayImgView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        yesterDayImgView.centerXAnchor.constraint(equalTo: ydaView.centerXAnchor, constant: 0).isActive = true
        ydaView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[ydaNoteLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        ydaView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[ydaLbl(30)]-5-[yesterDayImgView(30)]-(20)-[ydaValLbl(30)]-(5)-[ydaNoteLbl(21)]-(10)-|", options: [], metrics: nil, views: layoutDic))
        
        
        weekView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[weekLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        weekView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[weekValLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        weekView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[weekNoteLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        weekView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[weekLbl(30)]-(10)-[weekValLbl(30)]-(5)-[weekNoteLbl(21)]-(10)-|", options: [], metrics: nil, views: layoutDic))
       
        
        monthView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[monthLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        monthView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[monthValLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        monthView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[monthNoteLbl]-(5)-|", options: [], metrics: nil, views: layoutDic))
        monthView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[monthLbl(30)]-(10)-[monthValLbl(30)]-(5)-[monthNoteLbl(21)]-(10)-|", options: [], metrics: nil, views: layoutDic))
        
        chartBackgroundView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[viewDayMonth]-(10)-|", options: [], metrics: nil, views: layoutDic))
        chartBackgroundView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[chartView]-(10)-|", options: [], metrics: nil, views: layoutDic))
        chartBackgroundView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[viewDayMonth]-(10)-[chartView]-8-|", options: [], metrics: nil, views: layoutDic))
        chartView.heightAnchor.constraint(equalTo: chartView.widthAnchor, multiplier: 0.5).isActive = true
        viewDayMonth.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(5)-[lblDayMonth(120)]-(5)-[vertLine(1)]-5-[btnDownArrow(30)]-(5)-|", options: [], metrics: nil, views: layoutDic))
        viewDayMonth.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblDayMonth(30)]|", options: [], metrics: nil, views: layoutDic))
         viewDayMonth.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(5)-[vertLine(20)]-(5)-|", options: [], metrics: nil, views: layoutDic))
        btnDownArrow.heightAnchor.constraint(equalToConstant: 30).isActive = true
        btnDownArrow.centerYAnchor.constraint(equalTo: viewDayMonth.centerYAnchor, constant: 0).isActive = true
        
        
        chartBackgroundView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[viewTbl(171)]-(10)-|", options: [], metrics: nil, views: layoutDic))
        viewTbl.topAnchor.constraint(equalTo: viewDayMonth.bottomAnchor, constant: 0).isActive = true
        viewTbl.heightAnchor.constraint(equalToConstant: 171).isActive = true
        
        viewTbl.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[tblChooseDayMonth]-(5)-|", options: [], metrics: nil, views: layoutDic))
        viewTbl.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[tblChooseDayMonth]-(5)-|", options: [], metrics: nil, views: layoutDic))

    }
    
    // MARK: Adding graph Counts
    func setDataCount(_ arr: [(key: String, value: Double)]) {

        chartView.xAxis.valueFormatter = IndexAxisValueFormatter(values: arr.map { $0.key })

        let values = arr.enumerated().compactMap { ChartDataEntry(x: Double($0), y: $1.value) }
        let set1 = LineChartDataSet(values: values, label: "DataSet 1")

        set1.mode = .horizontalBezier
        set1.axisDependency = .left
        set1.setColor(UIColor.inkBlue)
        set1.lineWidth = 1.5
        set1.drawCirclesEnabled = false
        set1.drawValuesEnabled = false
        set1.fillAlpha = 0.26
        set1.fillColor = UIColor.inkBlue
        set1.highlightColor = UIColor(red: 244/255, green: 117/255, blue: 117/255, alpha: 1)
        set1.drawCircleHoleEnabled = false
        
        let leftAxis = chartView.leftAxis
        leftAxis.axisMaximum = max(arr.map { $0.value }.max() ?? 0, 50)
        
        let data = LineChartData(dataSet: set1)
        data.setValueTextColor(.secondaryColor)
        data.setValueFont(.systemFont(ofSize: 9, weight: .light))
        
        chartView.data = data
    }
    
    // MARK: Day & Month & Years Button Actions
    
    @objc func openTable(_ sender: UIButton) {
        self.viewTbl.isHidden = false
    }
    
    @objc func dayBtnAction(_ sender: UIButton) {
        [hourlyBtn,dailyBtn,monthlyBtn].forEach() {
            $0.isSelected = false
        }
        sender.isSelected = true
        self.setDataCount(self.hourlyValues)
    }
    
    @objc func weekBtnAction(_ sender: UIButton) {
        [hourlyBtn,dailyBtn,monthlyBtn].forEach() {
            $0.isSelected = false
        }
        sender.isSelected = true
        self.setDataCount(self.dailyValues)
    }
    
    @objc func monthBtnAction(_ sender: UIButton) {
        [hourlyBtn,dailyBtn,monthlyBtn].forEach() {
            $0.isSelected = false
        }
        sender.isSelected = true
        self.setDataCount(self.monthValues)
    }
    
 
}

extension DBBalanceVC: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        return "y"
        if hourlyBtn.isSelected {
            return self.hourlyValues.first(where: { $0.value == value })?.key ?? "ept"
        } else if dailyBtn.isSelected {
            return self.dailyValues[Int(value)].key
        } else if monthlyBtn.isSelected {
            return self.monthValues[Int(value)].key
        }

        return ""
    }
}
extension DBBalanceVC: ChartViewDelegate {
    
}

extension DBBalanceVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dailyEarning.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailycell") ?? UITableViewCell()
        cell.textLabel?.text = self.dailyEarning[indexPath.row].title
        if self.selectedEarning == self.dailyEarning[indexPath.row] {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedEarning = self.dailyEarning[indexPath.row]
        self.lblDayMonth.text = self.dailyEarning[indexPath.row].title
        self.tblChooseDayMonth.reloadData()
        if self.selectedEarning == .hourly {
            self.setDataCount(self.hourlyValues)
        } else if self.selectedEarning == .daily {
            self.setDataCount(self.dailyValues)
        } else if self.selectedEarning == .monthly {
            self.setDataCount(self.monthValues)
        }
        self.viewTbl.isHidden = true
    }
    
}

enum DailyEarning: CaseIterable {
    case hourly
    case daily
    case monthly
    
    var title: String {
        switch self {
        case .hourly:
            return "txt_hourly".localize()
        case.daily:
            return "txt_daily_plain".localize()
        case .monthly:
            return "txt_monthly".localize()
        }
    }
}
