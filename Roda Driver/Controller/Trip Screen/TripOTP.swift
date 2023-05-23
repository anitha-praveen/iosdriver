//
//  TripOTP.swift
//  Captain Car
//
//  Created by NPlus Technologies on 03/06/19.
//  Copyright © 2019 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import CoreLocation
class TripOTP: UIViewController {
    
    let tripOTPView = TripOTPView()
    
    var textFields:[UITextField] = []
    var callBack: ((_ response: [String: AnyObject], _ location: CLLocation, _ tripStartkm: String?) -> Void)?
    
    var selectedImage: UIImage?
    var tripStartKm = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupTarget()
    }
    
    //MARK: - Adding UI Elements In SetupViews
    
    func setupViews() {
        tripOTPView.setupViews(Base: self.view)
        self.setupTextFields()
    }
    
    func setupTarget() {
        tripOTPView.btnVerify.addTarget(self, action: #selector(btnVerifyPressed(_ :)), for: .touchUpInside)
        tripOTPView.btnCancel.addTarget(self, action: #selector(btnCancelPressed(_ :)), for: .touchUpInside)
        tripOTPView.submitBtn.addTarget(self, action: #selector(btnSubmitPressed(_ :)), for: .touchUpInside)
        tripOTPView.backButton.addTarget(self, action: #selector(backbtnAction(_ :)), for: .touchUpInside)
        tripOTPView.tripStartImgBtn.addTarget(self, action: #selector(uploadImage(_ :)), for: .touchUpInside)

//        tripOTPView.backButton.addG
    }
    
    //MARK: - Trip Start Action
    
    @objc func btnVerifyPressed(_ sender: UIButton) {
        let serviceCategory = LocalDB.shared.currentTripDetail?.choosenServiceCatagory
        if LocalDB.shared.currentTripDetail?.choosenServiceCatagory == "OUTSTATION" || serviceCategory == "RENTAL" {
            let textfieldTxt = "\(self.textFields.map({ $0.text! }).reduce("", { $0 + $1 }))"
            if textfieldTxt == "" {
                showAlert("", message: "txt_note_start_ride".localize())
            } else if textfieldTxt.count < 4 {
                showAlert("", message: "txt_enter_valid_otp".localize())
            } else if selectedImage != nil {
                if tripOTPView.tripstartTxtfield.text != "" {
                    self.startOutstationTrip()
                }
            } else {
                tripOTPView.viewContent.isHidden = true
                tripOTPView.tripDistanceView.isHidden = false
            }
            
        } else {
            self.startTheTrip()
        }
        
    }
    
    @objc func btnSubmitPressed(_ sender: UIButton) {
        if selectedImage == nil {
            showAlert("", message: "txt_upload_tripmeter_image".localize())
        }
        else if tripOTPView.tripstartTxtfield.text == "" {
            showAlert("", message: "txt_enter_trip_start_kilometres".localize())
        } else {
            self.startOutstationTrip()
        }
        
    }
    
    //MARK: - Cancel Button Action
    
    @objc func btnCancelPressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func backbtnAction(_ sender: UIButton) {
        tripOTPView.viewContent.isHidden = false
        tripOTPView.tripDistanceView.isHidden = true
    }
    
    @objc func uploadImage(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    

}

extension TripOTP: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        
        if let selectedImage = info[.originalImage] as? UIImage {
            
            let orientationImg = selectedImage.fixedOrientation()
            self.selectedImage = orientationImg
            tripOTPView.tripStartImgBtn.setImage(selectedImage, for: .normal)
            tripOTPView.tripStartImgBtn.layer.borderWidth = 0
        } else if let selectedImage = info[.editedImage] as? UIImage {
            
            let orientationImg = selectedImage.fixedOrientation()
            self.selectedImage = orientationImg
            tripOTPView.tripStartImgBtn.setImage(selectedImage, for: .normal)
            tripOTPView.tripStartImgBtn.layer.borderWidth = 0
        }
        
        
    }
    
}

extension TripOTP {
    
    func setupTextFields() {
        self.textFields = [tripOTPView.textField1,tripOTPView.textField2,tripOTPView.textField3,tripOTPView.textField4]
        self.textFields.forEach {
            $0.layer.cornerRadius = 5
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.hexToColor("D4D4D4").cgColor
            $0.textAlignment = .center
            $0.placeholder = "0"
            $0.text = ""
            $0.keyboardType = .numberPad
            $0.font = UIFont.appFont(ofSize: 20)
            $0.textColor = .themeColor
            $0.backgroundColor = .hexToColor("F5F5F5")
            $0.addTarget(self, action: #selector(textChanged(_:)), for: .editingChanged)
        }
    }
    

    
    func startTheTrip() {
        if ConnectionCheck.isConnectedToNetwork() {
            guard let myLocation = AppLocationManager.shared.locationManager.location else {
                self.showAlert("text_Alert".localize(), message: "txt_location_not_found".localize())
                return
            }
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityPulseData,nil)
            let coord = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
            self.getaddress(coord, completion: { address in
                
                let url = APIHelper.shared.BASEURL + APIHelper.startTripApi
                var paramdict = Dictionary<String, Any>()
                
                paramdict["request_id"] = LocalDB.shared.currentTripDetail?.acceptedRequestId
                paramdict["pick_lat"] = myLocation.coordinate.latitude
                paramdict["pick_lng"] = myLocation.coordinate.longitude
               
                paramdict["request_otp"] = self.textFields.map({ $0.text! }).reduce("", { $0 + $1 })
                
                print("URL & Parameters for Start Trip API  = ",url,paramdict)
                
                Alamofire.request(url, method:.post, parameters: paramdict, encoding: JSONEncoding.default, headers:APIHelper.shared.authHeader)
                    .responseJSON { response in
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                        print(response.result.value as Any)
                        switch response.result {
                        
                        case .success(_):
                            
                            if let result = response.result.value as? [String: AnyObject] {
                                if response.response?.statusCode == 200 {
                                    if let data = result["data"] as? [String: AnyObject] {
                                        if let tripData = data["data"] as? [String: AnyObject] {
                                            self.dismiss(animated: true) {
                                                self.callBack?(tripData, myLocation, "")
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
                        case .failure(let error):
                            self.view.showToast(error.localizedDescription)
                        }
                        
                    }
            })
        } else {
            
            self.showAlert("txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
        }
    }
    
    func startOutstationTrip() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            guard let myLocation = AppLocationManager.shared.locationManager.location else {
                self.showAlert("text_Alert".localize(), message: "txt_location_not_found".localize())
                return
            }
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityPulseData,nil)
            let coord = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
            self.getaddress(coord, completion: { address in
                
                guard let urlRequest = try? URLRequest(url: APIHelper.shared.BASEURL + APIHelper.startTripApi, method: .post, headers: APIHelper.shared.authHeader) else {
                    return
                }
                
                var newImage: UIImage? = nil
                newImage = self.selectedImage
                while let image = newImage, let imgData = image.pngData(), imgData.count > 1999999 {
                    newImage = newImage?.resized(withPercentage: 0.5)
                }
                
                var paramdict = Dictionary<String, Any>()
                
                paramdict["request_id"] = LocalDB.shared.currentTripDetail?.acceptedRequestId
                paramdict["pick_lat"] = "\(myLocation.coordinate.latitude)"
                paramdict["pick_lng"] = "\(myLocation.coordinate.longitude)"
                paramdict["request_otp"] = self.textFields.map({ $0.text! }).reduce("", { $0 + $1 })
                
                if let startKm = self.tripOTPView.tripstartTxtfield.text {
                    print("START KM",startKm)
                    self.tripStartKm = startKm
                    print("START KM...",self.tripStartKm)
                    paramdict["start_km"] = startKm
                }
                
                
                print("URL & Parameters for Outstation Start Trip API  = ",urlRequest,paramdict)
                
                Alamofire.upload(multipartFormData: { multipartFormData in
                    if let image = newImage, let imgData = image.pngData() {
                        multipartFormData.append(imgData, withName: "trip_image", fileName: "picture.png", mimeType: "image/png")
                    }
                    for (key, value) in paramdict
                    {
                        if let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                    
                }, with: urlRequest, encodingCompletion:{ encodingResult in
                    switch encodingResult {
                    case .success(let upload, _, _):
                        upload.responseJSON { response in
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                            print(response.result.value as Any)
                            switch response.result {
                            
                            case .success(_):
                                
                                if let result = response.result.value as? [String: AnyObject] {
                                    if response.response?.statusCode == 200 {
                                        if let data = result["data"] as? [String: AnyObject] {
                                            if let tripData = data["data"] as? [String: AnyObject] {
                                                self.dismiss(animated: true) {
                                                    print("START KM SENT...",self.tripStartKm)
                                                    self.callBack?(tripData, myLocation, self.tripStartKm)
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
                                        self.tripOTPView.viewContent.isHidden = false
                                        self.tripOTPView.tripDistanceView.isHidden = true
                                    }
                                }
                            case .failure(let error):
                                self.view.showToast(error.localizedDescription)
                            }
                            
                        }
                    case .failure(let encodingError):
                       
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                        self.showAlert("text_Alert".localize(), message: encodingError.localizedDescription)
                    }
                })
            })
        } else {
            
            self.showAlert("txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
        }
    }
    
    
}
extension TripOTP {
    //MARK: - TextField Action
    
    @objc func textChanged(_ sender:UITextField) {
        if sender.text!.count > 1 {
            sender.text = String(sender.text!.first!)
        } else if sender.text?.count == 1 {
            for (index,textField) in textFields.enumerated() where textField == sender {
                if textFields.indices.contains(index+1) {
                    textFields[index+1].becomeFirstResponder()
                } else {
                    textField.resignFirstResponder()
                }
            }
        } else if sender.text!.isEmpty {
            for (index,textField) in textFields.enumerated() where textField == sender {
                if textFields.indices.contains(index-1) {
                    textFields[index-1].becomeFirstResponder()
                } else {
                }
            }
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == self.view {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
