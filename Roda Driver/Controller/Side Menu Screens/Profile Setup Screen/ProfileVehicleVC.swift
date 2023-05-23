//  ProfileVehicleVC.swift
//  Taxiappz Driver
//
//  Created by Ram kumar on 30/07/20.
//  Copyright © 2020 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView

class ProfileVehicleVC: UIViewController {

    let vehicleDetailView = ProfileVehicleDetailView()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getProfile()
        self.setupViews()
    }
    
    func setupViews()  {
        vehicleDetailView.setupViews(Base: self.view)
        vehicleDetailView.backBtn.addTarget(self, action: #selector(backBtnAction(_:)), for: .touchUpInside)
    }
    @objc func backBtnAction(_ sender: UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupData(_ details: [String: AnyObject]) {
        
        if let type = details["vehicle_type"] as? String {
            self.vehicleDetailView.txtVehicleType.text = type.uppercased()
        }
        if let number = details["car_number"] as? String {
            self.vehicleDetailView.txtVehicleNumber.text = number.uppercased()
        }
        if let model = details["car_model"] as? String {
            self.vehicleDetailView.txtVehicleModel.text = model.uppercased()
        }
        if let zoneName = details["zone_name"] as? String {
            self.vehicleDetailView.txtZone.text = zoneName.uppercased()
        }
    }
    
}

//MARK:- API'S
extension ProfileVehicleVC {
    
    func getProfile() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            let url = APIHelper.shared.BASEURL + APIHelper.getDriverProfile
            var paramdict = Dictionary<String, Any>()
          
            print("URL & Parameters for Vehicle Get =",url,paramdict)
            
            Alamofire.request(url, method:.post, parameters: paramdict, encoding: JSONEncoding.default, headers:APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let data = result["data"] as? [String: AnyObject] {
                                    if let driver = data["user"] as? [String:AnyObject] {
                                        if let carDetails = driver["car_details"] as? [String: AnyObject] {
                                            self.setupData(carDetails)
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
        } else {
            self.showAlert("txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
        }
    }
}
