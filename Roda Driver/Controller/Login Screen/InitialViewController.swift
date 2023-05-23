//
//  InitialViewController.swift
//  Taxiappz Driver
//
//  Created by spextrum on 20/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import Firebase
import FirebaseAuth
import IQKeyboardManagerSwift
import NVActivityIndicatorView

class InitialViewController: UIViewController {

    private let initialView = InitialView()
            
    var countryList = [CountryList]()
    var selectedCountry: CountryList?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getCountryList()
        self.setupViews()
        self.setupData()
        self.setupTarget()
        
    }
    
    func setupViews() {
        initialView.setupViews(Base: self.view)
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "text_Done".localize()
    }

    func setupTarget() {
        initialView.phonenumberTfd.delegate = self
        initialView.termsAndConditionView.delegate = self
        initialView.viewPhoneNumber.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showCountryPicker(_ :))))
        initialView.btnLogin.addTarget(self, action: #selector(btnLoginPressed(_ :)), for: .touchUpInside)
    }
    
    func setupData() {
        initialView.imgCountry.image = UIImage(named: self.selectedCountry?.isoCode ?? "")
        initialView.lblCountry.text = self.selectedCountry?.dialCode
    }
   
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        
        //Disconnect socket after logged out
        if MySocketManager.shared.socket != nil {
            MySocketManager.shared.socket.disconnect()
        }
        self.initialView.phonenumberTfd.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
       
    }

}

extension InitialViewController {
    
    @objc func showCountryPicker(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
        let vc = SelectCountryVC()
        vc.countryList = self.countryList
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
 
}

extension InitialViewController {
    //MARK: Firebase OTP
    @objc func btnLoginPressed(_ sender: UIButton) {
        self.view.endEditing(true)
        if self.selectedCountry?.dialCode == nil {
            view.showToast("text_select_countrycode".localize())
        } else if self.initialView.phonenumberTfd.text?.count == 0 {
            self.showAlert("", message: "text_enter_phonenumber".localize())
        } else if (self.initialView.phonenumberTfd.text?.count ?? 0) < 6 {
            self.showAlert("", message: "txt_enter_valid_phone_number".localize())
        } else {
           
            self.sendOTP()
//            let verificationVC = VerificationVC()
//            verificationVC.selectedCountry = self.selectedCountry
//            verificationVC.givenPhoneNumber = self.initialView.phonenumberTfd.text!
//            self.navigationController?.pushViewController(verificationVC, animated: true)
            
        }
    }
    
    func getFireBaseOtp() {
        if let dialCode = self.selectedCountry?.dialCode {
            var phNumber = self.initialView.phonenumberTfd.text!
            while phNumber.starts(with: "0") {
                phNumber = String(phNumber.dropFirst())
            }
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityData, nil)
            PhoneAuthProvider.provider().verifyPhoneNumber(dialCode + phNumber, uiDelegate: nil) { (verificationID, error) in
                if let error = error {
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    print(error.localizedDescription)
                    self.view.showToast(error.localizedDescription)
                    return
                }
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                if let verificationId = verificationID {
                    APIHelper.firebaseVerificationCode = verificationId
                }
                let verificationVC = VerificationVC()
                verificationVC.selectedCountry = self.selectedCountry
                verificationVC.givenPhoneNumber = self.initialView.phonenumberTfd.text!
                self.navigationController?.pushViewController(verificationVC, animated: true)
            }
        }
    }
}


extension InitialViewController {
    
    func sendOTP() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityData)
            var paramDict = Dictionary<String,Any>()
            paramDict["phone_number"] = self.initialView.phonenumberTfd.text
            paramDict["country_code"] = self.selectedCountry?.id
            
            let url = APIHelper.shared.BASEURL + APIHelper.sendOTP
            print(url,paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.header).responseJSON { response in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                switch response.result {
                case .success(_):
                    print(response.result.value as Any)
                    if response.response?.statusCode == 200 {
                        let verificationVC = VerificationVC()
                        verificationVC.selectedCountry = self.selectedCountry
                        verificationVC.givenPhoneNumber = self.initialView.phonenumberTfd.text!
                        self.navigationController?.pushViewController(verificationVC, animated: true)
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
    
    func getCountryList() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            var paramDict = Dictionary<String, Any>()
            paramDict["code"] = APIHelper.shared.appBaseCode
            
            let url = APIHelper.shared.BASEURL + APIHelper.getLanguage
            
            print("URL and Param For AvailLanguages",url, paramDict)
            
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.header).responseJSON { (response) in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode, statusCode == 200 {
                        if let data = result["data"] as? [String: AnyObject] {
                            if let countryData = data["country"] as? [[String: AnyObject]] {
                                self.countryList = countryData.compactMap({CountryList($0)})
                                
                                if let country = Locale.current.regionCode {
                                    
                                    if let selectedCountry = self.countryList.first(where: {$0.isoCode == country}) {
                                        self.selectedCountry = selectedCountry
                                        self.initialView.lblCountry.text = self.selectedCountry?.dialCode
                                        self.initialView.imgCountry.image = self.selectedCountry?.flag
                                    }else {
                                        self.selectedCountry = self.countryList.first
                                        self.initialView.lblCountry.text = self.selectedCountry?.dialCode
                                        self.initialView.imgCountry.image = self.selectedCountry?.flag
                                    }
                                } else {
                                    self.selectedCountry = self.countryList.first
                                    self.initialView.lblCountry.text = self.selectedCountry?.dialCode
                                    self.initialView.imgCountry.image = self.selectedCountry?.flag
                                }
                            }
                        }
                    } else {
                        if let error = result["data"] as? [String:[String]] {
                            let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                            self.showAlert("", message: errMsg)
                        } else if let error = result["error_message"] as? String {
                            self.showAlert("", message: error)
                        } else if let errMsg = result["message"] as? String {
                            self.showAlert("", message: errMsg)
                        }
                    }
                    
                }
            }
        }
    }
}

//MARK: - COUNTRY PICKER DELEGATE
extension InitialViewController: CountryPickerDelegate {
    func selectedCountry(_ country: CountryList) {
        self.selectedCountry = country
        self.initialView.lblCountry.text = self.selectedCountry?.dialCode
        self.initialView.imgCountry.image = self.selectedCountry?.flag
    }
}

//MARK: - UITEXTVIEW DELEGATE
extension InitialViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange) -> Bool {
        if (URL.absoluteString == initialView.termsAndConditionsURL) {
            let vc = TermsConditionVC()
            self.navigationController?.pushViewController(vc, animated: true)
        } else if (URL.absoluteString == initialView.privacyURL) {
            let vc = PrivacyPolicyVC()
            self.navigationController?.pushViewController(vc, animated: true)
        }
        return false
    }
}

// MARK: - To limit textfield character count
extension InitialViewController: UITextFieldDelegate {

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if (textField == self.initialView.phonenumberTfd) {
            
            let allowedCharacters = CharacterSet.alphanumerics.inverted
            let components = string.components(separatedBy: allowedCharacters)
            let filtered = components.joined(separator: "")
            if string == filtered {
                let maxLength = 12
                let currentString: NSString = self.initialView.phonenumberTfd.text! as NSString
                let newString: NSString =
                    currentString.replacingCharacters(in: range, with: string) as NSString
                
                return newString.length <= maxLength
            } else {
                return false
            }
        }
        return true
    }
    
// MARK: - View Outside Touch Keyboard Dismiss
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}
