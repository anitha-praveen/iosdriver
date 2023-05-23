//
//  RegisterVehicleDetailsVC.swift
//  Taxiappz Driver
//
//  Created by spextrum on 22/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit
import Alamofire

import NVActivityIndicatorView
import Kingfisher
class RegisterVehicleDetailsVC: UIViewController {

    private let registerVehicleView = RegisterVehicleDetailsView()
    
    //***** Variables for Data Received from Previous ViewController *****
    var userDetails: UserDetails?
    var callback: ((UserDetails) -> Void)?
    
    //***** Vehicle Types *****
    var vehicleTypes = [VehicleType]()
    var selectedVehicleType: VehicleType?
    
    var vehicleModels = [VehicleModelList]()
    var selectedVehicleModel: VehicleModelList?
    
    var registrationMethod: RegistrationMethod?
  
    var selectedCompany: CompanyList?
    var selectedServiceTypes = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.getVehicleTypes()
        self.registerVehicleView.viewIndividual.isHidden = false
    
        self.setupViews()
        self.setupTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if self.isMovingFromParent {
            if let userDetail = self.userDetails {
                callback?(userDetail)
            }
        }
    }
    
    func setupViews() {
        registerVehicleView.setupViews(Base: self.view)
        registerVehicleView.collectionvw.delegate = self
        registerVehicleView.collectionvw.dataSource = self
        registerVehicleView.collectionvw.register(VehicleTypeCollectionCell.self, forCellWithReuseIdentifier: "vehicletypecell")
        
        registerVehicleView.modelListTableView.delegate = self
        registerVehicleView.modelListTableView.dataSource = self
        registerVehicleView.modelListTableView.register(UITableViewCell.self, forCellReuseIdentifier: "vehiclemodellistcell")
    }
    
    func setupTarget() {
        self.registerVehicleView.vehicleNumberTxtField.delegate = self
        self.registerVehicleView.vehicleModelTxtField.delegate = self
       

        self.registerVehicleView.btnBack.addTarget(self, action: #selector(btnBackPressed(_ :)), for: .touchUpInside)
        
        self.registerVehicleView.vehicleModelTxtField.delegate = self
        self.registerVehicleView.serviceTypeTxtField.delegate = self
        
        self.registerVehicleView.btnYes.addTarget(self, action: #selector(btnUseBrandPressed(_ :)), for: .touchUpInside)
        self.registerVehicleView.btnNo.addTarget(self, action: #selector(btnUseBrandPressed(_ :)), for: .touchUpInside)
        self.registerVehicleView.btnNext.addTarget(self, action: #selector(btnNextPressed(_:)), for: .touchUpInside)
        
    }
    
}

extension RegisterVehicleDetailsVC {
    @objc func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func btnUseBrandPressed(_ sender: UIButton) {
        self.registerVehicleView.btnYes.isSelected = false
        self.registerVehicleView.btnNo.isSelected = false
        sender.isSelected = true
    }
    
    @objc func btnNextPressed(_ sender: UIButton) {
       
        if self.selectedVehicleType == nil {
            self.showAlert("text_Alert".localize(), message: "txt_select_vehicle_type".localize())
            return
        } else if self.registerVehicleView.vehicleNumberTxtField.text!.isBlank {
            self.showAlert("text_Alert".localize(), message: "txt_enter_veh_number".localize())
            return
        } else if self.registerVehicleView.vehicleModelTxtField.text!.isBlank {
            self.showAlert("text_Alert".localize(), message: "txt_enter_veh_model_name".localize())
            return
        } else if self.selectedVehicleType?.serviceTypes != nil && self.selectedServiceTypes == "" {
            self.showAlert("text_Alert".localize(), message: "txt_select_service_types".localize())
            return
        } else if self.selectedVehicleModel?.id == "Other" {
            if self.registerVehicleView.otherModelTxtField.text == "" {
                self.showAlert("text_Alert".localize(), message: "txt_enter_veh_model_name".localize())
                return
            } else {
                self.driverRegisterAPI(primary: false)
            }
        }
        else {
            self.driverRegisterAPI(primary: false)
        }
       
    }
}


// MARK: - TextField Delegates
extension RegisterVehicleDetailsVC: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        if textField == self.registerVehicleView.vehicleModelTxtField {
            self.registerVehicleView.modelListCoverView.isHidden = false
            return false
        } else if textField == self.registerVehicleView.serviceTypeTxtField {
           
            let vc = ServiceSelectionVC()
            vc.serviceTypes = self.selectedVehicleType?.serviceTypes ?? [""]
            vc.callBack = {[weak self] services in
                self?.selectedServiceTypes = services
                self?.registerVehicleView.serviceTypeTxtField.text = services
            }
            vc.modalPresentationStyle = .overFullScreen
            self.present(vc, animated: true, completion: nil)
            return false
        }
        return true
    }
   
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
       
        
//        let allowedCharacters = CharacterSet.alphanumerics.inverted
//        let components = string.components(separatedBy: allowedCharacters)
//        let filtered = components.joined(separator: "")
//        if string != filtered {
//            return false
//        }
        
        if (textField == self.registerVehicleView.otherModelTxtField) {
            let maxLength = 20
            let currentString: NSString = self.registerVehicleView.vehicleModelTxtField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        } else if (textField == self.registerVehicleView.vehicleNumberTxtField) {
            let maxLength = 15
            let currentString: NSString = self.registerVehicleView.vehicleNumberTxtField.text! as NSString
            let newString: NSString =
                currentString.replacingCharacters(in: range, with: string) as NSString
            return newString.length <= maxLength
        }
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField == self.registerVehicleView.vehicleModelTxtField {
            self.userDetails?.carModel = self.registerVehicleView.vehicleModelTxtField.text!
        }
        else if textField == self.registerVehicleView.vehicleNumberTxtField {
            self.userDetails?.carNumber = self.registerVehicleView.vehicleNumberTxtField.text!
        }
        
    }
}

//MARK:- Collection Delegate - Vehicle Types

extension RegisterVehicleDetailsVC: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.vehicleTypes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "vehicletypecell", for: indexPath) as? VehicleTypeCollectionCell ?? VehicleTypeCollectionCell()
        
        if let urlStr = self.vehicleTypes[indexPath.row].imgUrlStr, let url = URL(string: urlStr) {
            let resource = ImageResource(downloadURL: url)
            cell.imgview.kf.setImage(with: resource)
        }
        cell.lblTypeName.text = self.vehicleTypes[indexPath.row].name
        if self.selectedVehicleType?.id == self.vehicleTypes[indexPath.row].id {
            cell.viewColor.backgroundColor = .themeColor
        } else {
            cell.viewColor.backgroundColor = .secondaryColor
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        if self.selectedVehicleType?.id != self.vehicleTypes[indexPath.row].id {
            self.selectedVehicleType = self.vehicleTypes[indexPath.row]
            self.registerVehicleView.collectionvw.reloadData()
            self.displayNeededFields()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width/3, height: 130)
    }
    
}

//MARK: - TABLE DELEGATE METHODS
extension RegisterVehicleDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.vehicleModels.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "vehicletypecell") ?? UITableViewCell()
        cell.textLabel?.text = self.vehicleModels[indexPath.row].name
        cell.textLabel?.font = UIFont.appRegularFont(ofSize: 18)
        cell.textLabel?.textColor = .txtColor
        
        if self.selectedVehicleModel?.id == self.vehicleModels[indexPath.row].id {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedVehicleModel = self.vehicleModels[indexPath.row]
        self.registerVehicleView.modelListTableView.reloadData()
        self.registerVehicleView.modelListCoverView.isHidden = true
        self.registerVehicleView.vehicleModelTxtField.text = self.selectedVehicleModel?.name
        
        if self.selectedVehicleModel?.id == "Other" {
            self.registerVehicleView.otherModelTxtField.isHidden = false
        } else {
            self.registerVehicleView.otherModelTxtField.isHidden = true
        }
    }
    
}


//MARK: API'S
extension RegisterVehicleDetailsVC {
    func getVehicleTypes() {
        if ConnectionCheck.isConnectedToNetwork() {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityData,nil)
          
            let url = APIHelper.shared.BASEURL + APIHelper.getVehicleTypesList
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.header)
                .responseJSON { response in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    print("Types List", response.result.value as Any)
                    if case .failure(_) = response.result {
                        self.registerVehicleView.noTypesView.isHidden = false
                    } else if case .success = response.result {
                        if let result = response.result.value as? [String: AnyObject] {
                            if let statusCode = response.response?.statusCode {
                                if statusCode == 200 {
                                    if let data = result["data"] as? [String: AnyObject] {
                                        if let types = data["types"] as? [[String:AnyObject]] {
                                            self.vehicleTypes = types.map({ VehicleType($0) })
                                            if self.vehicleTypes.isEmpty {
                                               
                                                self.registerVehicleView.noTypesView.isHidden = false
                                            } else {
                                                self.selectedVehicleType = self.vehicleTypes.first
                                                self.registerVehicleView.collectionvw.reloadData()
                                                self.displayNeededFields()
                                            }
                                        }
                                    }
                                } else {
                                    self.registerVehicleView.noTypesView.isHidden = false
                                    if let err = result["error_message"] as? String {
                                        self.showAlert("", message: err)
                                    } else if let msg = result["message"] as? String {
                                        self.showAlert("", message: msg)
                                    }
                                }
                            }
                        }
                    }
                }
        } else {
            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
            self.showAlert("txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
        }
    }
    
    func displayNeededFields() {
        
        self.vehicleModels = []
        self.selectedVehicleModel = nil
        self.selectedServiceTypes = ""
        
        self.registerVehicleView.vehicleModelTxtField.text = ""
        self.registerVehicleView.serviceTypeTxtField.text = ""
        
        self.getVehicleModel(self.selectedVehicleType?.slug ?? "")
        if self.selectedVehicleType?.serviceTypes == nil {
            self.registerVehicleView.serviceTypeTxtField.isHidden = true
        } else {
            self.registerVehicleView.serviceTypeTxtField.isHidden = false
        }
    }
    
    func getVehicleModel(_ slug: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            
            var paramDict = Dictionary<String, Any>()
            paramDict["slug"] = slug
            let url = APIHelper.shared.BASEURL + APIHelper.getVehicleModelList
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.header).responseJSON { (response) in
                switch response.result {
                
                case .success(_):
                    print(response.result.value as Any)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let data = result["data"] as? [String: AnyObject] {
                            if let modelList = data["vehiclemodel"] as? [[String: AnyObject]] {
                                self.vehicleModels = []
                                self.vehicleModels = modelList.compactMap({VehicleModelList($0)})
                                var addObj = [String: Any]()
                                addObj["model_name"] = "Other"
                                addObj["slug"] = "Other"
                                self.vehicleModels.append(VehicleModelList(addObj))
                                self.registerVehicleView.modelListTableView.reloadData()
                                
                            }
                        }
                    }
                case .failure(_):
                    self.view.showToast("txt_no_vechile_models_available".localize())
                }
            }
        }
    }
    
    // MARK: - Driver Register
    func driverRegisterAPI(primary isPrimary: Bool) {
        if ConnectionCheck.isConnectedToNetwork() {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityData,nil)
            
            var paramDict = Dictionary<String, Any>()
            
            paramDict["firstname"] = self.userDetails?.firstname
            paramDict["lastname"] = self.userDetails?.lastname
            paramDict["email"] = self.userDetails?.email
            paramDict["phone_number"] = self.userDetails?.phone
            paramDict["country_code"] = self.userDetails?.country
            paramDict["device_info_hash"] = APIHelper.shared.deviceToken
            paramDict["device_type"] = "IOS"
            paramDict["service_location"] = self.userDetails?.adminId
            
            if self.registrationMethod == .company {
                if self.selectedCompany?.id == "Other" {
                    paramDict["company_name"] = self.userDetails?.companyName
                    paramDict["company_no_of_vehicles"] = self.userDetails?.companyTotalVehicles
                    paramDict["company_phone"] = "+91" + (self.userDetails?.companyPhone ?? "")
                } else {
                    paramDict["company_slug"] = self.selectedCompany?.id
                }
                paramDict["login_method"] = "COMPANY"
            } else {
                paramDict["login_method"] = "INDIVIDUAL"
            }
            
           
            paramDict["vehicle_type_slug"] = self.selectedVehicleType?.slug
            
            if self.selectedVehicleModel?.id == "Other" {
                paramDict["vehicle_model_name"] = self.registerVehicleView.otherModelTxtField.text
            } else {
                paramDict["vehicle_model_slug"] = self.selectedVehicleModel?.id
            }
            
            paramDict["car_number"] = self.registerVehicleView.vehicleNumberTxtField.text
           
            if self.selectedServiceTypes != "" {
                paramDict["service_category"] = self.selectedServiceTypes.uppercased()
            } else {
                paramDict["service_category"] = "Local".uppercased()
            }
           
            paramDict["brand_label"] = self.registerVehicleView.btnYes.isSelected ? "YES": "NO"
            if self.userDetails?.referralCode != "" {
                paramDict["referral_code"] = self.userDetails?.referralCode
            }
            
            paramDict["is_primary"] = isPrimary
        
            let url = APIHelper.shared.BASEURL + APIHelper.driverSignUp
            print("Driver Register Url and Param",url,paramDict)
            Alamofire.request(url, method:.post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.header)
                .responseJSON { response in
                    print("Driver Register", response.result.value as Any)
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                    if case .failure(let error) = response.result {
                        self.showAlert("", message: error.localizedDescription)
                    } else if case .success = response.result {
                        if let result = response.result.value as? [String: AnyObject] {
                            if let statusCode = response.response?.statusCode {
                                if statusCode == 200 {
                                    if let data = result["data"] as? [String: AnyObject] {
                                       
                                        self.getAuthToken(data)
                                    }
                                } else {
                                    if statusCode == 403 {
                                        if let data = result["data"] as? [String: AnyObject] {
                                            if let errCode = data["error_code"] as? Int, errCode == 1001 {
                                                if let msg = result["message"] as? String {
                                                    let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                                                    let ok = UIAlertAction(title: "OK", style: .default) { (action) in
                                                        self.driverRegisterAPI(primary: true)
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
        } else {
           
            self.showAlert("txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
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
            Alamofire.request(url, method: .get, parameters: nil, headers: ["Authorization":token]).responseJSON { (response) in
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
                                
                                self.navigationController?.isNavigationBarHidden = false
                                let vc = ManageDocumentVC()
                                vc.isFromRegister = true
                                self.navigationController?.pushViewController(vc, animated: true)
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
