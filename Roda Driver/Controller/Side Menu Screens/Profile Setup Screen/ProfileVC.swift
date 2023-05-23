//
//  ProfileVC.swift
//  Taxiappz Driver
//
//  Created by NPlus Technologies on 02/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import NVActivityIndicatorView

class ProfileVC: UIViewController {
    
    let profileView = ProfileView()
    let picker = UIImagePickerController()
    
    var currentLayoutDirection = APIHelper.appLanguageDirection
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if currentLayoutDirection != APIHelper.appLanguageDirection {
            profileView.setupViews(Base: self.view)
            currentLayoutDirection = APIHelper.appLanguageDirection
        }
        
        self.setupData()
    }
    
    func setupViews() {
        profileView.setupViews(Base: self.view)
        setupTarget()
    }
   
    func setupTarget() {
       
        
       // profileView.viewPhoneNumber.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setviewPhoneNumberPressed(_ :))))
        profileView.viewSetLanguage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setLanguagePressed(_ :))))
        profileView.viewVehicle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setViewVehiclePressed(_ :))))
        
        profileView.backBtn.addTarget(self, action: #selector(backBtnPressed(_ :)), for: .touchUpInside)
        profileView.profpicBtn.addTarget(self, action: #selector(proPicBtnPressed(_ :)), for: .touchUpInside)
        profileView.profpicEditBtn.addTarget(self, action: #selector(proPicBtnPressed(_ :)), for: .touchUpInside)
        
        profileView.btnSave.addTarget(self, action: #selector(btnSavePressed(_ :)), for: .touchUpInside)
        profileView.deleteButton.addTarget(self, action: #selector(deleteAccount(_ :)), for: .touchUpInside)
        
    }
    
    func setupData() {
        
        fetchFromProfile()
        
        if let name = LocalDB.shared.driverDetails?.firstName {
            self.profileView.nameLbl.text = name
        }
        if let fname = LocalDB.shared.driverDetails?.firstName {
            self.profileView.txtFirstName.text = fname
        }
        if let lname = LocalDB.shared.driverDetails?.lastName {
            self.profileView.txtLastName.text = lname
        }
        if let email = LocalDB.shared.driverDetails?.email {
            self.profileView.txtEmail.text = email
        }
        if let mobile = LocalDB.shared.driverDetails?.phone {
            self.profileView.txtPhoneNumber.text = mobile
        }
        
        if let imgStr = LocalDB.shared.driverDetails?.profilePictureUrl, let url = URL(string: imgStr) {
            let resource = ImageResource(downloadURL: url)
            self.profileView.profpicBtn.kf.setImage(with: resource,for: .normal, placeholder:UIImage(named: "profileEditPlaceHolder"))
        } else {
            self.profileView.profpicBtn.setImage(UIImage(named: "profileEditPlaceHolder"), for: .normal)
        }
        
        self.profileView.txtSetLanguage.text = "txt_Lang".localize() + " / " + APIHelper.currentAppLanguage.uppercased()
         
    }
    @objc func deleteAccount(_ sender: UIButton) {
        let vc = LogoutVC()
        vc.modalPresentationStyle = .overCurrentContext
        vc.deleteAccount = true
        self.present(vc, animated: true, completion: nil)
    }
}

//MARK:- Target Action's
extension ProfileVC {
    @objc func updateProfile(_ sender: UITapGestureRecognizer) {
        let vc = ProfileUpdateVC()
       
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func setLanguagePressed(_ sender: UITapGestureRecognizer) {
        let vc = SetLanguageVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func setViewVehiclePressed(_ sender: UITapGestureRecognizer) {
        self.navigationController?.pushViewController(ProfileVehicleVC(), animated: true)
    }
    
    @objc func setviewPhoneNumberPressed(_ sender: UITapGestureRecognizer) {
    //  self.navigationController?.pushViewController(ProfileMobileNumVerifyVC(), animated: true)
    }


    @objc func proPicBtnPressed(_ sender: UIButton) {
        guard let title = APIHelper.shared.appName else { return }
        
        let alert = UIAlertController(title: title, message: "text_Please_Select_an_Option".localize(), preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = sender
        alert.popoverPresentationController?.sourceRect = sender.bounds
        alert.addAction(UIAlertAction(title: "text_camera".localize(), style: .default, handler:{ _ in
            print("User click Camera button")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.delegate = self
                self.picker.sourceType = UIImagePickerController.SourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "text_photoLib".localize(), style: .default, handler:{ _ in
            print("User click Photos button")
            self.picker.delegate = self
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "text_cancel".localize(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
   
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func btnSavePressed(_ sender: UIButton) {
        self.updateDriverDetails()
    }
}
//MARK:- ImagePicker Delegate

extension ProfileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            
            let orientationImg = selectedImage.fixedOrientation()
            profileView.profpicBtn.setImage(orientationImg, for: .normal)
            
            self.updateDriverDetails()
        } else if let selectedImage = info[.editedImage] as? UIImage {
            
            let orientationImg = selectedImage.fixedOrientation()
            profileView.profpicBtn.setImage(orientationImg, for: .normal)
            
            self.updateDriverDetails()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
 

//MARK:- API'S
extension ProfileVC {
    
    func fetchFromProfile() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            let url = APIHelper.shared.BASEURL + APIHelper.getDriverProfile
            
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let data = result["data"] as? [String: AnyObject] {
                                    if let userdetails = data["user"] as? [String:AnyObject] {
                                        print("USER DATA FETCHED",userdetails)
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
    
    func updateDriverDetails() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            var paramDict = Dictionary<String, Any>()
            
            paramDict["firstname"] = self.profileView.txtFirstName.text
            paramDict["lastname"] = self.profileView.txtLastName.text
            paramDict["email"] = self.profileView.txtEmail.text
            
            let url = APIHelper.shared.BASEURL + APIHelper.getDriverProfile
            
            guard let urlRequest = try? URLRequest(url: url, method: .post, headers: APIHelper.shared.authHeader) else {
                return
            }
            
            var newImage: UIImage? = nil
          
                if let btnImg = self.profileView.profpicBtn.imageView?.image, !btnImg.isEqual(UIImage(named: "profileEditPlaceHolder")) {
                    newImage = self.profileView.profpicBtn.imageView?.image
                }
           
            while let image = newImage, let imgData = image.pngData(), imgData.count > 1999999 {
                newImage = newImage?.resized(withPercentage: 0.5)
            }
            Alamofire.upload(multipartFormData: { multipartFormData in
                if let image = newImage, let imgData = image.pngData() {
                    multipartFormData.append(imgData, withName: "profile_pic", fileName: "picture.png", mimeType: "image/png")
                }
                
                for (key, value) in paramDict {
                    if let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                
            }, with: urlRequest, encodingCompletion:{ encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        NKActivityLoader.sharedInstance.hide()
                        print(response.result.value as Any, response.response?.statusCode as Any)
                        if case .failure(let error) = response.result {
                            print(error.localizedDescription)
                        }
                        else if case .success = response.result {
                            
                            if let result = response.result.value as? [String: AnyObject] {
                                if let statusCode = response.response?.statusCode {
                                    if statusCode == 200 {
                                        if let data = result["data"] as? [String:AnyObject] {
                                            if let userdetails = data["user"] as? [String:AnyObject] {
                                                LocalDB.shared.updateUserDetails(userdetails)
                                            //    self.view.showToast("Successfully updated!!!")
                                            }
                                        }
                                        if let msg = result["success_message"] as? String {
                                            self.view.showToast(msg)
                                        }
                                        if let imgStr = LocalDB.shared.driverDetails?.profilePictureUrl, let url = URL(string: imgStr) {
                                            let resource = ImageResource(downloadURL: url)
                                            self.profileView.profpicBtn.kf.setImage(with: resource,for: .normal, placeholder:UIImage(named: "profileEditPlaceHolder"))
                                        } else {
                                            self.profileView.profpicBtn.setImage(UIImage(named: "profileEditPlaceHolder"), for: .normal)
                                        }
                                    } else {
                                        
                                        if let msg = result["error_message"] as? String {
                                            self.view.showToast(msg)
                                        }
                                    }
                                }
                            }
                        }
                    }
                case .failure(let encodingError):
                    
                    NKActivityLoader.sharedInstance.hide()
                    self.showAlert("text_Alert".localize(), message: encodingError.localizedDescription)
                }
            })
            
        } else {
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
    }
}





/*
 //Using S3
class ProfileVC: UIViewController {
    
    let profileView = ProfileView()
    let picker = UIImagePickerController()
    
    var currentLayoutDirection = APIHelper.appLanguageDirection
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        if currentLayoutDirection != APIHelper.appLanguageDirection {
            profileView.setupViews(Base: self.view)
            currentLayoutDirection = APIHelper.appLanguageDirection
        }
        
        self.setupData()
    }
    
    func setupViews() {
        profileView.setupViews(Base: self.view)
        setupTarget()
    }
   
    func setupTarget() {
       
        
       // profileView.viewPhoneNumber.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setviewPhoneNumberPressed(_ :))))
        profileView.viewSetLanguage.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setLanguagePressed(_ :))))
        profileView.viewVehicle.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(setViewVehiclePressed(_ :))))
        
        profileView.backBtn.addTarget(self, action: #selector(backBtnPressed(_ :)), for: .touchUpInside)
        profileView.profpicBtn.addTarget(self, action: #selector(proPicBtnPressed(_ :)), for: .touchUpInside)
        profileView.profpicEditBtn.addTarget(self, action: #selector(proPicBtnPressed(_ :)), for: .touchUpInside)
        
        profileView.btnSave.addTarget(self, action: #selector(btnSavePressed(_ :)), for: .touchUpInside)
        
    }
    
    func setupData() {
        if let name = LocalDB.shared.driverDetails?.firstName {
            self.profileView.nameLbl.text = name
        }
        if let fname = LocalDB.shared.driverDetails?.firstName {
            self.profileView.txtFirstName.text = fname
        }
        if let lname = LocalDB.shared.driverDetails?.lastName {
            self.profileView.txtLastName.text = lname
        }
        if let email = LocalDB.shared.driverDetails?.email {
            self.profileView.txtEmail.text = email
        }
        if let mobile = LocalDB.shared.driverDetails?.phone {
            self.profileView.txtPhoneNumber.text = mobile
        }
        
        if (LocalDB.shared.driverDetails?.profilePictureUrl) != nil {
            profilePicLoading()
        } else {
            self.profileView.profpicBtn.setImage(UIImage(named: "profileEditPlaceHolder"), for:.normal)
        }
        self.profileView.txtSetLanguage.text = "txt_Lang".localize() + " / " + APIHelper.currentAppLanguage.uppercased()
         
    }
    
    func profilePicLoading() {
        
        if let imgData = LocalDB.shared.profilePictureData {
            self.profileView.profpicBtn.setImage(UIImage(data: imgData), for: .normal)
           
        } else {
          
            if let imgStr = LocalDB.shared.driverDetails?.profilePictureUrl {
                self.retriveImg(key: imgStr) { data in
                    self.profileView.profpicBtn.setImage(UIImage(data: data), for: .normal)
                }
                
            }
        }
    }
    
}

//MARK:- Target Action's
extension ProfileVC {
    @objc func updateProfile(_ sender: UITapGestureRecognizer) {
        let vc = ProfileUpdateVC()
       
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    @objc func setLanguagePressed(_ sender: UITapGestureRecognizer) {
        let vc = SetLanguageVC()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func setViewVehiclePressed(_ sender: UITapGestureRecognizer) {
        self.navigationController?.pushViewController(ProfileVehicleVC(), animated: true)
    }
    
    @objc func setviewPhoneNumberPressed(_ sender: UITapGestureRecognizer) {
    //  self.navigationController?.pushViewController(ProfileMobileNumVerifyVC(), animated: true)
    }


    @objc func proPicBtnPressed(_ sender: UIButton) {
        guard let title = APIHelper.shared.appName else { return }
        
        let alert = UIAlertController(title: title, message: "text_Please_Select_an_Option".localize(), preferredStyle: .actionSheet)
        alert.popoverPresentationController?.sourceView = sender
        alert.popoverPresentationController?.sourceRect = sender.bounds
        alert.addAction(UIAlertAction(title: "text_camera".localize(), style: .default, handler:{ _ in
            print("User click Camera button")
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.delegate = self
                self.picker.sourceType = UIImagePickerController.SourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
            }
        }))
        
        alert.addAction(UIAlertAction(title: "text_photoLib".localize(), style: .default, handler:{ _ in
            print("User click Photos button")
            self.picker.delegate = self
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
        }))
        
        alert.addAction(UIAlertAction(title: "text_cancel".localize(), style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
   
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    @objc func btnSavePressed(_ sender: UIButton) {
        self.updateDriverDetails()
    }
}
//MARK:- ImagePicker Delegate

extension ProfileVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            
            let orientationImg = selectedImage.fixedOrientation()
            profileView.profpicBtn.setImage(orientationImg, for: .normal)
            
            self.updateprofileapicall()
        } else if let selectedImage = info[.editedImage] as? UIImage {
            
            let orientationImg = selectedImage.fixedOrientation()
            profileView.profpicBtn.setImage(orientationImg, for: .normal)
            
            self.updateprofileapicall()
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
 

//MARK:- API'S
extension ProfileVC {
    
    
    func updateDriverDetails() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())

            var paramDict = Dictionary<String, Any>()
           
            paramDict["firstname"] = self.profileView.txtFirstName.text
            paramDict["lastname"] = self.profileView.txtLastName.text
            paramDict["email"] = self.profileView.txtEmail.text
           
            let url = APIHelper.shared.BASEURL + APIHelper.getDriverProfile
            
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let data = result["data"] as? [String: AnyObject] {
                                    if let userdetails = data["user"] as? [String:AnyObject] {
                                        LocalDB.shared.updateUserDetails(userdetails)
                                        self.view.showToast("Successfully updated!!!")
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
    
    func updateprofileapicall() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            let paramDict = Dictionary<String, Any>()
            
            
            guard let urlRequest = try? URLRequest(url: APIHelper.shared.BASEURL + APIHelper.getDriverProfile, method: .post, headers: APIHelper.shared.authHeader) else {
                return
            }
            print("Url", APIHelper.shared.BASEURL + APIHelper.getDriverProfile)
            print("Token", APIHelper.shared.authHeader)
            var newImage: UIImage? = nil
            
            if let btnImg = self.profileView.profpicBtn.imageView?.image, !btnImg.isEqual(UIImage(named: "profileEditPlaceHolder")) {
                newImage = self.profileView.profpicBtn.imageView?.image
            }
            
            while let image = newImage, let imgData = image.pngData(), imgData.count > 1999999 {
                newImage = newImage?.resized(withPercentage: 0.5)
            }
            Alamofire.upload(multipartFormData: { multipartFormData in
                if let image = newImage, let imgData = image.pngData() {
                    multipartFormData.append(imgData, withName: "profile_pic", fileName: "picture.png", mimeType: "image/png")
                }
                
                for (key, value) in paramDict {
                    if let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                        multipartFormData.append(data, withName: key)
                    }
                }
                
            }, with: urlRequest, encodingCompletion:{ encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                        NKActivityLoader.sharedInstance.hide()
                        print("RESPONSE",response.result.value as Any, response.response?.statusCode as Any)
                        if case .failure(let error) = response.result {
                            print("ERROR",error.localizedDescription)
                            self.view.showToast(error.localizedDescription)
                        }
                        else if case .success = response.result {
                            
                            if let result = response.result.value as? [String: AnyObject] {
                                if let statusCode = response.response?.statusCode {
                                    if statusCode == 200 {
                                        if let data = result["data"] as? [String:AnyObject] {
                                            if let userdetails = data["user"] as? [String:AnyObject] {
                                                LocalDB.shared.updateUserDetails(userdetails)
                                            }
                                        }
                                        if let msg = result["success_message"] as? String {
                                            self.view.showToast(msg)
                                        }
                                        if let imgStr = LocalDB.shared.driverDetails?.profilePictureUrl {
                                            self.profileView.activityIndicator.startAnimating()
                                            self.retriveImg(key: imgStr) { data in
                                                self.profileView.profpicBtn.setImage(UIImage(data: data), for: .normal)
                                                LocalDB.shared.profilePictureData = data
                                                self.profileView.activityIndicator.stopAnimating()
                                            }
                                        } else {
                                            self.profileView.profpicBtn.setImage(UIImage(named: "profileEditPlaceHolder"), for: .normal)
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
                case .failure(let encodingError):
                    
                    NKActivityLoader.sharedInstance.hide()
                    self.showAlert("text_Alert".localize(), message: encodingError.localizedDescription)
                }
            })
            
        } else {
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
    }
}
*/
