//
//  VerificationVC.swift
//  Taxiappz Driver
//
//  Created by spextrum on 22/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import SWRevealViewController
import FirebaseAuth
import FirebaseDatabase




class VerificationVC: UIViewController {

    private let verificationView = VerificationView()
    

    private var textFields:[UITextField] = []
    var selectedCountry: CountryList?
    var givenPhoneNumber:String?
    
    var mobileNumChange = Bool()
   
    private var seconds = 60
    private var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupViews()
        self.setupData()
        self.runTimer()

    }
    
    func setupViews() {
        verificationView.setupViews(Base: self.view)
        self.setupTarget()
    }
    
    func setupTarget() {
        verificationView.btnBack.addTarget(self, action: #selector(btnBackPressed(_ :)), for: .touchUpInside)
        verificationView.verifyotpBtn.addTarget(self, action: #selector(verifyBtnPressed(_ :)), for: .touchUpInside)
        verificationView.resendBtn.addTarget(self, action: #selector(resendOtpPressed(_ :)), for: .touchUpInside)
        verificationView.textField.addTarget(self, action: #selector(textFiledValueChanged(_ :)), for: .editingChanged)
    }
    
    func setupData() {
        verificationView.textField.delegate = self
        self.verificationView.hintLbl.text = "txt_chk_sms".localize() + " " + "txt_pin_sent".localize() + " " + (givenPhoneNumber ?? "")
    }
    
    @objc func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

//  MARK: Firebase OTP VERIFY
extension VerificationVC {
    
    @objc func verifyBtnPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        if (self.verificationView.textField.text?.count ?? 0) < 4  {
            self.showAlert( "text_Alert".localize(), message: "text_otpsent_mobilenumber".localize())
        } else {
       
            if self.mobileNumChange == true {
                self.mobileChangeUpdateCall()
            } else {
                self.loginUser(primary: false)
            }
            
//            let vc = RegisterUserDetailsVC()
//            vc.selectedCountry = self.selectedCountry
//            vc.givenPhoneNumber = self.givenPhoneNumber
//            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    @objc func textFiledValueChanged(_ sender: UITextField) {
        if sender.text?.count == 4 {
            self.verificationView.textField.resignFirstResponder()
        }
    }

    
//  MARK: - OTP Resend API
    @objc func resendOtpPressed(_ sender: UIButton) {
        self.sendOTP()
    }
}
extension VerificationVC {
    
    
    func runTimer() {
        self.timer = Timer.scheduledTimer(timeInterval: 1, target: self,   selector: (#selector(self.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        self.seconds -= 1
        verificationView.lblGetAnotherCode.text = "txt_get_another_code".localize() + " " + "\(seconds)" + " " + "txt_sec".localize()
        verificationView.resendBtn.isHidden = true
        verificationView.otpRecieveHint.isHidden = false
        verificationView.resendBtn.isEnabled = false
        if self.seconds == 0 {
            verificationView.otpRecieveHint.isHidden = true
            verificationView.resendBtn.isHidden = false
            self.verificationView.resendBtn.isEnabled = true
          
            self.timer?.invalidate()
            self.timer = nil
            self.verificationView.resendBtn.setTitle("txt_resend_code".localize(), for: .normal)
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

extension VerificationVC {
    
    
    func sendOTP() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityData)
            var paramDict = Dictionary<String,Any>()
            paramDict["phone_number"] = self.givenPhoneNumber
            paramDict["country_code"] = self.selectedCountry?.id
            
            let url = APIHelper.shared.BASEURL + APIHelper.sendOTP
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.header).responseJSON { response in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                switch response.result {
                case .success(_):
                    print(response.result.value as Any)
                    if response.response?.statusCode == 200 {
                        self.seconds = 60
                        self.runTimer()
                    } else {
                        if let result = response.result.value as? [String: AnyObject] {
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
                case .failure(_):
                    self.showAlert("", message: "txt_sry_unable_to_process_number".localize())
                }
            }
        } else {
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
    }
    
    func loginUser(primary isPrimary: Bool) {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())

            var paramDict = Dictionary<String, Any>()
            
            if let countryId = self.selectedCountry?.id, var phone = self.givenPhoneNumber {
                while phone.starts(with: "0") {
                    phone = String(phone.dropFirst())
                }
                paramDict["phone_number"] = phone
                paramDict["country_code"] = countryId
            }
            paramDict["otp"] = self.verificationView.textField.text
            paramDict["device_info_hash"] = APIHelper.shared.deviceToken
            paramDict["is_primary"] = isPrimary
            
            let url = APIHelper.shared.BASEURL + APIHelper.driverLogin
            
            print(url,paramDict)
            
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.header).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any,response.response?.statusCode as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 200 {
                            if let data = result["data"] as? [String: AnyObject] {
                                if let newUser = data["new_user"] as? Bool, newUser {
                                    let vc = RegisterUserDetailsVC()
                                    vc.selectedCountry = self.selectedCountry
                                    vc.givenPhoneNumber = self.givenPhoneNumber
                                    self.navigationController?.pushViewController(vc, animated: true)
                                } else {
                                    self.getAuthToken(data)
                                }
                            }
                        } else {
                            if statusCode == 403 {
                                if let data = result["data"] as? [String: AnyObject] {
                                    if let errCode = data["error_code"] as? Int, errCode == 1001 {
                                        if let msg = result["message"] as? String {
                                            let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                                            let ok = UIAlertAction(title: "text_ok".localize(), style: .default) { (action) in
                                                self.loginUser(primary: true)
                                            }
                                            let cancel = UIAlertAction(title: "text_cancel".localize(), style: .default, handler: nil)
                                            alert.addAction(cancel)
                                            alert.addAction(ok)
                                            self.present(alert, animated: true, completion: nil)
                                        }
                                    }
                                }else {
                                    if let msg = result["message"] as? String {
                                        self.showAlert("", message: msg)
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
    
    func getAuthToken(_ data: [String: AnyObject]) {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            var paramDict = Dictionary<String, Any>()
            paramDict["grant_type"] = "client_credentials"
            paramDict.merge(data.mapValues({"\($0)"})) { (current, _) -> Any in
                current
            }
            let url = APIHelper.shared.BASEURL + APIHelper.authToken
            
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.header).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any,response.response?.statusCode as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        if let accessToken = result["access_token"] as? String, let tokenType = result["token_type"] as? String {
                            let token = tokenType + " " + accessToken
                            self.getUserProfile(token)
                        }
                    }
                }
            }
        } else {
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
    }
    
    func getUserProfile(_ token: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            let url = APIHelper.shared.BASEURL + APIHelper.getDriverProfile
            
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: ["Authorization":token]).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any,response.response?.statusCode as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        if let data = result["data"] as? [String:AnyObject] {
                            if let user = data["user"] as? [String: AnyObject] {
                                var details = [String: AnyObject]()
                                
                                details = user
                                details["access_token"] = token as AnyObject
                                print("My Details",details)
                                LocalDB.shared.storeUserDetails(details, currentUser: nil)
                                
                                self.redirect()
                            }
                        }
                    }
                }
            }
        } else {
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
    }
    
    func mobileChangeUpdateCall() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
           
            var paramDict = Dictionary<String, Any>()
            paramDict["phone_number"] = self.givenPhoneNumber
            paramDict["otp"] = self.verificationView.textField.text
           
            let url = APIHelper.shared.BASEURL + APIHelper.getDriverProfile
            
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)   // result of response serialization
                    //  to get JSON return value
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let data = result["data"] as? [String:AnyObject] {
                                    if let userdetails = data["user"] as? [String:AnyObject] {
                                        LocalDB.shared.updateUserDetails(userdetails)
                                    }
                                    self.navigationController?.pushViewController(ProfileVC(), animated: true)
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

extension VerificationVC {
    func redirect() {
        //AppLocationManager.shared.startTracking()
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

extension VerificationVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if textField == self.verificationView.textField {
            
            
            let allowedCharacters = CharacterSet.alphanumerics.inverted
            let components = string.components(separatedBy: allowedCharacters)
            let filtered = components.joined(separator: "")
            if string == filtered {
                let maxLength = 4
                let currentString: NSString = self.verificationView.textField.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                
                return newString.length <= maxLength
            } else {
                return false
            }
        
        }
        
        return true
    }
    
}
