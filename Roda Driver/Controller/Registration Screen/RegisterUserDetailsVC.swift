//
//  RegisterUserDetailsVC.swift
//  Taxiappz Driver
//
//  Created by spextrum on 22/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
class RegisterUserDetailsVC: UIViewController {

    private let registerUserView = RegisterUserDetailsView()
    
    
    private var areaList = [ServiceLocationList]()
    private var userDetails = UserDetails()

    var selectedCountry: CountryList?
    var givenPhoneNumber: String?
    
    private var selectedRegistrationMethod: RegistrationMethod = .individual
    var selectedCompany: CompanyList?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.getServiceLocations()
        self.setupViews()
        self.setupData()
        
    }
    
    override func viewWillLayoutSubviews() {
        if registerUserView.areaTxtField.text != "" {
            registerUserView.alrtSelectAreaLbl.isHidden = true
        }
    }
    
    func setupViews() {
        registerUserView.setupViews(Base: self.view)
        self.setupTarget()
    }
    
    func setupTarget() {
        self.registerUserView.firstNameTxtField.delegate = self
        self.registerUserView.lastNameTxtField.delegate = self
        self.registerUserView.emailIDTxtField.delegate = self
        
        self.registerUserView.btnBack.addTarget(self, action: #selector(btnBackPressed(_ :)), for: .touchUpInside)
        self.registerUserView.btnNext.addTarget(self, action: #selector(btnNextPressed(_:)), for: .touchUpInside)
        
        self.registerUserView.btnIndividual.addTarget(self, action: #selector(chooseCategory(_:)), for: .touchUpInside)
        self.registerUserView.btnCompany.addTarget(self, action: #selector(chooseCategory(_:)), for: .touchUpInside)
    
        self.registerUserView.chooseCompanyTxtField.delegate = self
    }
    
    func setupData() {
        self.registerUserView.mobileNumberTxtField.text = givenPhoneNumber
       
        if let selectCountry = self.selectedCountry {
            self.registerUserView.selectedCountryFlag.image = selectCountry.flag
            self.registerUserView.selectedCountryLbl.text = selectCountry.dialCode
        }
    }
}

//MARK: - ACTIONS
extension RegisterUserDetailsVC {
    @objc func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func chooseCategory(_ sender: UIButton) {
        self.registerUserView.btnIndividual.isSelected = false
        self.registerUserView.btnCompany.isSelected = false
        if sender == self.registerUserView.btnIndividual {
            self.selectedRegistrationMethod = .individual
            self.registerUserView.chooseCompanyTxtField.isHidden = true
            self.registerUserView.companyNameTxtField.isHidden = true
            self.registerUserView.companyPhoneNumTxtField.isHidden = true
            self.registerUserView.companyVehicleCountTxtField.isHidden = true
        } else {
            self.selectedRegistrationMethod = .company
            self.registerUserView.chooseCompanyTxtField.isHidden = false
        }
        sender.isSelected = true
    }
    

    @objc func btnNextPressed(_ sender: UIButton) {
        if registerUserView.firstNameTxtField.text!.isBlank {
            registerUserView.alrtEnterNameLbl.isHidden = false
            return
        } else if registerUserView.lastNameTxtField.text!.isBlank {
            registerUserView.alrtLstNameLbl.isHidden = false
            return
        }  else if !(self.registerUserView.emailIDTxtField.text?.isEmpty ?? false) && !(self.registerUserView.emailIDTxtField.text?.isValidEmail ?? false) {
            registerUserView.alrtEmailIDLbl.isHidden = false
            return
        } else if selectedCountry?.dialCode == nil {
            registerUserView.alrtCountryCodeLbl.isHidden = false
            return
        } else if registerUserView.mobileNumberTxtField.text!.isBlank {
            registerUserView.alrtMobileNumberLbl.isHidden = false
            return
        } else if registerUserView.areaTxtField.text!.isBlank {
            registerUserView.alrtSelectAreaLbl.isHidden = false
            return
        } else if self.selectedRegistrationMethod == .company {
            if self.selectedCompany == nil {
                self.showAlert("", message: "txt_company_name_error".localize())
            } else {
                if self.selectedCompany?.id == "Other" {
                    if self.registerUserView.companyNameTxtField.text == "" || self.registerUserView.companyPhoneNumTxtField.text == "" || self.registerUserView.companyVehicleCountTxtField.text == "" {
                        self.showAlert("", message: "txt_enter_company_details".localize())
                    } else {
                        self.moveToVehicleDetails()
                    }
                } else {
                    self.moveToVehicleDetails()
                }
                
            }
        }
        else {
            self.moveToVehicleDetails()
        }
    }
    
    func moveToVehicleDetails() {
        
        self.userDetails.firstname = self.registerUserView.firstNameTxtField.text!
        self.userDetails.lastname = self.registerUserView.lastNameTxtField.text!
        self.userDetails.email = self.registerUserView.emailIDTxtField.text!
        if let selectedCountry = selectedCountry {
            var phNumber = self.registerUserView.mobileNumberTxtField.text!
            while phNumber.starts(with: "0") {
                phNumber = String(phNumber.dropFirst())
                print(phNumber)
            }
            self.userDetails.phone = phNumber
            self.userDetails.country = selectedCountry.id ?? ""
            self.userDetails.countryCode = selectedCountry.dialCode ?? ""
        }

        if let area = self.areaList.first(where: { $0.name == self.registerUserView.areaTxtField.text! }) {
            self.userDetails.adminId = area.slug
        }
        self.userDetails.referralCode = self.registerUserView.txtReferralCode.text ?? ""
        
        self.userDetails.companyName = self.registerUserView.companyNameTxtField.text ?? ""
        self.userDetails.companyPhone = self.registerUserView.companyPhoneNumTxtField.text ?? ""
        self.userDetails.companyTotalVehicles = self.registerUserView.companyVehicleCountTxtField.text ?? ""
        
        let registerVehicleDetailsVC = RegisterVehicleDetailsVC()
        registerVehicleDetailsVC.userDetails = self.userDetails
        registerVehicleDetailsVC.registrationMethod = self.selectedRegistrationMethod
        registerVehicleDetailsVC.selectedCompany = self.selectedCompany
        registerVehicleDetailsVC.callback = { [weak self] userDetails in
            self?.userDetails = userDetails
            print(userDetails)
        }
        self.navigationController?.pushViewController(registerVehicleDetailsVC, animated: true)
    }
    
    func getServiceLocations() {
        if ConnectionCheck.isConnectedToNetwork() {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityData)
 
            let url = APIHelper.shared.BASEURL + APIHelper.getServiceLocation
            print("Get Area List url and Param",url)
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: APIHelper.shared.header).responseJSON { (response) in
                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                
                switch response.result {
                case .failure(let error):
                    self.view.showToast(error.localizedDescription)
                case .success(_):
                    print(response.result.value as Any)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode, statusCode == 200 {
                            if let data = result["data"] as? [String: AnyObject] {
                                if let serviceLoc = data["ServiceLocation"] as? [[String: AnyObject]] {
                                    self.areaList = serviceLoc.compactMap({ServiceLocationList($0)})
                                    
                                    self.registerUserView.areaTxtField.itemList = self.areaList.map({$0.name})
                                }
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

//MARK: - TEXTFIELD DELEGATE
extension RegisterUserDetailsVC: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.registerUserView.chooseCompanyTxtField {
            
            let vc = CompanyListVC()
            vc.delegate = self
            vc.selectedCompany = self.selectedCompany
            vc.modalPresentationStyle = .overCurrentContext
            self.present(vc, animated: true, completion: nil)
            return false
        }
        
        if textField == registerUserView.firstNameTxtField {
            registerUserView.alrtEnterNameLbl.isHidden = true
        }
        if textField == registerUserView.lastNameTxtField {
            registerUserView.alrtLstNameLbl.isHidden = true
        }
        if textField == registerUserView.emailIDTxtField {
            registerUserView.alrtEmailIDLbl.isHidden = true
        }
        
        return true
    }
 
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        textField.contentVerticalAlignment = UIControl.ContentVerticalAlignment.center

        let currentString = textField.text! as NSString
        let newString = currentString.replacingCharacters(in: range, with: string)

        if textField == self.registerUserView.firstNameTxtField || textField == self.registerUserView.lastNameTxtField {
            
            let allowedCharacters = CharacterSet.alphanumerics.inverted
            let components = string.components(separatedBy: allowedCharacters)
            let filtered = components.joined(separator: "")
            if string != filtered {
                return false
            } else {
                let maxLength = 15
                return newString.count <= maxLength
            }
            
        }
        return true
    }

}

//MARK: - DELEGATE - SELECTED COMPANY
extension RegisterUserDetailsVC: CompanyListDelegate {
    func selectedCompany(company selectedCompany: CompanyList) {
        self.selectedCompany = selectedCompany
        self.registerUserView.chooseCompanyTxtField.text = selectedCompany.name
        
        if self.selectedCompany?.id == "Other" {
            self.registerUserView.companyNameTxtField.isHidden = false
            self.registerUserView.companyPhoneNumTxtField.isHidden = false
            self.registerUserView.companyVehicleCountTxtField.isHidden = false
        } else {
            self.registerUserView.companyNameTxtField.isHidden = true
            self.registerUserView.companyPhoneNumTxtField.isHidden = true
            self.registerUserView.companyVehicleCountTxtField.isHidden = true
        }
        
    }
    
}
