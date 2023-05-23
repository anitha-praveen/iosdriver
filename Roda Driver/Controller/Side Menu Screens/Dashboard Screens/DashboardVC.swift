//
//  DashboardVC.swift
//  Captain Car
//
//  Created by Spextrum on 04/07/19.sc
//  Copyright © 2019 nPlus. All rights reserved.
//

import UIKit
import Alamofire

class DashboardVC: UIViewController {

    var response: [String: Any]?//Trip details from push notification on app launch by pressing push notification
    let backBtn = UIButton()

    let titleView = UIView()
    let titleLbl = UILabel()

    let scrollView = UIScrollView()
    let stackView = UIStackView()
    let balanceBtn = UIButton(type: .custom), historyBtn = UIButton(type: .custom), finesBtn = UIButton(type: .custom)
    let underlineLayer = CALayer()
    var currentLayoutDirection = APIHelper.appLanguageDirection//TO REDRAW VIEWS IF DIRECTION IS CHANGED
    
    var fine = ""
    var dashboardData = [String: AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        getDashboardDetails()
        self.navigationController?.navigationBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    // MARK: Adding new UI elements in setupViews
    func setupViews() {
        var layoutDic = [String: Any]()
        
        view.backgroundColor = .secondaryColor
        
        let contentView = UIView()//RoundedShadowView()
        contentView.backgroundColor = .secondaryColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["contentView"] = contentView
        view.addSubview(contentView)
        
        backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
        backBtn.contentMode = .scaleAspectFit
        backBtn.setAppImage("backDark")
        backBtn.layer.cornerRadius = 20
        backBtn.addShadow()
        backBtn.backgroundColor = .secondaryColor
        layoutDic["backBtn"] = backBtn
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(backBtn)
      
        
        titleView.backgroundColor = .secondaryColor
        titleView.layer.cornerRadius = 8
        titleView.addShadow()
        layoutDic["titleView"] = titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(titleView)
        
        titleLbl.text = "txt_dashboard".localize()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDic["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
        
       
        
        scrollView.delegate = self
        scrollView.isPagingEnabled = true
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        layoutDic["scrollView"] = scrollView
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(scrollView)
        
        let scrollContentView = UIView()
        scrollContentView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["scrollContentView"] = scrollContentView
        scrollView.addSubview(scrollContentView)
        
        stackView.addBorder(edges: .bottom, colour: .hexToColor("979797"), thickness: 0.5)
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["stackView"] = stackView
        contentView.addSubview(stackView)
        
        balanceBtn.addTarget(self, action: #selector(scrollToChildVC(_:)), for: .touchUpInside)
        balanceBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 14)
        balanceBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        balanceBtn.titleLabel?.minimumScaleFactor = 0.1
        balanceBtn.setTitleColor(.hexToColor("ACB1C0"), for: .normal)
        balanceBtn.setTitleColor(UIColor.themeColor, for: .selected)
        balanceBtn.setTitle("txt_earnings".localize().uppercased(), for: .normal)
        balanceBtn.sizeToFit()
        stackView.addArrangedSubview(balanceBtn)
        
        historyBtn.addTarget(self, action: #selector(scrollToChildVC(_:)), for: .touchUpInside)
        historyBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 14)
        historyBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        historyBtn.titleLabel?.minimumScaleFactor = 0.1
        historyBtn.setTitleColor(.hexToColor("ACB1C0"), for: .normal)
        historyBtn.setTitleColor(UIColor.themeColor, for: .selected)
        historyBtn.setTitle("txt_history".localize().uppercased(), for: .normal)
        historyBtn.sizeToFit()
        stackView.addArrangedSubview(historyBtn)
        
      /*  rateBtn.isHidden = true
        rateBtn.addTarget(self, action: #selector(scrollToChildVC(_:)), for: .touchUpInside)
        rateBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 12)
        rateBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        rateBtn.titleLabel?.minimumScaleFactor = 0.1
        rateBtn.setTitleColor(.hexToColor("ACB1C0"), for: .normal)
        rateBtn.setTitleColor(UIColor.themeColor, for: .selected)
        rateBtn.setTitle("text_rate_reward".localize(), for: .normal)
        rateBtn.sizeToFit()
        stackView.addArrangedSubview(rateBtn) */
        
        finesBtn.addTarget(self, action: #selector(scrollToChildVC(_:)), for: .touchUpInside)
        finesBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 14)
        finesBtn.titleLabel?.adjustsFontSizeToFitWidth = true
        finesBtn.titleLabel?.minimumScaleFactor = 0.1
        finesBtn.setTitleColor(.hexToColor("ACB1C0"), for: .normal)
        finesBtn.setTitleColor(UIColor.themeColor, for: .selected)
        finesBtn.setTitle("text_balance".localize().uppercased(), for: .normal)
        finesBtn.sizeToFit()
        stackView.addArrangedSubview(finesBtn)
        
        let balanceVC = DBBalanceVC()
        balanceVC.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(balanceVC)
        scrollContentView.addSubview(balanceVC.view)
        balanceVC.didMove(toParent: self)
        layoutDic["balanceVC"] = balanceVC.view
        
        let historyVC = DBHistoryVC()
        historyVC.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(historyVC)
        scrollContentView.addSubview(historyVC.view)
        historyVC.didMove(toParent: self)
        layoutDic["historyVC"] = historyVC.view

       /* let rateRewardVC = DBRateRewardVC()
        rateRewardVC.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(rateRewardVC)
        scrollContentView.addSubview(rateRewardVC.view)
        rateRewardVC.didMove(toParent: self)
        layoutDic["rateRewardVC"] = rateRewardVC.view */
        
        let finesVC = DBFineVC()
        finesVC.view.translatesAutoresizingMaskIntoConstraints = false
        addChild(finesVC)
        scrollContentView.addSubview(finesVC.view)
        finesVC.didMove(toParent: self)
        layoutDic["finesVC"] = finesVC.view
        
       
            contentView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
            contentView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true
       
        view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: [], metrics: nil, views: layoutDic))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: layoutDic))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(10)-[stackView]-(10)-|", options: [], metrics: nil, views: layoutDic))
        
       
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(40)]-15-[titleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        backBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[titleView]-16-[stackView][scrollView]|", options: [], metrics: nil, views: layoutDic))

        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollContentView]|", options: [], metrics: nil, views: layoutDic))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[scrollContentView]|", options: [], metrics: nil, views: layoutDic))
        scrollContentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor).isActive = true
        let width = scrollContentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        width.priority = .defaultLow
        width.isActive = true
        
        balanceVC.view.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        scrollContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[balanceVC][historyVC(==balanceVC)][finesVC(==balanceVC)]|", options: [APIHelper.appLanguageDirection, .alignAllTop, .alignAllBottom], metrics: nil, views: layoutDic))
        scrollContentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[balanceVC]|", options: [], metrics: nil, views: layoutDic))
        
        underlineLayer.backgroundColor = UIColor.themeColor.cgColor
        stackView.layer.addSublayer(underlineLayer)
        
        if fine == "New Fine" {
            scrollToChildVC(finesBtn)
        } else {
            scrollToChildVC(balanceBtn)
        }
        
        
    }
    
    @objc func backBtnAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK:ScrollToChild ViewControllers
    @objc func scrollToChildVC(_ sender: UIButton) {
        underlineLayer.frame = CGRect(x: sender.frame.minX, y: sender.bounds.height-3, width: sender.bounds.width, height: 3)
        [balanceBtn,historyBtn,finesBtn].forEach {
            $0.isSelected = $0 == sender
        }
        if let index = stackView.arrangedSubviews.firstIndex(where: {
            if let button = $0 as? UIButton, button == sender {
                NotificationCenter.default.post(name: NSNotification.Name("dashboardData"), object: self.dashboardData)
                return true
            } else {
                return false
            }
        }) {
            scrollView.setContentOffset(CGPoint(x: CGFloat(index)*scrollView.bounds.width, y: 0), animated: true)
            NotificationCenter.default.post(name: NSNotification.Name("dashboardData"), object: self.dashboardData)
        }
    }
}

// MARK: ScrollView delegates
extension DashboardVC: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let index = Int(scrollView.contentOffset.x/scrollView.bounds.width)
        [balanceBtn,historyBtn,finesBtn].enumerated().forEach {
            if $0 == index {
                underlineLayer.frame = CGRect(x: $1.frame.minX, y: $1.bounds.height-3, width: $1.bounds.width, height: 3)
                $1.isSelected = true
                NotificationCenter.default.post(name: NSNotification.Name("dashboardData"), object: self.dashboardData)
            } else {
                $1.isSelected = false
            }
        }
    }
}
// MARK: ScrollView delegates
extension DashboardVC {
    func getDashboardDetails() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show()
            let url = APIHelper.shared.BASEURL + APIHelper.dashBoard
            let paramdict = Dictionary<String, Any>()
            
            print("URL & Parameters for Dashboard API =",url,paramdict)
            
            Alamofire.request(url, method: .get, parameters: paramdict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print("Response for Dashboard", response.result.value as Any)
                    print("Response for Dashboard Status Code", response.response?.statusCode as Any)

                    if let result = response.result.value as? [String:AnyObject] {
                        if response.response?.statusCode == 200 {
                            if let data = result["data"] as? [String: AnyObject] {
                                self.dashboardData = data
                                NotificationCenter.default.post(name: NSNotification.Name("dashboardData"), object: self.dashboardData)
                              //  self.dashboarddata = data.compactMap { DashboardData($0) }
                            }
                            
                        } else {
                            if let errcodestr = result["error_code"] as? String, errcodestr == "606" || errcodestr == "609" {
                                LocalDB.shared.deleteUser()
                            }
                        }
                    }
                }
        } else {
            print("disConnected")
            self.showAlert("txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
        }
    }
}


