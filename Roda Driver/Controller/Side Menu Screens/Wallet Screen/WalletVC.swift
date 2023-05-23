//
//  WalletVC.swift
//  Taxiappz Driver
//
//  Created by Apple on 21/02/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import UIKit
import Alamofire

class WalletVC: UIViewController {
    
    let walletView = WalletView()
    var currency = ""
    var walletHistory = [WalletHistory]()
    var dummyWallet = [DummyWallet]()
    
    var previousRequestID = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        getWalletDetail()
        setupViews()
        setupTarget()
    }
    
    func setupViews() {
        walletView.setupViews(Base: self.view)
    }
   

    func setupTarget() {
        walletView.tableView.delegate = self
        walletView.tableView.dataSource = self
        walletView.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "datacell")
      //  walletView.moneyTfd.delegate = self
        walletView.backBtn.addTarget(self, action: #selector(backBtnPressed(_ :)), for: .touchUpInside)
        walletView.btn1.addTarget(self, action: #selector(AmtBtnPressed(_ :)), for: .touchUpInside)
        walletView.btn2.addTarget(self, action: #selector(AmtBtnPressed(_ :)), for: .touchUpInside)
        walletView.addamtbtn.addTarget(self, action: #selector(btnAddAmountPressed(_ :)), for: .touchUpInside)

    }
}

//MARK:- TARGET ACTIONS
extension WalletVC {
    
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupText() {
        self.walletView.currencyView.text = self.currency
        self.walletView.btn1.setTitle(self.currency + " 500", for: .normal)
        self.walletView.btn2.setTitle(self.currency + " 1000", for: .normal)
    }
    
    @objc func AmtBtnPressed(_ sender: UIButton) {
        if sender == walletView.btn1 {
            self.walletView.moneyTfd.text = "500"
        } else if sender == walletView.btn2 {
            self.walletView.moneyTfd.text = "1000"
        }
    }
    
    @objc func btnAddAmountPressed(_ sender: UIButton) {
        if self.walletView.moneyTfd.text == "" {
            self.showAlert("", message: "txt_enter_amount".localize())
        } else {
            self.addMoneyWallet()
        }
    }
}

//MARK:- API'S
extension WalletVC {
    
    func getWalletDetail() {
        NKActivityLoader.sharedInstance.show()
        let url = APIHelper.shared.BASEURL + APIHelper.getWalletAmount // wallet Api need
        print("Wallet Get Amount API",url)
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
            NKActivityLoader.sharedInstance.hide()
            switch response.result {
            case .failure(let error):
                self.showAlert(APIHelper.shared.appName, message: error.localizedDescription)
            case .success(_):
                print(response.result.value as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if response.response?.statusCode == 200 {
                        if let data = result["data"] as? [String: AnyObject] {
                            if let currency = data["currency"] as? String, let total = data["total_amount"] {
                                self.currency = currency
                                self.walletView.lblTotalAmount.text = self.currency + " " + "\(total)"
                                self.setupText()
                            }
                            if let walletTransaction = data["wallet_transaction"] as? [[String: AnyObject]] {
                                self.walletHistory = walletTransaction.compactMap { WalletHistory($0) }
                                
                                self.getDummyData()
                            
                            }
                        }
                    } else {
                        if let error = result["data"] as? [String:[String]] {
                            let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                            self.showAlert("", message: errMsg)
                        } else if let errMsg = result["error_message"] as? String {
                            self.showAlert("", message: errMsg)
                        } else if let msg = result["message"] as? String {
                            self.showAlert("", message: msg)
                        }
                    }
                }
            }
        }
    }
    
    func getDummyData() {
        for data in walletHistory {
            if previousRequestID == data.requestId {
                if let reqId = self.dummyWallet.firstIndex(where: {$0.id == data.requestId}) {
                    self.dummyWallet[reqId].dummyData?.append(ChildData(amount: data.amount ?? "", purpose: data.purpose ?? ""))
                }
            } else {
                self.dummyWallet.append(DummyWallet(name: data.type ?? "", data: [ChildData(amount: data.amount ?? "", purpose: data.purpose ?? "")], id: data.requestId ?? "", date: data.dateStr ?? ""))
                previousRequestID = data.requestId ?? ""
            }
        }
        self.walletView.tableView.reloadData()
        
    }
    
   
    func addMoneyWallet() {
        NKActivityLoader.sharedInstance.show()
        var paramDict = Dictionary<String, Any>()
        paramDict["amount"] = self.walletView.moneyTfd.text
        paramDict["purpose"] = "test ram"
        
        let url = APIHelper.shared.BASEURL + APIHelper.addWalletAmount
        print("Add Wallet Amount API",url,paramDict)

        Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { (response) in
            NKActivityLoader.sharedInstance.hide()
            switch response.result {
            case .failure(let error):
                self.showAlert(APIHelper.shared.appName, message: error.localizedDescription)
            case .success(_):
                print(response.result.value as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if response.response?.statusCode == 200 {
                        if let data = result["data"] as? [String: AnyObject] {
                            self.walletView.moneyTfd.text = ""
                            self.getWalletDetail()
//                            if let wallet = data["wallet"] as? [String: AnyObject] {
//                                if let totalAmount = wallet["balance_amount"] {
//                                    self.walletView.lblTotalAmount.text = self.currency + " " + "\(totalAmount)"
//                                }
//                            }
                        }
                    } else {
                        if let error = result["data"] as? [String:[String]] {
                            let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                            self.showAlert("", message: errMsg)
                        } else if let errMsg = result["error_message"] as? String {
                            self.showAlert("", message: errMsg)
                        } else if let msg = result["message"] as? String {
                            self.showAlert("", message: msg)
                        }
                    }
                }
            }
        }
    }
}
extension WalletVC: UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.dummyWallet.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dummyWallet[section].dummyData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "datacell") ?? UITableViewCell()
        cell.selectionStyle = .none
        let data = self.dummyWallet[indexPath.section].dummyData?[indexPath.row]
        let num = Double(data?.amount ?? "")
        let amt = Double(round(1000 * (num ?? 0)) / 1000)
        cell.textLabel?.text = (data?.purpose ?? "") + "  :" + "\(amt)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerview = UIView()
        headerview.backgroundColor = UIColor.hexToColor("f9f9f9")//.withAlphaComponent(0.6)
        let title = UILabel()
        title.textColor = .txtColor
        title.font = UIFont.appSemiBold(ofSize: 18)
        title.text = (self.dummyWallet[section].name ?? "")
        title.translatesAutoresizingMaskIntoConstraints = false
        headerview.addSubview(title)
        
        let dateLbl = UILabel()
        dateLbl.textColor = .gray
        dateLbl.font = UIFont.appRegularFont(ofSize: 14)
        dateLbl.text = (self.dummyWallet[section].date ?? "")
        dateLbl.translatesAutoresizingMaskIntoConstraints = false
        headerview.addSubview(dateLbl)
        
        headerview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[title]", options: [], metrics: nil, views: ["title":title,"dateLbl":dateLbl]))
        
        headerview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[dateLbl]-10-|", options: [], metrics: nil, views: ["title":title,"dateLbl":dateLbl]))
        
        headerview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[title(30)]|", options: [], metrics: nil, views: ["title":title,"dateLbl":dateLbl]))
        
        dateLbl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        dateLbl.centerYAnchor.constraint(equalTo: headerview.centerYAnchor, constant: 0).isActive = true
        
        return headerview
    }
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
   
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.dummyWallet[indexPath.section].id != "" {
            let vc = HistoryDetailsVC()
            vc.selectedRequestId = self.dummyWallet[indexPath.section].id
            self.navigationController?.pushViewController(vc, animated: true)
        } else {
            print("Wallet amount added")
        }
        
    }
}
//MARK:- TEXTFIELD DELEGATES

extension WalletVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let maxLength = 5
        let currentString: NSString = self.walletView.moneyTfd.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString

        return newString.length <= maxLength
    }
}

