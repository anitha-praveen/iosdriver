//
//  ComplaintsVC.swift
//  Taxiappz Driver
//
//  Created by Apple on 09/09/20.
//  Copyright © 2020 nPlus. All rights reserved.
//
import UIKit
import Alamofire
import NVActivityIndicatorView

class ComplaintsVC: UIViewController {

    let complaintView = ComplaintView()
    
    var selectedComplaintType: Complaint?
    var complaintsList: [Complaint] = []
    var historyRequestId: String?
    
    var textViewPlaceholder = "txt_additional_cmt".localize()
    var layoutDict = [String: AnyObject]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .secondaryColor
        self.navigationController?.navigationBar.isHidden = true
        
        if self.historyRequestId == "" {
            self.getComplaintList()
        } else {
            self.getComplaintList(request: self.historyRequestId)
        }
        self.setUpViews()
        self.setupTarget()
        
    }
    
     // MARK: - Adding UI Elements in SetupViews
    func setUpViews()  {
        complaintView.setupViews(Base: self.view)
        complaintView.tblComplaintList.delegate = self
        complaintView.tblComplaintList.dataSource = self
        complaintView.tblComplaintList.register(ComplaintListCell.self, forCellReuseIdentifier: "complaintReasonCell")
        
        complaintView.complainttxtvw.delegate = self
        complaintView.complainttxtvw.text = self.textViewPlaceholder
    }
    
    func setupTarget() {
       
        complaintView.backBtn.addTarget(self, action: #selector(backBtnAction(_ :)), for: .touchUpInside)
        complaintView.complaintsavebtn.addTarget(self, action: #selector(saveBtnPressed(_ :)), for: .touchUpInside)
        complaintView.complaintsavebtn.addTarget(self, action: #selector(saveBtnPressed(_ :)), for: .touchUpInside)
       
    }
  
    
    @objc func backBtnAction(_ sender: UIButton) {
         self.navigationController?.popViewController(animated: true)
     }


    @objc func saveBtnPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.selectedComplaintType == nil {
            self.showAlert("", message: "txt_complaint_header".localize())
        } else {
            if self.historyRequestId == "" {
                if self.complaintView.complainttxtvw.text == "" || self.complaintView.complainttxtvw.text == textViewPlaceholder {
                    self.showAlert("", message: "txt_comm_empty_alert".localize())
                    
                } else {
                    self.saveComplaint()
                }
                
            } else {
                if self.complaintView.complainttxtvw.text == "" || self.complaintView.complainttxtvw.text == textViewPlaceholder {
                    self.showAlert("", message: "txt_comm_empty_alert".localize())
                } else {
                    self.saveComplaint(request: self.historyRequestId)
                }
            }
            
        }
    }
    
}

//MARK:- API'S
extension ComplaintsVC {
    
    func getComplaintList(request id: String? = nil) {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            var url = ""
            if id != nil {
                 url = APIHelper.shared.BASEURL + APIHelper.getTripComplaintList
            } else {
                 url = APIHelper.shared.BASEURL + APIHelper.getComplaintList
            }
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.authHeader).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any,response.response?.statusCode as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        if let data = result["data"] as? [String:AnyObject] {
                            if let complaintList  = data["complaint"] as? [[String: AnyObject]] {
                                self.complaintsList = complaintList.compactMap({Complaint($0)})
                                
                                self.complaintView.tblComplaintList.reloadData()
                                

                                    self.complaintView.tblComplaintList.heightAnchor.constraint(equalToConstant: self.complaintView.tblComplaintList.contentSize.height).isActive = true
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
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
    }
    
    func saveComplaint(request id: String? = nil) {
        
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            var paramDict = Dictionary<String, Any>()
            
            paramDict["complaint_id"] = selectedComplaintType?.slug
            paramDict["answer"] = self.complaintView.complainttxtvw.text
            if id != nil {
                paramDict["request_id"] = id
            }

            print(paramDict)
            let url = APIHelper.shared.BASEURL + APIHelper.getComplaintAdd
            print(url)
            Alamofire.request(url, method:.post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                self.selectedComplaintType = nil
                              
                                self.complaintView.complainttxtvw.text = ""
                        
                                if let msg = result["message"] as? String {
                                    self.view.showToast(msg)
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
        } else {
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
        
    }
}


//MARK:- TABLE DELEGATES
extension ComplaintsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.complaintsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "complaintReasonCell") as? ComplaintListCell ?? ComplaintListCell()
        cell.cancelReasonLbl.text = self.complaintsList[indexPath.row].title
        
        if self.selectedComplaintType?.slug == self.complaintsList[indexPath.row].slug {
            cell.viewContent.backgroundColor = .themeColor
            cell.cancelReasonLbl.textColor = .themeTxtColor
            cell.checkMark.image = UIImage(named: "ic_tick")
        } else {
            cell.viewContent.backgroundColor = .hexToColor("EAEAEA")
            cell.cancelReasonLbl.textColor = .hexToColor("606060")
            cell.checkMark.image = UIImage(named: "ic_tick_unselect")
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedComplaintType = self.complaintsList[indexPath.row]
        self.complaintView.tblComplaintList.reloadData()
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
}


extension ComplaintsVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == self.textViewPlaceholder {
            textView.text = ""
            textView.textColor = UIColor.txtColor
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = self.textViewPlaceholder
            textView.textColor = .gray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            textView.resignFirstResponder()
            return false
        }
        let newText = (self.complaintView.complainttxtvw.text as NSString).replacingCharacters(in: range, with: text)
        return newText.count < 200
    }
    
}

