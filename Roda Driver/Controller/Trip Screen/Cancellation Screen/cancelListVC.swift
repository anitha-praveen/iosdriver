//
//  cancelListVC.swift
//  Taxiappz Driver
//
//  Created by Apple on 02/02/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import CoreLocation
class cancelListVC: UIViewController {
    
    let cancelListView = CancelListView()

    var requestId = String()
    var otherReason = ""
    
    var delegate: CancelDetailsViewDelegate?
    
    var cancelReasonList = [CancellationList]()
    var selectedCancelReason: CancellationList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.isHidden = true

        setupViews()
        self.showCancelReasonList()
        setupTarget()
  
    }
    
    func setupViews()  {
        cancelListView.setupViews(Base: self.view)
    }
    
    func setupTarget() {
        cancelListView.tableView.delegate = self
        cancelListView.tableView.dataSource = self
        cancelListView.tableView.register(CancelListCell.self, forCellReuseIdentifier: "CancelListCell")

        cancelListView.keepBookingBtn.addTarget(self, action: #selector(keepBookingBtnAction(_ :)), for: .touchUpInside)
        cancelListView.cancelBtn.addTarget(self, action: #selector(cancelBtnAction(_ :)), for: .touchUpInside)
    }
    
    
    func showCancelReasonList() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            let url = APIHelper.shared.BASEURL + APIHelper.getCancellationReason
            var paramDict = Dictionary<String, Any>()
            
            paramDict["request_id"] = self.requestId
           
            print("params for cancelReasonList =",paramDict,url)
            
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { (response) in
                    NKActivityLoader.sharedInstance.hide()
                    switch response.result {
                    case .failure(let error):
                        self.view.showToast(error.localizedDescription)
                        print(error.localizedDescription)
                    case .success(_):
                        print(response.result.value as Any,response.response?.statusCode as Any)
                        if let result = response.result.value as? [String: AnyObject] {
                            if let statusCode = response.response?.statusCode, statusCode == 200 {
                                if let data = result["data"] as? [String:AnyObject] {
                                    if let cancelData = data["reasons"] as? [[String: AnyObject]] {
                                        self.cancelReasonList = cancelData.compactMap({CancellationList($0)})
                                        if self.cancelReasonList.count == 0 {
                                            self.view.showToast("txt_cannot_cancel_right_now".localize())
                                        } else {
                                            DispatchQueue.main.async {
                                                self.cancelListView.tableView.reloadData()
                                                
                                                self.cancelListView.tableView.heightAnchor.constraint(equalToConstant: self.cancelListView.tableView.contentSize.height).isActive = true
                                            }
                                        }
                                    }
                                }
                            } else {
                                self.view.showToast("txt_cannot_cancel_right_now".localize())
                            }
                        }
                    }
                }
        } else {
            self.view.showToast("txt_NoInternet".localize())
        }
    }
    

    func cancelTheRide() {
        if ConnectionCheck.isConnectedToNetwork() {
            guard let currentLoc = AppLocationManager.shared.locationManager.location else {
                self.showAlert("", message: "txt_location_not_found".localize())
                return
            }
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            let coord = CLLocationCoordinate2D(latitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude)
            self.getaddress(coord) { (location) in
                var paramDict = Dictionary<String, Any>()
                paramDict["request_id"] = self.requestId
                paramDict["reason"] = self.selectedCancelReason?.id
                paramDict["driver_latitude"] = currentLoc.coordinate.latitude
                paramDict["driver_longitude"] = currentLoc.coordinate.longitude
                paramDict["driver_location"] = location
//              paramDict["cancel_other_reason"] = self.selectedCancelReason?.id == 0 ? self.otherReason : ""

                let url = APIHelper.shared.BASEURL + APIHelper.cancelTrip
                
                print("Cancel Trip Url and Param",url,paramDict)
                Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                    .responseJSON { response in
                        NKActivityLoader.sharedInstance.hide()
                        switch response.result {
                        case .failure(let error):
                            self.view.showToast(error.localizedDescription)
                            print("FAILURE",error.localizedDescription)
                        case .success(_):
                            
                            print("RESPONSE",response.result.value as AnyObject)
                            if let result = response.result.value as? [String: AnyObject] {
                                if let statusCode = response.response?.statusCode, statusCode == 200 {
                                    print("CANCELLED")
                                    self.dismiss(animated: true) {
                                        self.delegate?.tripCancelled("Trip Cancelled")
                                    }
                                } else {
                                    print("ERROR")
                                    if let errmsg = result["error_message"] as? String {
                                        self.view.showToast(errmsg)
                                    } else if let msg = result["message"] as? String {
                                        self.view.showToast(msg)
                                    }
                                    
                                }
                            }
                        }
                    }
            }
        } else {
            self.view.showToast("txt_NoInternet".localize())
        }
    }
    
    @objc func cancelBtnAction(_ sender: UIButton) { // cancel button action
        if let id = self.selectedCancelReason?.id, id == 0, otherReason.isEmpty {
            self.view.showToast("text_reason_validation")
        }
        else if self.selectedCancelReason != nil {
            cancelTheRide()
        } else {
            self.view.showToast("hint_add_reason_for_cancel".localize())
        }
    }
    
    @objc func keepBookingBtnAction(_ sender: UIButton) {
        self.dismiss(animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, let touchedView = touch.view {
            if touchedView == self.view {
                self.view.endEditing(true)
                self.dismiss(animated: false, completion: nil)
            } else {
                self.view.endEditing(true)
            }
        }
    }
}

extension cancelListVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.cancelReasonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CancelListCell") as? CancelListCell ?? CancelListCell()
        cell.selectionStyle = .none

        cell.cancelReasonLbl.text = self.cancelReasonList[indexPath.row].reason
       
        if self.cancelReasonList[indexPath.row].id == self.selectedCancelReason?.id {
            cell.viewContent.backgroundColor = .themeColor
            cell.checkMark.image = UIImage(named: "ic_tick")
        } else {
            cell.viewContent.backgroundColor = .hexToColor("EAEAEA")
            cell.checkMark.image = UIImage(named: "ic_tick_unselect")
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCancelReason = cancelReasonList[indexPath.row]
        self.cancelListView.tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}


