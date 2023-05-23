//
//  ManageDocumentVC.swift
//  Taxiappz Driver
//
//  Created by NPlus Technologies on 07/01/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import SWRevealViewController
class ManageDocumentVC: UIViewController {

    let manageDocumentsView = ManageDocumentView()
    
    var documentList = [DocumentList]()
    var isFromRegister = false
    var isFromHome = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.isFromRegister || self.isFromHome {
            self.manageDocumentsView.btnBack.isHidden = true
        }

        self.setupViews()
        self.getDocumentList()
        self.setupTarget()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupViews() {
        manageDocumentsView.setupViews(Base: self.view)
    }
    
    func setupTarget() {
        
        manageDocumentsView.tableView.delegate = self
        manageDocumentsView.tableView.dataSource = self
        manageDocumentsView.tableView.register(ManageDocumentCell.self, forCellReuseIdentifier: "ManageDocumentCell")
        manageDocumentsView.btnBack.addTarget(self, action: #selector(btnBackPressed(_ :)), for: .touchUpInside)
        manageDocumentsView.btnUploadDoc.addTarget(self, action: #selector(btnSubmitPressed(_ :)), for: .touchUpInside)
        
    }
    @objc func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnSubmitPressed(_ sender: UIButton) {
        if self.isFromRegister {
            self.redirect()
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func redirect() {
       // AppLocationManager.shared.startTracking()
        MySocketManager.shared.establishConnection()
        
        let swRevealViewController = SWRevealViewController()
        swRevealViewController.navigationItem.hidesBackButton = true
        swRevealViewController.modalPresentationStyle = .fullScreen
        swRevealViewController.panGestureRecognizer().isEnabled = false
        
        swRevealViewController.frontViewController = UINavigationController(rootViewController: OnlineOfflineVC())
        
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            swRevealViewController.rearViewController = SideMenuVC()
            swRevealViewController.rightViewController = nil
        } else {
            swRevealViewController.rearViewController = nil
            swRevealViewController.rightViewController = SideMenuVC()
        }
        
        self.navigationController?.present(swRevealViewController, animated: true, completion: nil)
    }
}

// MARK: UITableViewDelegate, UITableViewDataSource
extension ManageDocumentVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return documentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ManageDocumentCell", for: indexPath) as? ManageDocumentCell ?? ManageDocumentCell()        

        let data = self.documentList[indexPath.row]
        if documentList[indexPath.row].uploadStatus == false {
            cell.addDocBtn.setImage(UIImage(named:"Add"), for: .normal)

        } else {
            cell.addDocBtn.setImage(UIImage(named:"Right"), for: .normal)

        }
        
        cell.docNameLbl.text = data.documentName
        
//        if documentList[indexPath.row].requried ?? false {
//
//            cell.requiredFieldLabel.isHidden = false
//        } else {
//            cell.requiredFieldLabel.isHidden = true
//        }
//
        if data.subDocument?.filter({$0.expired ?? false}).count ?? 0 > 0 {
            cell.expairedLabel.isHidden = false
        }
        
        cell.addDocBtn.tag = indexPath.row
        cell.addDocBtn.addTarget(self, action: #selector(addDocBtnAction(_:)), for: .touchUpInside)
        
        if data.subDocument?.filter({$0.requried ?? false}).count ?? 0 > 0 {
            cell.requiredFieldLabel.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("indexPath")
        let vc = UploadDocumentsVC()
        vc.docDetail = documentList[indexPath.row]
        vc.callBack = {[unowned self] uploaded in
            if uploaded {
                self.getDocumentList()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func addDocBtnAction(_ sender: UIButton) {
        let vc = UploadDocumentsVC()
        vc.docDetail = documentList[sender.tag]
        vc.callBack = {[unowned self] uploaded in
            if uploaded {
                self.getDocumentList()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension ManageDocumentVC {
    func getDocumentList() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())

            let url = APIHelper.shared.BASEURL + APIHelper.getDocumentList
            print("Url ", url , APIHelper.shared.authHeader)
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let data = result["data"] as? [String: AnyObject] {
                                    
                                    if let documentList = data["document"] as? [[String:AnyObject]] {
                                        self.documentList = documentList.compactMap({DocumentList($0)})
                                        
                                        DispatchQueue.main.async {
                                            if self.documentList.count == 0 {
                                                self.manageDocumentsView.tableView.isHidden = true
                                                self.manageDocumentsView.noDocLbl.isHidden = false
                                            } else {
                                                self.manageDocumentsView.noDocLbl.isHidden = true
                                                self.manageDocumentsView.tableView.isHidden = false
                                                self.manageDocumentsView.tableView.reloadData()
                                                
                                                

                                                if let allDocsUploaded = data["all_documents_upload"] as? Bool, allDocsUploaded {
                                                    self.manageDocumentsView.btnUploadDoc.isHidden = false
                                                } else {
                                                    self.manageDocumentsView.btnUploadDoc.isHidden = true
                                                }
                                                
                                            }
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
                }
        }
    }
}
