//
//  InstantRidePhotoUploadVC.swift
//  Roda Driver
//
//  Created by Apple on 13/07/22.
//

import UIKit
import Alamofire
import Kingfisher

class InstantRidePhotoUploadVC: UIViewController {

    let uploadPhotoView = InstantRidePhotoUploadView()
    
    var driverImgPicker = UIImagePickerController()
    var userImgPicker = UIImagePickerController()
    
    var driverImage: UIImage?
    var userImage: UIImage?
    override func viewDidLoad() {
        super.viewDidLoad()

        uploadPhotoView.setupViews(Base: self.view)
        setupTarget()
    }
    
    func setupTarget() {
        self.uploadPhotoView.driverImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(takePicture(_ :))))
        self.uploadPhotoView.userImg.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(takePicture(_ :))))
        
        self.uploadPhotoView.btnProceed.addTarget(self, action: #selector(btnProceedPressed(_ :)), for: .touchUpInside)
    }

    @objc func takePicture(_ sender: UITapGestureRecognizer) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            
            if sender.view == self.uploadPhotoView.driverImg {
                driverImgPicker.allowsEditing = false
                driverImgPicker.delegate = self
                driverImgPicker.sourceType = UIImagePickerController.SourceType.camera
                driverImgPicker.cameraDevice = .front
                driverImgPicker.cameraCaptureMode = .photo
                driverImgPicker.modalPresentationStyle = .fullScreen
                self.present(driverImgPicker,animated: true,completion: nil)
            } else if sender.view == self.uploadPhotoView.userImg {
                userImgPicker.allowsEditing = false
                userImgPicker.delegate = self
                userImgPicker.sourceType = UIImagePickerController.SourceType.camera
                userImgPicker.cameraDevice = .front
                userImgPicker.cameraCaptureMode = .photo
                userImgPicker.modalPresentationStyle = .fullScreen
                self.present(userImgPicker,animated: true,completion: nil)
            }
        }
    }
    
    @objc func btnProceedPressed(_ sender: UIButton) {
        if self.userImage == nil {
            if self.driverImage != nil {
                self.uploadDriverPhoto(self.driverImage ?? UIImage())
            } else {
                self.showAlert("", message: "Take your selfie photo")
            }
        } else {
            if self.driverImage != nil {
                self.uploadUserAndDriverPhoto()
            } else {
                self.showAlert("", message: "Take your selfie photo")
            }
        }
    }
    
}

//MARK: -ImagePicker
extension InstantRidePhotoUploadVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if picker == self.driverImgPicker {
            if let selectedImage = info[.originalImage] as? UIImage {
                let orientationImg = selectedImage.fixedOrientation()
                self.driverImage = orientationImg
                
            } else if let selectedImage = info[.editedImage] as? UIImage {
                let orientationImg = selectedImage.fixedOrientation()
                self.driverImage = orientationImg
            }
            self.uploadPhotoView.driverImg.image = self.driverImage
            picker.dismiss(animated: true, completion: nil)
        } else if picker == self.userImgPicker {
            if let selectedImage = info[.originalImage] as? UIImage {
                let orientationImg = selectedImage.fixedOrientation()
                self.userImage = orientationImg
            } else if let selectedImage = info[.editedImage] as? UIImage {
                let orientationImg = selectedImage.fixedOrientation()
                self.userImage = orientationImg
            }
            self.uploadPhotoView.userImg.image = self.userImage
            picker.dismiss(animated: true, completion: nil)
        }
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - API'S
extension InstantRidePhotoUploadVC {
    
    func uploadDriverPhoto(_ originalImage: UIImage) {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            var paramDict = Dictionary<String, Any>()
            paramDict["request_id"] = LocalDB.shared.currentTripDetail?.acceptedRequestId
            
            guard let urlRequest = try? URLRequest(url: APIHelper.shared.BASEURL + APIHelper.uploadNytTimePhoto, method: .post, headers: APIHelper.shared.authHeader) else {
                return
            }
           
            Alamofire.upload(multipartFormData: { multipartFormData in
                if let imgData = originalImage.pngData() {
                    multipartFormData.append(imgData, withName: "images", fileName: "picture.png", mimeType: "image/png")
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
                                        self.dismiss(animated: true) {
                                            self.view.showToast("photo uploaded successfully!")
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
    
    
    func uploadUserAndDriverPhoto() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            
            var paramDict = Dictionary<String, Any>()
            paramDict["request_id"] = LocalDB.shared.currentTripDetail?.acceptedRequestId
            
            guard let urlRequest = try? URLRequest(url: APIHelper.shared.BASEURL + APIHelper.uploadInstantDispatchPhoto, method: .post, headers: APIHelper.shared.authHeader) else {
                return
            }
           
            Alamofire.upload(multipartFormData: { multipartFormData in
                if let originalImage = self.userImage,let imgData = originalImage.pngData() {
                    multipartFormData.append(imgData, withName: "user_instant_image", fileName: "picture.png", mimeType: "image/png")
                }
                if let originalImage = self.driverImage,let imgData = originalImage.pngData() {
                    multipartFormData.append(imgData, withName: "driver_instant_image", fileName: "picture.png", mimeType: "image/png")
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
                                        self.dismiss(animated: true) {
                                            self.view.showToast("photo uploaded successfully!")
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
