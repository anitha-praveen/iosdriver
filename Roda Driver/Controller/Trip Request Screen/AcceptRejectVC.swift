//
//  AcceptRejectVC.swift
//  Taxiappz Driver
//
//  Created by Apple on 18/08/20.
//  Copyright © 2020 nPlus. All rights reserved.
//

import UIKit
import AVKit
import Alamofire
import MTSlideToOpen
import NVActivityIndicatorView
import CoreLocation
import GoogleMaps
class AcceptRejectVC: UIViewController {
    
    let acceptRejectView = AcceptRejectView()
    
    var tripSoundPlayer:AVAudioPlayer?
    var requestTimer:Timer?
    var count:Double = 60
    var timeLeft: Double?
    
    var requestDetails = [String: AnyObject]()
    var callBack:((Bool) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        MySocketManager.shared.socketDelegate = self
        setupViews()
        setupTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(tripCancelledByUser(_:)), name: Notification.Name("TripCancelledNotification"), object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("TripCancelledNotification"), object: nil)
        self.stopSound()
        self.requestTimer?.invalidate()
        self.requestTimer = nil
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        acceptBtnSetup()
    }
    
    func setupViews() {
        acceptRejectView.rejectBtn.delegate = self
        //acceptRejectView.acceptBtn.delegate = self
        acceptRejectView.setupViews(Base: self)
        setupData()
    }
    
    func setupTarget() {
        acceptRejectView.acceptButton.addTarget(self, action: #selector(acceptBtnAction(_ :)), for: .touchUpInside)
    }
    
    func acceptBtnSetup() {
        acceptRejectView.acceptButton.layer.masksToBounds = true
        acceptRejectView.acceptButton.clipsToBounds = true
        acceptRejectView.acceptButton.layer.cornerRadius = acceptRejectView.acceptButton.frame.size.height/2
        acceptRejectView.acceptButton.layoutIfNeeded()
    }
    
    @objc func acceptBtnAction(_ sender: UIButton) {
        print("Tapped")
        self.APIToAcceptTheUserRequest()
    }
    
    func setupData() {
        
        LocalDB.shared.currentTripDetail = TripDetail(tripDetails: requestDetails)
        
        if let pickUpLocation = self.requestDetails["pick_address"] as? String {
            self.acceptRejectView.lblPickup.text = pickUpLocation
        }
        if let dropLocation = self.requestDetails["drop_address"] as? String {
            self.acceptRejectView.lblDrop.text = dropLocation
        }
        
        if let stops = self.requestDetails["stops"] as? [String: AnyObject], !stops.isEmpty {
            
            if let address = stops["address"] as? String {
                self.acceptRejectView.lblStop.text = address
                self.acceptRejectView.stopView.isHidden = false
            }
        } else {
            self.acceptRejectView.stopView.isHidden = true
        }
        
        if let laterRide = requestDetails["is_later"] as? Bool, laterRide {
            if let time = requestDetails["trip_start_time"] as? String {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                if let date = dateFormatter.date(from: time) {
                    dateFormatter.dateFormat = "EEE,MMM dd, hh:mm a"
                    print(date)
                }
            }
        }
        self.acceptRejectView.lblName.text =  LocalDB.shared.currentTripDetail?.customerDetails.firstName
        
        if let rating = LocalDB.shared.currentTripDetail?.userRating {
            self.acceptRejectView.lblRating.set(text: String(format: "%.2f", rating), with: UIImage(named: "star"))
        }
        
        if self.requestTimer == nil {
            if let timeLeftStr = self.requestDetails["driver_time_out"] , let timeLeft = Double("\(timeLeftStr)") {
                self.timeLeft = timeLeft
                self.count = timeLeft
            }
            self.playSound()
            self.requestTimer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        }
        
        if let serviceType = requestDetails["service_category"] as? String, let packageHour = requestDetails["package_hour"], let packageKm = requestDetails["package_km"] {
            if serviceType == "RENTAL" {
                self.acceptRejectView.serviceTypeLabel.isHidden = false
                self.acceptRejectView.dropView.isHidden = true
                self.acceptRejectView.viewDropColor.isHidden = true
                self.acceptRejectView.serviceTypeLabel.text = serviceType + " " + "(" + "\(packageHour)" + " " + "txt_hour".localize() + "," + " " + "\(packageKm)" + "kms".localize() + ")"
            } else {
                self.acceptRejectView.serviceTypeLabel.text = serviceType
            }
        }
        if let serviceType = requestDetails["service_category"] as? String, let tripStartTime = requestDetails["trip_start_time"], let tripendTime = requestDetails["trip_end_time"] {
            if serviceType == "OUTSTATION" {
                self.acceptRejectView.tripStartTimeLabel.isHidden = false
                self.acceptRejectView.tripEndTimeLabel.isHidden = false
                self.acceptRejectView.tripStartTimeLabel.text = "" + "\(tripStartTime)"
                self.acceptRejectView.tripEndTimeLabel.text = "" + "\(tripendTime)"
            }
        }
        
        
    }
    
}

//MARK: - SOUND PLAYER
extension AcceptRejectVC {
    func playSound() {
        if let path = Bundle.main.path(forResource: "CreateRequest", ofType: "aiff") {
       // if let path = Bundle.main.path(forResource: "beep", ofType: "mp3") {
            
            let url = URL(fileURLWithPath:path)
            if let player = try? AVAudioPlayer(contentsOf: url) {
                self.tripSoundPlayer = player
                self.tripSoundPlayer?.numberOfLoops = -1
                self.tripSoundPlayer?.prepareToPlay()
                self.tripSoundPlayer?.play()
            }
        }
    }
    func stopSound() {
        self.tripSoundPlayer?.stop()
        self.tripSoundPlayer = nil
    }
    
    @objc func update(_ sender:Timer) {
        guard let timeLeft = self.timeLeft else {
            return
        }
        if count > 1 {
          // self.playSound()
            self.acceptRejectView.lblCount.text = String(format: "%.0f", count)
            let from = 1-(1/timeLeft)*count
            let to = 1-(1/timeLeft)*(count-1)
            acceptRejectView.circleAnimationView.animateCircle(from: from, to: to)
            count -= 1
        } else {
            self.acceptRejectView.lblCount.text = ""
            self.stopSound()
            self.requestTimer?.invalidate()
            self.requestTimer = nil
            
            self.APIToRejectTheUserRequest()
        }
    }
    
}

//MARK:- API'S
extension AcceptRejectVC {
    
    @objc func APIToAcceptTheUserRequest() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show()
            
            var paramdict = Dictionary<String, Any>()
            let currentLocation = AppLocationManager.shared.locationManager.location
            
            paramdict["driver_latitude"] = currentLocation?.coordinate.latitude
            paramdict["driver_longitude"] = currentLocation?.coordinate.longitude
            paramdict["is_accept"] = "1"
            paramdict["request_id"] = LocalDB.shared.currentTripDetail?.acceptedRequestId
            
            let url = APIHelper.shared.BASEURL + APIHelper.acceptRejectAPI
         
            print("URL & Parameters for Accepting Request API =",url,paramdict)
            
            Alamofire.request(url, method:.post, parameters: paramdict, encoding: JSONEncoding.default, headers:APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print("ACCEPT TRIPP",response.result.value as Any)
                    if let result = response.result.value as? [String: AnyObject] {
                        if response.response?.statusCode == 200 {
                            UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                            self.showToast("text_request_accepted".localize())
                            self.stopSound()
                            self.requestTimer?.invalidate()
                            self.requestTimer = nil
                            self.callBack?(true)
                            self.navigationController?.popViewController(animated: true)
                        } else {
                            self.stopSound()
                            self.requestTimer?.invalidate()
                            self.requestTimer = nil
                            LocalDB.shared.currentTripDetail = nil
                            if let error = result["data"] as? [String:[String]] {
                                let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                                self.dismissFromScreen(errMsg)
                            } else if let errMsg = result["error_message"] as? String {
                                self.dismissFromScreen(errMsg)
                            } else if let msg = result["message"] as? String {
                                self.dismissFromScreen(msg)
                            }
                        }
                        
                    }
                }
        } else {
            self.showAlert("txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
        }
    }
    
    @objc func APIToRejectTheUserRequest() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show()
            
            var paramdict = Dictionary<String, Any>()
            let currentLocation = AppLocationManager.shared.locationManager.location
            
            paramdict["driver_latitude"] = currentLocation?.coordinate.latitude
            paramdict["driver_longitude"] = currentLocation?.coordinate.longitude
            paramdict["is_accept"] = "0"
            paramdict["request_id"] = LocalDB.shared.currentTripDetail?.acceptedRequestId
            
            let url = APIHelper.shared.BASEURL + APIHelper.acceptRejectAPI
        
            print("URL & Parameters for Rejecting Request API =",url,paramdict)
            
            Alamofire.request(url, method:.post, parameters: paramdict, encoding: JSONEncoding.default, headers:APIHelper.shared.authHeader)
                .responseJSON { response in
                    NKActivityLoader.sharedInstance.hide()
                    print("REJECT TRIPP",response.result.value as Any)
                    switch response.result {
                    case .success(_):
                        if let result = response.result.value as? [String: AnyObject] {
                            if response.response?.statusCode == 200 {
                                UNUserNotificationCenter.current().removeAllDeliveredNotifications()
                                self.showToast("text_request_rejected".localize())
                                self.stopSound()
                                self.requestTimer?.invalidate()
                                self.requestTimer = nil
                                LocalDB.shared.currentTripDetail = nil
                                self.callBack?(false)
                                self.navigationController?.popViewController(animated: true)

                            } else {
                                self.stopSound()
                                self.requestTimer?.invalidate()
                                self.requestTimer = nil
                                LocalDB.shared.currentTripDetail = nil
                                if let error = result["data"] as? [String:[String]] {
                                    let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                                    self.dismissFromScreen(errMsg)
                                } else if let errMsg = result["error_message"] as? String {
                                    self.dismissFromScreen(errMsg)
                                } else if let msg = result["message"] as? String {
                                    self.dismissFromScreen(msg)
                                }
                            }
                        }
                    case .failure(let error):
                        self.dismissFromScreen(error.localizedDescription)
                    }
                }
        } else {
            self.showAlert("txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
        }
    }
    
    func dismissFromScreen(_ msg: String) {
        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
        let btnOk = UIAlertAction(title: "text_ok".localize(), style: .default) { (action) in
            self.stopSound()
            self.requestTimer?.invalidate()
            self.requestTimer = nil
            LocalDB.shared.currentTripDetail = nil
            self.callBack?(false)
            self.navigationController?.popViewController(animated: true)
            
        }
        alert.addAction(btnOk)
        self.present(alert, animated: true, completion: nil)
    }
}

//MARK:- Notification Observer
extension AcceptRejectVC {
    @objc func tripCancelledByUser(_ notification: Notification) {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UserDefaults.standard.set(60, forKey: "requestTimercount")
        self.stopSound()
        self.requestTimer?.invalidate()
        self.requestTimer = nil
        self.callBack?(false)
        self.navigationController?.popViewController(animated: true)
        
//        self.dismiss(animated: true, completion: {
//            self.callBack?(false)
//        })
    }
}

//MARK:- SOCKET DELEGATE
extension AcceptRejectVC: MySocketManagerDelegate {
    func driverRequestResponseReceived(_ response: [String : AnyObject]) {
        guard let status = response["success"] as? Bool else {
            return
        }
        if status {
            
            if let result = response["result"] as? [String: AnyObject] {
                if let metaData = result["data"] as? [String: AnyObject] {
                    if let isCancelled = metaData["is_cancelled"] as? Bool, isCancelled {
                        self.stopSound()
                        self.requestTimer?.invalidate()
                        self.requestTimer = nil
                        LocalDB.shared.currentTripDetail = nil
                        self.dismissFromScreen("User cancelled trip")
                    }
                }
            }
        }
    }
}

//MARK:- Slider Delegate
extension AcceptRejectVC: MTSlideToOpenDelegate {
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        if sender == acceptRejectView.rejectBtn {
            self.APIToRejectTheUserRequest()
        } else {
            self.APIToAcceptTheUserRequest()
        }
        sender.resetStateWithAnimation(true)
    }
    
}

