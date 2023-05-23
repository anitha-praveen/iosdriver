//
//  NytTimePictureUploadVC.swift
//  Roda Driver
//
//  Created by Apple on 01/07/22.
//

import UIKit
import Alamofire
import Kingfisher
class NytTimePictureUploadVC: UIViewController {

    let pictureUploadView = NytTimePictureUploadView()
    
    var callBack:((Bool)->())?
    var cancelCallBack:((Bool)->())?
    override func viewDidLoad() {
        super.viewDidLoad()

        MySocketManager.shared.socketDelegate = self
        pictureUploadView.setupViews(Base: self.view)
        
        if LocalDB.shared.currentTripDetail?.nytTimeDriverPhotoUploaded ?? false {
            self.pictureUploadView.viewContent.isHidden = true
            self.pictureUploadView.waitingView.isHidden = false
            
            if LocalDB.shared.currentTripDetail?.nytTimeUserPhotoUploaded ?? false {
                self.pictureUploadView.btnSkip.isHidden = true
                self.pictureUploadView.btnCancelTrip.isHidden = true
                
                self.pictureUploadView.btnConfirmPassenger.isHidden = false
                self.pictureUploadView.btnRetake.isHidden = false
            } else {
                self.pictureUploadView.btnSkip.isHidden = false
                self.pictureUploadView.btnCancelTrip.isHidden = false
                
                self.pictureUploadView.btnConfirmPassenger.isHidden = true
                self.pictureUploadView.btnRetake.isHidden = true
            }
        } else {
            self.pictureUploadView.viewContent.isHidden = false
            self.pictureUploadView.waitingView.isHidden = true
        }
        
        if let userImg = LocalDB.shared.currentTripDetail?.nytTimeUserPhotoUrl {
            if let url = URL(string: userImg) {
                let resource = ImageResource(downloadURL: url)
                pictureUploadView.imgview.kf.setImage(with: resource, placeholder: UIImage(named: "profilePlaceHolder"))
            }
        }
        
        setupTarget()
    }
    
    func setupTarget() {
        pictureUploadView.btnProceed.addTarget(self, action: #selector(takePicture(_ :)), for: .touchUpInside)
        pictureUploadView.btnSkip.addTarget(self, action: #selector(btnSkipPressed(_ :)), for: .touchUpInside)
        pictureUploadView.btnCancelTrip.addTarget(self, action: #selector(btnCancelTripPressed(_ :)), for: .touchUpInside)
        
        pictureUploadView.btnConfirmPassenger.addTarget(self, action: #selector(btnConfirmPassengerPressed(_ :)), for: .touchUpInside)
        pictureUploadView.btnRetake.addTarget(self, action: #selector(btnRetakePassengerPressed(_ :)), for: .touchUpInside)
    }
    
    @objc func takePicture(_ sender: UIButton) {
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let picker = UIImagePickerController()
            picker.allowsEditing = false
            picker.delegate = self
            picker.sourceType = UIImagePickerController.SourceType.camera
            picker.cameraDevice = .front
            picker.cameraCaptureMode = .photo
            picker.modalPresentationStyle = .fullScreen
            self.present(picker,animated: true,completion: nil)
        }
    }
    
    @objc func btnSkipPressed(_ sender: UIButton) {
        self.skipAndMove()
    }
    
    @objc func btnCancelTripPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.cancelCallBack?(true)
        }
    }
    
    @objc func btnConfirmPassengerPressed(_ sender: UIButton) {
        self.dismiss(animated: true) {
            self.callBack?(true)
        }
    }
    
    @objc func btnRetakePassengerPressed(_ sender: UIButton) {
        self.requestRetakePassengerPicture()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first, touch.view == self.view {
            self.dismiss(animated: true)
        }
    }
}

//MARK: -ImagePicker
extension NytTimePictureUploadVC: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            
            let orientationImg = selectedImage.fixedOrientation()
            self.uploadPhoto(orientationImg)
            
        } else if let selectedImage = info[.editedImage] as? UIImage {
            
            let orientationImg = selectedImage.fixedOrientation()
            self.uploadPhoto(orientationImg)
            
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}

//MARK: - API'S
extension NytTimePictureUploadVC {
    
    func skipAndMove() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "")
            
            var paramDict = Dictionary<String, Any>()
            paramDict["request_id"] = LocalDB.shared.currentTripDetail?.acceptedRequestId
            paramDict["skip"] = "1"
            
            let url = APIHelper.shared.BASEURL + APIHelper.skipNytTimePhoto
            
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { response in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any)
                
                switch response.result {
                case .success(_):
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode,statusCode == 200 {
                            LocalDB.shared.currentTripDetail?.isNytTimePhotoSkipped = true
                            self.dismiss(animated: true) {
                                self.callBack?(true)
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
        } else {
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
    }
    
    
    func requestRetakePassengerPicture() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "")
            
            var paramDict = Dictionary<String, Any>()
            paramDict["request_id"] = LocalDB.shared.currentTripDetail?.acceptedRequestId
         
            let url = APIHelper.shared.BASEURL + APIHelper.retakePassengerPhoto
            
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { response in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any)
                
                switch response.result {
                case .success(_):
                    if let result = response.result.value as? [String: AnyObject] {
                        if let statusCode = response.response?.statusCode,statusCode == 200 {
                            
                            LocalDB.shared.currentTripDetail?.nytTimeUserPhotoUploaded = false
                            self.pictureUploadView.btnSkip.isHidden = false
                            self.pictureUploadView.btnCancelTrip.isHidden = false
                            
                            self.pictureUploadView.btnConfirmPassenger.isHidden = true
                            self.pictureUploadView.btnRetake.isHidden = true
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
        } else {
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
    }
    
    func uploadPhoto(_ originalImage: UIImage) {
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
                                        if let data = result["data"] as? [String: AnyObject] {
                                            if let isDriverUploaded = data["driver_upload_image"] as? Bool, isDriverUploaded {
                                                LocalDB.shared.currentTripDetail?.nytTimeDriverPhotoUploaded = isDriverUploaded
                                                if let isUserUploaded = data["user_upload_image"] as? Bool,isUserUploaded {
                                                    LocalDB.shared.currentTripDetail?.nytTimeUserPhotoUploaded = isUserUploaded
                                                    self.dismiss(animated: true) {
                                                        self.callBack?(true)
                                                    }
                                                } else {
                                                    self.pictureUploadView.viewContent.isHidden = true
                                                    self.pictureUploadView.waitingView.isHidden = false
                                                }
                                            } else {
                                                self.view.showToast("txt_upload_photo_again".localize())
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

//MARK: - SOCKET DELEGATE
extension NytTimePictureUploadVC: MySocketManagerDelegate {
    
    func passengerPhotoUploaded(_ response: [String : AnyObject]) {
        print("passenger photo uploaded",response)
        if let result = response["result"] as? [String: AnyObject] {
            if let retakePhoto = result["retake_image"] as? Bool, retakePhoto {
                
                LocalDB.shared.currentTripDetail?.nytTimeDriverPhotoUploaded = false
                self.pictureUploadView.viewContent.isHidden = false
                self.pictureUploadView.waitingView.isHidden = true
                
                self.pictureUploadView.lblHint.text = "txt_retake_driver_desc".localize()
                
            } else if let uploadStatus = result["upload_status"] as? Bool {
                LocalDB.shared.currentTripDetail?.nytTimeUserPhotoUploaded = uploadStatus
                if LocalDB.shared.currentTripDetail?.nytTimeUserPhotoUploaded ?? false {
                    self.pictureUploadView.btnSkip.isHidden = true
                    self.pictureUploadView.btnCancelTrip.isHidden = true
                    
                    self.pictureUploadView.btnConfirmPassenger.isHidden = false
                    self.pictureUploadView.btnRetake.isHidden = false
                } else {
                    self.pictureUploadView.btnSkip.isHidden = false
                    self.pictureUploadView.btnCancelTrip.isHidden = false
                    
                    self.pictureUploadView.btnConfirmPassenger.isHidden = true
                    self.pictureUploadView.btnRetake.isHidden = true
                }
                
                if let userImg = result["upload_image_url"] as? String {
                    if let url = URL(string: userImg) {
                        let resource = ImageResource(downloadURL: url)
                        pictureUploadView.imgview.kf.setImage(with: resource, placeholder: UIImage(named: "profilePlaceHolder"))
                    }
                }
             }
        
        }
        
    }
}
