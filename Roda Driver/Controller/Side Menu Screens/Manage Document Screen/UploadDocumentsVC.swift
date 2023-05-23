//
//  UploadDocumentsVC.swift
//  Taxiappz Driver
//
//  Created by NPlus Technologies on 07/01/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import Kingfisher


class UploadDocumentsVC: UIViewController {

    var uploadDocumentsView = UploadDocumentsView()
    var picker = UIImagePickerController()
    
    var docDetail: DocumentList?
  
    var callBack:((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        setupViews()
        setupTargets()
        setupData()
        
    }
    
    func setupViews() {
        uploadDocumentsView.setupViews(Base: self.view)
        
        uploadDocumentsView.docImgCollectionView.delegate = self
        uploadDocumentsView.docImgCollectionView.dataSource = self
        uploadDocumentsView.docImgCollectionView.register(DocumentImageCollectionViewCell.self, forCellWithReuseIdentifier: "DocumentImageCollectionViewCell")
        
     
        uploadDocumentsView.docImgCollectionView.reloadData()
    
    }

    func setupTargets() {
        
        uploadDocumentsView.btnBack.addTarget(self, action: #selector(btnBackPressed(_ :)), for: .touchUpInside)
        uploadDocumentsView.uploadBtn.addTarget(self, action: #selector(btnUploadDocPressed(_ :)), for: .touchUpInside)
        
    }
   
    func setupData() {
       
        uploadDocumentsView.documentNameLbl.text = self.docDetail?.documentName
        
        uploadDocumentsView.docNumTitleLbl.text = self.docDetail?.documentName ?? "" + " " + "txt_number".localize()
        uploadDocumentsView.docNumTxtField.placeholder = self.docDetail?.documentName ?? "" + " " + "txt_number".localize()
        
        let identifierArr = self.docDetail?.subDocument?.filter({$0.isIdentifierNeeded ?? false})
        if identifierArr?.count ?? 0 > 0 {
            uploadDocumentsView.docNumberView.isHidden = false
            if let number = self.docDetail?.subDocument?.first?.identifierValue {
                uploadDocumentsView.docNumTxtField.text = number
            }
        } else {
            uploadDocumentsView.docNumberView.isHidden = true
        }
        
        let expiryDate = self.docDetail?.subDocument?.filter({$0.dateRequried != "0"})
        if expiryDate?.count ?? 0 > 0 {
            if ((expiryDate?.first(where: {$0.dateRequried == "1"})) != nil) {
                uploadDocumentsView.expDateView.isHidden = false
                uploadDocumentsView.issueDateView.isHidden = true
            } else if ((expiryDate?.first(where: {$0.dateRequried == "2"})) != nil) {
                uploadDocumentsView.expDateView.isHidden = true
                uploadDocumentsView.issueDateView.isHidden = false
            } else {
                uploadDocumentsView.expDateView.isHidden = true
                uploadDocumentsView.issueDateView.isHidden = true
            }
            
            self.uploadDocumentsView.expDateTxtField.text = self.docDetail?.subDocument?.first?.exDate
            self.uploadDocumentsView.issueDateTxtField.text = self.docDetail?.subDocument?.first?.issuseDate
        }
      
        
    }
    
    @objc func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func openCamera(_ tag: Int) {
        let alert = UIAlertController(title: "text_Please_Select_an_Option".localize(), message: "", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "text_camera".localize(), style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.tabBarItem.tag = tag
                self.picker.delegate = self
                self.picker.sourceType = UIImagePickerController.SourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
            }
            else {
                self.showAlert("", message: "txt_no_camera".localize())
            }
        }
        let gallery = UIAlertAction(title: "text_galary".localize(), style: .default) { (action) in
            self.picker.delegate = self
            self.picker.tabBarItem.tag = tag
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "text_cancel".localize(), style: .cancel, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    @objc func btnUploadDocPressed(_ sender: UIButton) {
        
        self.validateDocumetDetail { err in
            if err != "" {
                self.showAlert("", message: err)
            } else {
                if ConnectionCheck.isConnectedToNetwork() {
                    NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityData, nil)
                    if let subDoc = self.docDetail?.subDocument {
                        let group = DispatchGroup()
                        for doc in subDoc {
                            
                            group.enter()
                            if doc.pickerImage == nil && doc.documentImg == nil {
                                group.leave()
                            } else {
                                self.uploadDocument(doc) { uplaoded in
                                    group.leave()
                                }
                            }
                        }
                        group.notify(queue: .main) {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            self.callBack?(true)
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }
                } else {
                    self.showAlert( "txt_NoInternet".localize(), message: "")
                }
            }
        }
        
    }
    
    func validateDocumetDetail(completion:@escaping(String)->Void) {
        let subDoc = self.docDetail?.subDocument
        var err = ""
        if !uploadDocumentsView.docNumberView.isHidden && uploadDocumentsView.docNumTxtField.text == "" {
            err = "txt_enter_number".localize()
        } else if !uploadDocumentsView.expDateView.isHidden && uploadDocumentsView.expDateTxtField.text == "" {
            err = "text_error_doc_expiry_empty".localize()
        } else if !uploadDocumentsView.issueDateView.isHidden && uploadDocumentsView.issueDateTxtField.text == "" {
            err = "txt_errror_issue_date_empty".localize()
        } else if subDoc?.filter({$0.pickerImage != nil}).count == 0 && subDoc?.filter({$0.documentImg != nil}).count == 0 {
            err = "text_error_doc_pic_empty".localize()
        }
        completion(err)
    }
   
}

//MARK: - Collectionview Delegate
extension UploadDocumentsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.docDetail?.subDocument?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentImageCollectionViewCell", for: indexPath) as? DocumentImageCollectionViewCell ?? DocumentImageCollectionViewCell()
        
        let data = self.docDetail?.subDocument?[indexPath.row]

        cell.docTitleLbl.text = data?.documentName
        
        
        if let imgStr = data?.documentImg, let url = URL(string: imgStr) {
            cell.docImgView.kf.indicatorType = .activity
            let resource = ImageResource(downloadURL: url)
            cell.docImgView.kf.setImage(with: resource, placeholder: UIImage(named: "uploadImg11"), options: nil, progressBlock: nil, completionHandler: nil)
            self.docDetail?.subDocument?[indexPath.row].pickerImage = cell.docImgView.image
//            KingfisherManager.shared.retrieveImage(with: url, options: nil, progressBlock: nil, completionHandler: { image in
//                self.docDetail?.subDocument?[indexPath.row].pickerImage = image
//            })
        } else {
            cell.docImgView.image = UIImage(named: "uploadImg11")
        }
        
        if let docImg = data?.pickerImage {
            cell.docImgView.image = docImg
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.openCamera(indexPath.row)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width/2-20 , height: 125)
       
    }
    
}

extension UploadDocumentsVC: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

       
        if let image = info[.originalImage] as? UIImage {
            let orientationImg = image.fixedOrientation()
            self.docDetail?.subDocument?[picker.tabBarItem.tag].pickerImage = orientationImg
        } else if let editImg = info[.editedImage] as? UIImage {
            let orientationImg = editImg.fixedOrientation()
            self.docDetail?.subDocument?[picker.tabBarItem.tag].pickerImage = orientationImg
        }
        picker.dismiss(animated: true, completion: nil)
        self.uploadDocumentsView.docImgCollectionView.reloadData()
    }
    
}

//MARK: - API'S

extension UploadDocumentsVC {
    
    func uploadDocument(_ document: SubDocumentList?, completion: @escaping(Bool)->Void) {
        
        if ConnectionCheck.isConnectedToNetwork() {
            
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityData)
            
            var paramDict = Dictionary<String,Any>()
            
            paramDict["document_id"] = document?.slug
            if self.uploadDocumentsView.expDateTxtField.text != "" {
                paramDict["expiry_date"] = self.uploadDocumentsView.expDateTxtField.text
            }
            if self.uploadDocumentsView.issueDateTxtField.text != "" {
                paramDict["issue_date"] = self.uploadDocumentsView.issueDateTxtField.text
            }
            if self.uploadDocumentsView.docNumTxtField.text != "" {
                paramDict["identifier"] = self.uploadDocumentsView.docNumTxtField.text
            }
            
            print(paramDict)
            guard let urlRequest = try? URLRequest(url: APIHelper.shared.BASEURL + APIHelper.uploadDocument, method: .post, headers: APIHelper.shared.authHeader) else {
                return
            }
            var newImage: UIImage? = nil
            newImage = document?.pickerImage
            while let image = newImage, let imgData = image.pngData(), imgData.count > 1999999 {
                newImage = newImage?.resized(withPercentage: 0.5)
            }
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                if let image = newImage, let imgData = image.pngData() {
                    multipartFormData.append(imgData, withName: "document_image", fileName: "picture.png", mimeType: "image/png")
                    
                }
                for (key, value) in paramDict
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
                        if case .failure(let error) = response.result
                        {
                            self.showAlert("", message: error.localizedDescription)
                            completion(false)
                        }
                        else if case .success = response.result
                        {
                            
                            guard let result = response.result.value as? [String: AnyObject] else {
                                return
                            }
                            if response.response?.statusCode == 200 {

                                completion(true)
                                self.callBack?(true)
                                self.navigationController?.popViewController(animated: true)
                                
                                
                            } else {
                                if let error = result["data"] as? [String:[String]] {
                                    let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                                    self.showAlert("", message: errMsg)
                                } else if let errMsg = result["error_message"] as? String {
                                    self.showAlert("", message: errMsg)
                                } else if let msg = result["message"] as? String {
                                    self.showAlert("", message: msg)
                                }
                                completion(false)
                                
                            }
                        }
                    }
                case .failure(let encodingError):
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self.showAlert("text_Alert".localize(), message: encodingError.localizedDescription)
                    completion(false)
                }
            })
            
        } else {
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
      
    }
}

/*
 // Using S3
class UploadDocumentsVC: UIViewController {

    var uploadDocumentsView = UploadDocumentsView()
    var picker = UIImagePickerController()
    
    var docDetail: DocumentList?
  
    var callBack:((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        setupViews()
        setupTargets()
        setupData()
        
    }
    
    func setupViews() {
        uploadDocumentsView.setupViews(Base: self.view)
        
        uploadDocumentsView.docImgCollectionView.delegate = self
        uploadDocumentsView.docImgCollectionView.dataSource = self
        uploadDocumentsView.docImgCollectionView.register(DocumentImageCollectionViewCell.self, forCellWithReuseIdentifier: "DocumentImageCollectionViewCell")
        
     
        uploadDocumentsView.docImgCollectionView.reloadData()
    
    }

    func setupTargets() {
        
        uploadDocumentsView.btnBack.addTarget(self, action: #selector(btnBackPressed(_ :)), for: .touchUpInside)
        uploadDocumentsView.uploadBtn.addTarget(self, action: #selector(btnUploadDocPressed(_ :)), for: .touchUpInside)
        
    }
   
    func setupData() {
       
        uploadDocumentsView.documentNameLbl.text = self.docDetail?.documentName
        
        uploadDocumentsView.docNumTitleLbl.text = self.docDetail?.documentName ?? "" + " " + "txt_number".localize()
        uploadDocumentsView.docNumTxtField.placeholder = self.docDetail?.documentName ?? "" + " " + "txt_number".localize()
        
        let identifierArr = self.docDetail?.subDocument?.filter({$0.isIdentifierNeeded ?? false})
        if identifierArr?.count ?? 0 > 0 {
            uploadDocumentsView.docNumberView.isHidden = false
            if let number = self.docDetail?.subDocument?.first?.identifierValue {
                uploadDocumentsView.docNumTxtField.text = number
            }
        } else {
            uploadDocumentsView.docNumberView.isHidden = true
        }
        
        let expiryDate = self.docDetail?.subDocument?.filter({$0.dateRequried != "0"})
        if expiryDate?.count ?? 0 > 0 {
            if ((expiryDate?.first(where: {$0.dateRequried == "1"})) != nil) {
                uploadDocumentsView.expDateView.isHidden = false
                uploadDocumentsView.issueDateView.isHidden = true
            } else if ((expiryDate?.first(where: {$0.dateRequried == "2"})) != nil) {
                uploadDocumentsView.expDateView.isHidden = true
                uploadDocumentsView.issueDateView.isHidden = false
            } else {
                uploadDocumentsView.expDateView.isHidden = true
                uploadDocumentsView.issueDateView.isHidden = true
            }
            
            self.uploadDocumentsView.expDateTxtField.text = self.docDetail?.subDocument?.first?.exDate
            self.uploadDocumentsView.issueDateTxtField.text = self.docDetail?.subDocument?.first?.issuseDate
        }
      
        
    }
    
    @objc func btnBackPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    func openCamera(_ tag: Int) {
        let alert = UIAlertController(title: "text_Please_Select_an_Option".localize(), message: "", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "text_camera".localize(), style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.tabBarItem.tag = tag
                self.picker.delegate = self
                self.picker.sourceType = UIImagePickerController.SourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
            }
            else {
                self.showAlert("", message: "txt_no_camera".localize())
            }
        }
        let gallery = UIAlertAction(title: "text_galary".localize(), style: .default) { (action) in
            self.picker.delegate = self
            self.picker.tabBarItem.tag = tag
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "text_cancel".localize(), style: .cancel, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    @objc func btnUploadDocPressed(_ sender: UIButton) {
        
        self.validateDocumetDetail { err in
            if err != "" {
                self.showAlert("", message: err)
            } else {
                if ConnectionCheck.isConnectedToNetwork() {
                    NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityData, nil)
                    if let subDoc = self.docDetail?.subDocument {
                        let group = DispatchGroup()
                        for doc in subDoc {
                            
                            group.enter()
                            if doc.pickerImage == nil && doc.documentImg == nil {
                                group.leave()
                            } else {
                                self.uploadDocument(doc) { uplaoded in
                                    group.leave()
                                }
                            }
                        }
                        group.notify(queue: .main) {
                            NVActivityIndicatorPresenter.sharedInstance.stopAnimating(nil)
                            self.callBack?(true)
                            self.navigationController?.popViewController(animated: true)
                        }
                        
                    }
                } else {
                    self.showAlert( "txt_NoInternet".localize(), message: "")
                }
            }
        }
        
    }
    
    func validateDocumetDetail(completion:@escaping(String)->Void) {
        let subDoc = self.docDetail?.subDocument
        var err = ""
        if !uploadDocumentsView.docNumberView.isHidden && uploadDocumentsView.docNumTxtField.text == "" {
            err = "txt_enter_number".localize()
        } else if !uploadDocumentsView.expDateView.isHidden && uploadDocumentsView.expDateTxtField.text == "" {
            err = "text_error_doc_expiry_empty".localize()
        } else if !uploadDocumentsView.issueDateView.isHidden && uploadDocumentsView.issueDateTxtField.text == "" {
            err = "txt_errror_issue_date_empty".localize()
        } else if subDoc?.filter({$0.pickerImage != nil}).count == 0 && subDoc?.filter({$0.documentImg != nil}).count == 0 {
            err = "text_error_doc_pic_empty".localize()
        }
        completion(err)
    }
   
}

//MARK: - Collectionview Delegate
extension UploadDocumentsVC: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.docDetail?.subDocument?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DocumentImageCollectionViewCell", for: indexPath) as? DocumentImageCollectionViewCell ?? DocumentImageCollectionViewCell()
        
        let data = self.docDetail?.subDocument?[indexPath.row]

        cell.docTitleLbl.text = data?.documentName
        
        if let imgStr = data?.documentImg, !imgStr.isEmpty {
            cell.activityIndicator.startAnimating()
            self.retriveImgFromBucket(key: imgStr) { image in
                cell.activityIndicator.stopAnimating()
                cell.docImgView.image = image
                self.docDetail?.subDocument?[indexPath.row].pickerImage = image
            }
        } else {
            cell.docImgView.image = UIImage(named: "uploadImg11")
        }
        
        if let docImg = data?.pickerImage {
            cell.docImgView.image = docImg
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        self.openCamera(indexPath.row)
    
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width/2-20 , height: 125)
       
    }
    
}

extension UploadDocumentsVC: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {

       
        if let image = info[.originalImage] as? UIImage {
            let orientationImg = image.fixedOrientation()
            self.docDetail?.subDocument?[picker.tabBarItem.tag].pickerImage = orientationImg
        } else if let editImg = info[.editedImage] as? UIImage {
            let orientationImg = editImg.fixedOrientation()
            self.docDetail?.subDocument?[picker.tabBarItem.tag].pickerImage = orientationImg
        }
        picker.dismiss(animated: true, completion: nil)
        self.uploadDocumentsView.docImgCollectionView.reloadData()
    }
    
}

//MARK: - API'S

extension UploadDocumentsVC {
    
    func uploadDocument(_ document: SubDocumentList?, completion: @escaping(Bool)->Void) {
        
        if ConnectionCheck.isConnectedToNetwork() {
            
            var paramDict = Dictionary<String,Any>()
            
            paramDict["document_id"] = document?.slug
            if self.uploadDocumentsView.expDateTxtField.text != "" {
                paramDict["expiry_date"] = self.uploadDocumentsView.expDateTxtField.text
            }
            if self.uploadDocumentsView.issueDateTxtField.text != "" {
                paramDict["issue_date"] = self.uploadDocumentsView.issueDateTxtField.text
            }
            if self.uploadDocumentsView.docNumTxtField.text != "" {
                paramDict["identifier"] = self.uploadDocumentsView.docNumTxtField.text
            }
            
            print(paramDict)
            guard let urlRequest = try? URLRequest(url: APIHelper.shared.BASEURL + APIHelper.uploadDocument, method: .post, headers: APIHelper.shared.authHeader) else {
                return
            }
            var newImage: UIImage? = nil
            newImage = document?.pickerImage
            while let image = newImage, let imgData = image.pngData(), imgData.count > 1999999 {
                newImage = newImage?.resized(withPercentage: 0.5)
            }
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                if let image = newImage, let imgData = image.pngData() {
                    multipartFormData.append(imgData, withName: "document_image", fileName: "picture.png", mimeType: "image/png")
                    
                }
                for (key, value) in paramDict
                {
                    if let data = (value as AnyObject).data(using: String.Encoding.utf8.rawValue) {
                        multipartFormData.append(data, withName: key)
                       
                    }
                }
                
            }, with: urlRequest, encodingCompletion:{ encodingResult in
                switch encodingResult {
                case .success(let upload, _, _):
                    upload.responseJSON { response in
                       
                        print(response.result.value as Any)
                        if case .failure(let error) = response.result
                        {
                            self.showAlert("", message: error.localizedDescription)
                            completion(false)
                        }
                        else if case .success = response.result
                        {
                            
                            guard let result = response.result.value as? [String: AnyObject] else {
                                return
                            }
                            if response.response?.statusCode == 200 {

                                completion(true)
                                
                            } else {
                                if let error = result["data"] as? [String:[String]] {
                                    let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                                    self.showAlert("", message: errMsg)
                                } else if let errMsg = result["error_message"] as? String {
                                    self.showAlert("", message: errMsg)
                                } else if let msg = result["message"] as? String {
                                    self.showAlert("", message: msg)
                                }
                                completion(false)
                                
                            }
                        }
                    }
                case .failure(let encodingError):
                
                    self.showAlert("text_Alert".localize(), message: encodingError.localizedDescription)
                    completion(false)
                }
            })
            
        } else {
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
      
    }
}
*/

/*
class UploadDocumentsVC: UIViewController {
    
    let uploadDocumentView = UploadDocumentView()
    var picker = UIImagePickerController()
    
    var docDetail: DocumentList?
    var callBack:((Bool) -> Void)?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupData()
    }
    
    func setupViews() {
        uploadDocumentView.setupViews(Base: self.view)
        setuptarget()
        
    }
    
    func setuptarget() {
        uploadDocumentView.imgBtn.addTarget(self, action: #selector(openCamera(_ :)), for: .touchUpInside)
        uploadDocumentView.btnUpload.addTarget(self, action: #selector(btnUploadPressed(_ :)), for: .touchUpInside)
        uploadDocumentView.btnClose.addTarget(self, action: #selector(btnClosePressed(_ :)), for: .touchUpInside)
    }
    
    func setupData() {
        self.uploadDocumentView.lblTitle.text = self.docDetail?.documentName
        /*
        
        if self.docDetail?.isUpload ?? false {
            if let doc = self.docDetail?.documentImg {
              self.uploadDocumentView.activityIndicator.startAnimating()
                self.retriveImg(key: doc) { data in
                    print("IMAGE DATA",data)
                    self.uploadDocumentView.imgBtn.setImage(UIImage(data: data), for: .normal)
                  self.uploadDocumentView.activityIndicator.stopAnimating()
                }
            }
        } else {
            uploadDocumentView.imgBtn.setImage(UIImage(named: "uploadImg"), for: .normal)
            uploadDocumentView.imgBtn.contentMode = .scaleAspectFit
        }

        if self.docDetail?.dateRequried == "1" {
            if self.docDetail?.isUpload ?? false {
                uploadDocumentView.txtExpiry.text = self.docDetail?.exDate
            }
            self.uploadDocumentView.txtExpiry.isHidden = false
            self.uploadDocumentView.txtIssuseDate.isHidden = true
        } else if self.docDetail?.dateRequried == "2" {
            if self.docDetail?.isUpload ?? false {
                uploadDocumentView.txtIssuseDate.text = self.docDetail?.issuseDate
            }
            self.uploadDocumentView.txtExpiry.isHidden = true
            self.uploadDocumentView.txtIssuseDate.isHidden = false
        } else {
            self.uploadDocumentView.txtExpiry.isHidden = true
            self.uploadDocumentView.txtIssuseDate.isHidden = true
        }
        
        if self.docDetail?.isIdentifierNeeded ?? false {
            self.uploadDocumentView.viewIdentifier.isHidden = false
            if let identifierName = self.docDetail?.documentName {
                self.uploadDocumentView.lblIdentifierName.text = "txt_enter".localize() + " " + identifierName + " " + "txt_number".localize()
            }
            if let identifierNumber = self.docDetail?.identifierValue {
                self.uploadDocumentView.txtIdentifier.text = identifierNumber
            }
        } else {
            self.uploadDocumentView.viewIdentifier.isHidden = true
        }
        */
    }
    
    @objc func openCamera(_ sender: UIButton) {
        let alert = UIAlertController(title: "text_Please_Select_an_Option".localize(), message: "", preferredStyle: .actionSheet)
        let camera = UIAlertAction(title: "text_camera".localize(), style: .default) { (action) in
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                self.picker.allowsEditing = false
                self.picker.delegate = self
                self.picker.sourceType = UIImagePickerController.SourceType.camera
                self.picker.cameraCaptureMode = .photo
                self.picker.modalPresentationStyle = .fullScreen
                self.present(self.picker,animated: true,completion: nil)
            }
            else {
                self.showAlert("", message: "txt_no_camera".localize())
            }
        }
        let gallery = UIAlertAction(title: "text_galary".localize(), style: .default) { (action) in
            self.picker.delegate = self
            self.picker.allowsEditing = false
            self.picker.sourceType = .photoLibrary
            self.picker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
            self.present(self.picker, animated: true, completion: nil)
        }
        let cancel = UIAlertAction(title: "text_cancel".localize(), style: .cancel, handler: nil)
        alert.addAction(camera)
        alert.addAction(gallery)
        alert.addAction(cancel)
        self.present(alert, animated: true)
       
    }
   
    
    @objc func btnUploadPressed(_ sender: UIButton) {
/*
        if let btnImg = self.uploadDocumentView.imgBtn.imageView?.image, btnImg.isEqual(UIImage(named: "uploadImg")) {
            self.showAlert("", message: "text_error_doc_pic_empty".localize())
        } else if self.docDetail?.dateRequried == "1" && self.uploadDocumentView.txtExpiry.text == "" {
            
            self.showAlert("", message: "text_error_doc_expiry_empty".localize())
            
        } else if self.docDetail?.dateRequried == "2" && self.uploadDocumentView.txtIssuseDate.text == "" {
           
            self.showAlert("", message: "txt_errror_issue_date_empty".localize())
          
        } else if (self.docDetail?.isIdentifierNeeded ?? false) && self.uploadDocumentView.txtIdentifier.text == "" {
            self.showAlert("", message: "txt_enter_number".localize())
        } else {
            self.uploadDocument()
        }
        */
    }
    
    @objc func btnClosePressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}
 

extension UploadDocumentsVC: UINavigationControllerDelegate,UIImagePickerControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            let orientationImg = image.fixedOrientation()
            self.uploadDocumentView.imgBtn.setImage(orientationImg, for: .normal)
           
        } else if let editImg = info[.editedImage] as? UIImage {
            let orientationImg = editImg.fixedOrientation()
            self.uploadDocumentView.imgBtn.setImage(orientationImg, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
}

//MARK:- API'S

extension UploadDocumentsVC {
    
    func uploadDocument() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityData)
            
            var paramDict = Dictionary<String,Any>()
            
            paramDict["document_id"] = self.docDetail?.slug
            
            if self.uploadDocumentView.txtExpiry.text != "" {
                paramDict["expiry_date"] = self.uploadDocumentView.txtExpiry.text
            }
            if self.uploadDocumentView.txtIssuseDate.text != "" {
                paramDict["issue_date"] = self.uploadDocumentView.txtIssuseDate.text
            }
            if self.uploadDocumentView.txtIdentifier.text != "" {
                paramDict["identifier"] = self.uploadDocumentView.txtIdentifier.text
            }
            print(paramDict)
            guard let urlRequest = try? URLRequest(url: APIHelper.shared.BASEURL + APIHelper.uploadDocument, method: .post, headers: APIHelper.shared.authHeader) else {
                return
            }
            var newImage: UIImage? = nil
            newImage = uploadDocumentView.imgBtn.imageView?.image
            while let image = newImage, let imgData = image.pngData(), imgData.count > 1999999 {
                newImage = newImage?.resized(withPercentage: 0.5)
            }
            
            Alamofire.upload(multipartFormData: { multipartFormData in
                if let image = newImage, let imgData = image.pngData() {
                    multipartFormData.append(imgData, withName: "document_image", fileName: "picture.png", mimeType: "image/png")
                }
                for (key, value) in paramDict
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
                        if case .failure(let error) = response.result
                        {
                            self.showAlert("", message: error.localizedDescription)
                           
                        }
                        else if case .success = response.result
                        {
                            guard let result = response.result.value as? [String: AnyObject] else {
                                return
                            }
                            if response.response?.statusCode == 200 {
                                self.callBack?(true)
                                self.navigationController?.popViewController(animated: true)
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
                case .failure(let encodingError):
                   
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    self.showAlert("text_Alert".localize(), message: encodingError.localizedDescription)
                }
            })
            
        } else {
            self.showAlert( "txt_NoInternet".localize(), message: "")
        }
    }
}

*/
