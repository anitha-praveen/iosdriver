//
//  FAQVC.swift
//  Taxiappz Driver
//
//  Created by Ram kumar on 13/08/20.
//  Copyright © 2020 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class FAQVC: UIViewController {
    
    let faqView = FAQView()
    
    var faqList = [FAQ]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .secondaryColor
        self.navigationController?.navigationBar.isHidden = true
        getFAQList()
        setupViews()
        setupTarget()
    }
    
    func setupViews() {
        faqView.setupViews(Base: self.view)
    }
    
    func setupTarget() {
        faqView.faqTb.delegate = self
        faqView.faqTb.dataSource = self
        faqView.faqTb.register(FAQCell.self, forCellReuseIdentifier: "FAQCell")
        faqView.backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
        
    }
    @objc func backBtnAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
}

extension FAQVC: UITableViewDelegate, UITableViewDataSource {
// MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return faqList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "FAQCell") as? FAQCell ?? FAQCell()

        cell.selectionStyle = .none
        cell.questionLbl.text = faqList[indexPath.row].question
        cell.answerLbl.isHidden = !faqList[indexPath.row].isExpanded
        if !faqList[indexPath.row].isExpanded {
            cell.expandBtn.setImage(UIImage(named: "downArrowLight"), for:.normal)
        } else {
            cell.expandBtn.setImage(UIImage(named: "upArrow"), for:.normal)
        }
        cell.expandBtn.tag = indexPath.row
        cell.expandBtn.addTarget(self, action: #selector(expandBtnAction(_:)), for: .touchUpInside)
        cell.answerLbl.text = faqList[indexPath.row].answer
        return cell
    }
    
    @objc func expandBtnAction(_ sender: UIButton) {
        var selectedFaq = self.faqList[sender.tag]
        selectedFaq.isExpanded = !selectedFaq.isExpanded
        self.faqList[sender.tag] = selectedFaq
        self.faqView.faqTb.reloadData()
    }
}

extension FAQVC {
    // MARK: - Getting FAQ List
    func getFAQList() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            let url = APIHelper.shared.BASEURL + APIHelper.getFAQList
            print("Url and Header",url,APIHelper.shared.authHeader)
            
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any,response.response?.statusCode as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        if let data = result["data"] as? [String:AnyObject] {
                            if let faqList  = data["faq"] as? [[String: AnyObject]] {
                                self.faqList = faqList.compactMap({ FAQ($0) })
                                DispatchQueue.main.async {
                                    self.faqView.faqTb.reloadData()
                                }
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
        } else {
            print("disConnected")
            self.showAlert("txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
        }
    }
}

