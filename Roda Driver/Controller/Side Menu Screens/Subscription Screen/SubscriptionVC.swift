//
//  SubscriptionVC.swift
//  Taxiappz Driver
//
//  Created by Apple on 04/03/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher

class SubscriptionVC: UIViewController {

    let subscriptionView = SubscriptionView()
    
    var subscriptionList = [SubscriptionList]()
    var currency = ""
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        getSubscriptionList()
    }
    
    func setupViews() {
        subscriptionView.setupViews(Base:self.view)
        subscriptionView.tblView.delegate = self
        subscriptionView.tblView.dataSource = self
        subscriptionView.tblView.register(HeaderTableView.self, forHeaderFooterViewReuseIdentifier: "headercell")
        
    }
   
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

    override func viewWillAppear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = .themeColor
    }
    override func viewWillDisappear(_ animated: Bool) {
        UIApplication.shared.statusBarView?.backgroundColor = .clear
    }
}

extension SubscriptionVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.subscriptionList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "subscriptioncell") as? SubscriptionCell ?? SubscriptionCell()
        
        cell.lblName.setTitle(self.subscriptionList[indexPath.row].name?.uppercased(), for: .normal)
      
        cell.lblDescription.text = self.subscriptionList[indexPath.row].description
        cell.lblAmount.text = self.currency + " " + (self.subscriptionList[indexPath.row].amount ?? "")

        let attributedString = NSMutableAttributedString(string: self.subscriptionList[indexPath.row].validity ?? "")
        let foundRange = attributedString.mutableString.range(of: "txt_days".localize())
        attributedString.addAttribute(NSAttributedString.Key.font, value: UIFont.appSemiBold(ofSize: 14), range: foundRange)
        
        cell.lblValidity.attributedText = attributedString
        
        cell.subscribeAction = {[weak self] in
            self?.requestSubscribe(self?.subscriptionList[indexPath.row].slug ?? "")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = tableView.dequeueReusableHeaderFooterView(withIdentifier:
                       "headercell") as? HeaderTableView ?? HeaderTableView()
        if let imgStr = LocalDB.shared.driverDetails?.profilePictureUrl, let url = URL(string: imgStr) {
            let resource = ImageResource(downloadURL: url)
            view.userImgView.kf.setImage(with: resource)
        }
        if let name = LocalDB.shared.driverDetails?.firstName {
            view.lblName.text = name
        }
        view.backBtn.addTarget(self, action: #selector(backBtnPressed(_ :)), for: .touchUpInside)
        return view
    }
    
}

//MARK: API'S

extension SubscriptionVC {
    func getSubscriptionList() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show()
            let url = APIHelper.shared.BASEURL + APIHelper.getSubscriptionList
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                DispatchQueue.main
                    .asyncAfter(deadline: .now() + 5, execute: {
                        NKActivityLoader.sharedInstance.hide()
                    })
                switch response.result {
                case .success(_):
                    print(response.result.value as Any)
                    if let result = response.result.value as? [String: AnyObject] {
                        if response.response?.statusCode == 200 {
                            if let data = result["data"] as? [String: AnyObject] {
                                if let currency = data["currency_symbol"] as? String {
                                    self.currency = currency
                                }
                                if let list = data["subscription"] as? [[String: AnyObject]] {
                                    self.subscriptionList = list.compactMap({SubscriptionList($0)})
                                    DispatchQueue.main.async {
                                        self.subscriptionView.tblView.reloadData()
                                    }
                                }
                            }
                        }
                    }
                case .failure(let error):
                    self.view.showToast(error.localizedDescription)
                }
            
            }
        }
    }
    
    
    func requestSubscribe(_ id:String) {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            var paramDict = Dictionary<String,Any>()
            paramDict["subscription_id"] = id
            
            let url = APIHelper.shared.BASEURL + APIHelper.subscribeRequest
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                switch response.result {
                case .success(_):
                    print(response.result.value as Any)
                    if let result = response.result.value as? [String: AnyObject] {
                        if response.response?.statusCode == 200 {
                            if let data = result["data"] as? [String: AnyObject] {
                                
                            }
                        }
                    }
                case .failure(let error):
                    self.view.showToast(error.localizedDescription)
                }
            
            }
        }
    }
}
