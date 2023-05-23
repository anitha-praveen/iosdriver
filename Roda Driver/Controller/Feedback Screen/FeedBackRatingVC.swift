//
//  FeedBackRatingVC.swift
//  Taxiappz
//
//  Created by Apple on 18/06/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import Kingfisher
import Alamofire
import NVActivityIndicatorView
import GoogleMaps
/*
class FeedBackRatingVC: UIViewController {
    
    let feedbackView = FeedBackRatingView()
    var tripinvoicedetdict = [String:AnyObject]()
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.isHidden = true
        setupView()
    }
    
    func setupView() {
        
        feedbackView.setupViews(Base: self.view, controller: self)
        feedbackView.commentView.delegate = self
        feedbackView.btnSubmit.addTarget(self, action: #selector(submitbuttonPressed(_ :)), for: .touchUpInside)
        setupData()
    }
    
    func setupData() {
        
        feedbackView.lblHowisTrip.text = "txt_how_is_trip".localize().uppercased()
        feedbackView.lblHint.text = "txt_feed_desc".localize()
        feedbackView.btnSubmit.setTitle("text_submit".localize().uppercased(), for: .normal)
        
        
        if let profilePic = LocalDB.shared.currentTripDetail?.customerDetails.profilePicture {
            self.retriveImgFromBucket(key: profilePic) { image in
                self.feedbackView.imgProfile.image = image
            }
            
        }
        if let firstName = LocalDB.shared.currentTripDetail?.customerDetails.firstName {
            let str = firstName
            self.feedbackView.lblDriverName.text = str.localizedCapitalized
        }
       

    }
   
    
    @objc func submitbuttonPressed(_ sender: UIButton) {
        if feedbackView.rating.value < 0 {
            self.showAlert("",message: "txt_rate_user".localize())
        }else if feedbackView.rating.value > 0.0 && feedbackView.rating.value < 3.0 && self.feedbackView.commentView.text == "" {
           
            self.showAlert("comments_left_empty".localize())
        } else {
            self.applyRating()
        }

    }
    
    func applyRating() {
        if ConnectionCheck.isConnectedToNetwork() {
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityData)
           
            var paramDict = Dictionary<String, Any>()
            
            paramDict["request_id"] = LocalDB.shared.currentTripDetail?.acceptedRequestId
            paramDict["rating"] =  String(format: "%.2f", feedbackView.rating.value)
            if self.feedbackView.commentView.text != "" {
                paramDict["feedback"] = self.feedbackView.commentView.text
            }
          
            
            print(paramDict)
            let url = APIHelper.shared.BASEURL + APIHelper.rateUser
            print(url)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String:AnyObject] {
                        if response.response?.statusCode == 200 {
                            self.showToast("text_rating_success".localize())
                            self.navigationController?.navigationBar.isHidden = true
                            LocalDB.shared.currentTripDetail = nil
                            self.navigationController?.popToRootViewController(animated: true)
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

extension FeedBackRatingVC: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count // for Swift use count(newText)
        return numberOfChars < 100
    }
}
*/

class FeedBackRatingVC: UIViewController {

    let feedbackView = FeedBackRatingView()
    var tripinvoicedetdict = [String:AnyObject]()
    
    var txtViewPlaceHolder = "txt_additional_cmt".localize()
    override var preferredStatusBarStyle: UIStatusBarStyle {
          return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setNeedsStatusBarAppearanceUpdate()
        self.navigationController?.navigationBar.isHidden = true
        setupView()
        currentLocation()
    }
    
    
    func setupView() {
      
        feedbackView.setupViews(Base: self.view, controller: self)
        feedbackView.commentView.delegate = self
        feedbackView.btnSubmit.addTarget(self, action: #selector(submitbuttonPressed(_ :)), for: .touchUpInside)
        setupData()
    }
    
    func setupData() {
        
        feedbackView.lblHowisTrip.text = "txt_how_is_trip".localize()
        feedbackView.lblHint.text = "txt_feed_desc".localize()
        feedbackView.commentView.text = txtViewPlaceHolder
        feedbackView.btnSubmit.setTitle("txt_submit_review".localize(), for: .normal)
        
        
        if let imgStr = LocalDB.shared.currentTripDetail?.customerDetails.profilePicture, let url = URL(string: imgStr) {
            self.feedbackView.imgProfile.kf.indicatorType = .activity
            let resource = ImageResource(downloadURL: url)
            self.feedbackView.imgProfile.kf.setImage(with: resource, placeholder: UIImage(named: "historyProfilePlaceholder"), options: nil, progressBlock: nil, completionHandler: nil)
        }
        
        
// Using S3
//        if let profilePic = LocalDB.shared.currentTripDetail?.customerDetails.profilePicture {
//            self.retriveImgFromBucket(key: profilePic) { image in
//                self.feedbackView.imgProfile.image = image
//            }
//
//        }
        
        
        if let firstName = LocalDB.shared.currentTripDetail?.customerDetails.firstName {
            let str = firstName
            self.feedbackView.lblDriverName.text = str.localizedCapitalized
        }
        
      
    }
   

    func currentLocation() {

         guard let currentLoc = AppLocationManager.shared.locationManager.location else {
             return
         }
         
         let camera = GMSCameraPosition.camera(withLatitude: currentLoc.coordinate.latitude, longitude: currentLoc.coordinate.longitude, zoom: 18)
         self.feedbackView.mapview.camera = camera
        
        let marker = GMSMarker()
        marker.position = currentLoc.coordinate
        marker.icon = UIImage(named: "ic_pick_pin")
        marker.map = self.feedbackView.mapview
         
         return
     }
    
    @objc func submitbuttonPressed(_ sender: UIButton) {
        
        if feedbackView.rating.value < 1 {
            self.showAlert("",message: "txt_rate_driver".localize())
        } else {
            self.rateDriver()
        }

    }
    
    func rateDriver() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show(message: "txt_loading".localize())
            var paramDict = Dictionary<String, Any>()
            paramDict["request_id"] = LocalDB.shared.currentTripDetail?.acceptedRequestId
            paramDict["rating"] =  String(format: "%.2f", feedbackView.rating.value)
            if self.feedbackView.commentView.text != "" && self.feedbackView.commentView.text != txtViewPlaceHolder {
                paramDict["feedback"] = self.feedbackView.commentView.text
            }
           
            print(paramDict)
            let url = APIHelper.shared.BASEURL + APIHelper.rateUser
            print(url)
            Alamofire.request(url, method: .post, parameters: paramDict, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print(response.result.value as AnyObject)
                    if let result = response.result.value as? [String:AnyObject] {
                        if response.response?.statusCode == 200 {
                            
                            self.navigationController?.view.showToast("txt_rated_successfully".localize())
                            self.navigationController?.navigationBar.isHidden = true
                            LocalDB.shared.currentTripDetail = nil
                            self.navigationController?.popToRootViewController(animated: true)
                            
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

extension FeedBackRatingVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == txtViewPlaceHolder {
            textView.text = ""
            textView.textColor = UIColor.txtColor
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text =  txtViewPlaceHolder
            textView.textColor = .gray
        }
    }
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let newText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let numberOfChars = newText.count
        return numberOfChars < 100
    }
}
