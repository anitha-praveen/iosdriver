//
//  OnlineOfflineVC.swift
//  Taxiappz Driver
//
//  Created by spextrum on 22/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import Kingfisher
import FirebaseAuth
import FirebaseDatabase
import UserNotifications
import GooglePlaces
import SWRevealViewController
import NVActivityIndicatorView
import GoogleMaps
import CoreLocation

class OnlineOfflineVC: UIViewController {
    
    var onlineOfflineView = OnlineOfflineView()
    
    var adminPhNo = ""
    let sideMenuHideBtn = UIButton(type: .custom)
    
    var isDriverActive: Bool = false
    
    private var previousLocUpdateTime = Date()
    private var currentLocUpdatedTime = Date()
    
    private var ref: DatabaseReference!

    var currentLayoutDirection = APIHelper.appLanguageDirection //TO REDRAW VIEWS IF DIRECTION IS CHANGED
    var currentAppLanguage = APIHelper.currentAppLanguage
    var typeId = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        
        #if DEBUG
            //ref = Database.database(url: "https://development-db-a8581.firebaseio.com/").reference().child("drivers")
            ref = Database.database().reference().child("drivers")
        #else
            ref = Database.database().reference().child("drivers")
        #endif
       
        
        setupViews()
        setupTarget()
        if self.revealViewController() != nil {
            self.view.addGestureRecognizer(self.revealViewController().panGestureRecognizer())
        }
        self.navigationController?.navigationBar.isHidden = true
        MySocketManager.shared.stopEmitTimer()
        MySocketManager.shared.startTimer()
    }
    
    func setupViews() {
        onlineOfflineView.setupViews(Base: self.view, controller: self)
        
        self.onlineOfflineView.declinedView.setUpViews(self)
        self.view.bringSubviewToFront(self.onlineOfflineView.declinedView)

        var layoutDict = [String: AnyObject]()
        sideMenuHideBtn.isHidden = true
        sideMenuHideBtn.backgroundColor = UIColor.secondaryColor.withAlphaComponent(0.7)
        sideMenuHideBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["sideMenuHideBtn"] = sideMenuHideBtn
        self.navigationController?.view.addSubview(sideMenuHideBtn)
        self.navigationController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[sideMenuHideBtn]|", options: [], metrics: nil, views: layoutDict))
        self.navigationController?.view.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[sideMenuHideBtn]|", options: [], metrics: nil, views: layoutDict))
    }
    
    func setupTarget() {
        onlineOfflineView.instantJobBtn.addTarget(self, action: #selector(instantJobBtnAction(_:)), for: .touchUpInside)
        onlineOfflineView.offlineBtn.addTarget(self, action: #selector(apiForChangingDriverAvailablity(_ :)), for: .touchUpInside)
        onlineOfflineView.onlineBtn.addTarget(self, action: #selector(apiForChangingDriverAvailablity(_ :)), for: .touchUpInside)
        onlineOfflineView.offlineOnlineBtnView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(apiForChangingDriverAvailablity(_:))))
        
        onlineOfflineView.btnOnDuty.addTarget(self, action: #selector(apiForChangingDriverAvailablity(_ :)), for: .touchUpInside)
        onlineOfflineView.btnOffDuty.addTarget(self, action: #selector(apiForChangingDriverAvailablity(_ :)), for: .touchUpInside)
        
        sideMenuHideBtn.addTarget(self, action: #selector(sideMenuHideBtnPressed(_ :)), for: .touchUpInside)
        
        onlineOfflineView.btnGoTo.addTarget(self, action: #selector(btnGotoPressed(_ :)), for: .touchUpInside)
        onlineOfflineView.dragger.addTarget(self, action: #selector(draggerDragged(_ :)), for: .valueChanged)
       
       
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
       
        onlineOfflineView.declinedView.closeBtnBottomConstraint?.constant = -(self.view.safeAreaInsets.bottom)
       
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        MySocketManager.shared.currentEmitType = .setLocation
        AppLocationManager.shared.delegate.add(delegate: self)
        MySocketManager.shared.socketDelegate = self
        setupMap()
        self.changeAuthorization()
        self.checkRequestinprogress()
        self.addNotificationObservers()
        
        
        
        if currentLayoutDirection != APIHelper.appLanguageDirection {
           
            onlineOfflineView.setupViews(Base: self.view, controller: self)
            
            currentLayoutDirection = APIHelper.appLanguageDirection
            
            onlineOfflineView.profileBtn.removeTarget(nil, action: nil, for: .allEvents)
            if APIHelper.appLanguageDirection == .directionLeftToRight {
                onlineOfflineView.profileBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)),for: .touchUpInside)
            } else {
                onlineOfflineView.profileBtn.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)),for: .touchUpInside)
            }
        }
        
        if currentAppLanguage != APIHelper.currentAppLanguage {
            onlineOfflineView.earningsTitleLbl.text = "txt_earnings".localize()
            onlineOfflineView.todaysStatusTitleLbl.text = "txt_tdy_status".localize()
            onlineOfflineView.walletBalanceTitleLabel.text = "txt_wallet_bal".localize()
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = true
        AppLocationManager.shared.delegate.remove(delegate: self)
        self.removeNotificationObservers()
        
    }
    
    func addNotificationObservers() {
        NotificationCenter.default.addObserver(self, selector: #selector(checkRequestinprogress), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(OnlineOfflineVC.driverActivationStatusChanged(_:)), name: .driverApproved, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(OnlineOfflineVC.driverActivationStatusChanged(_:)), name: .driverDeclined, object: nil)
       
     
        NotificationCenter.default.addObserver(self, selector: #selector(newTripReceivedFromPush(_:)), name: .newRideRequest, object: nil)
    }
    
    func removeNotificationObservers() {
        NotificationCenter.default.removeObserver(self, name: .driverApproved, object: nil)
        NotificationCenter.default.removeObserver(self, name: .driverDeclined, object: nil)
        NotificationCenter.default.removeObserver(self, name: .newRideRequest, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func setupMap() {
        if let currentLocation = AppLocationManager.shared.locationManager.location {
            onlineOfflineView.driverMarker.position = currentLocation.coordinate
            onlineOfflineView.mapview.camera = GMSCameraPosition.camera(withTarget: currentLocation.coordinate, zoom: 18)
            if self.isDriverActive {
                onlineOfflineView.driverMarker.map = onlineOfflineView.mapview
            } else {
                onlineOfflineView.driverMarker.map = nil
            }
        }
    }
    
    func onlineData() {
        AppLocationManager.shared.stopTracking()
        AppLocationManager.shared.startTracking()
        
        self.onlineOfflineView.offlineOnlineBtnView.backgroundColor = .themeColor
        self.onlineOfflineView.onOfflbl.text = "text_online".localize()
        self.onlineOfflineView.offlineOnlinelbl.text = "txt_you_online".localize()
        self.onlineOfflineView.onOfflbl.textAlignment = .left
        self.onlineOfflineView.offlineBtn.isHidden = true
        self.onlineOfflineView.onlineBtn.isHidden = false
        self.onlineOfflineView.driverDetialsView.isHidden = false
        
        onlineOfflineView.driverMarker.map = onlineOfflineView.mapview
        
        onlineOfflineView.goToAddressView.isHidden = true
        
        /* Update driver status at firebase */
        guard let authId = LocalDB.shared.driverDetails?.id else {
            return
        }
        self.ref.child(authId).updateChildValues(["is_active": self.isDriverActive])
        
        MySocketManager.shared.currentEmitType = .setLocation
    }
    
    func offlineData() {
        AppLocationManager.shared.stopTracking()
        
        self.onlineOfflineView.offlineOnlineBtnView.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        self.onlineOfflineView.onOfflbl.text = "text_offline".localize()
        self.onlineOfflineView.offlineOnlinelbl.text = "txt_you_offline".localize()
        self.onlineOfflineView.onOfflbl.textAlignment = .right
        self.onlineOfflineView.offlineBtn.isHidden = false
        self.onlineOfflineView.onlineBtn.isHidden = true
        self.onlineOfflineView.driverDetialsView.isHidden = true
        
        onlineOfflineView.driverMarker.map = nil
        onlineOfflineView.goToAddressView.isHidden = true
        /* Update driver status at firebase */
        guard let authId = LocalDB.shared.driverDetails?.id else {
            return
        }
        self.ref.child(authId).updateChildValues(["is_active": self.isDriverActive])
        MySocketManager.shared.currentEmitType = .none
    }
    
}

//MARK:- TARGET ACTIONS
extension OnlineOfflineVC {
    
    @objc func draggerDragged(_ sender: UISlider) {
        if sender.value > self.onlineOfflineView.draggerValue {
            if sender.value > 1 && sender.value <= 3 {
                sender.setValue(3.0, animated: true)
                self.onlineOfflineView.dragger.setThumbImage(UIImage(named: "delete"), for: .normal)
                toggleDriverStatus()
            } else if sender.value > 3 {
                sender.setValue(5.0, animated: true)
                self.onlineOfflineView.dragger.setThumbImage(UIImage(named: "delete"), for: .normal)
                
                self.onlineOfflineView.goToAddressView.isHidden = false
            }
        } else {
            if sender.value < 5 && sender.value >= 3 {
                sender.setValue(3.0, animated: true)
                self.onlineOfflineView.dragger.setThumbImage(UIImage(named: "delete"), for: .normal)
                toggleDriverStatus()
            } else if sender.value < 3 {
                sender.setValue(1.0, animated: true)
                self.onlineOfflineView.dragger.setThumbImage(UIImage(named: "delete"), for: .normal)
                toggleDriverStatus()
            }
        }
        self.onlineOfflineView.draggerValue = sender.value
    }
    
    @objc func btnGotoPressed(_ sender: UIButton) {
        self.onlineOfflineView.goToAddressView.isHidden = false
    }
    
    @objc func newTripReceivedFromPush(_ notification: Notification) {
        if let response = notification.userInfo as? [String:AnyObject] {
            self.driverRequestResponseReceived(response)
        }
    }
    
    @objc func sideMenuHideBtnPressed(_ sender: UIButton) {
        sideMenuHideBtn.isHidden = true
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            self.revealViewController()?.revealToggle(animated: true)
        } else {
            self.revealViewController()?.rightRevealToggle(animated: true)
        }
    }
    
    @objc func callAdmin(_ sender: UIButton) {
        if let url = URL(string: "tel://\(self.adminPhNo)"), UIApplication.shared.canOpenURL(url) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
            } else {
                UIApplication.shared.openURL(url)
            }
        }
    }
    
    @objc func gotToSubscribe(_ sender: UIButton) {
        self.navigationController?.pushViewController(SubscriptionVC(), animated: true)
    }
    
    @objc func uploadDocuments(_ sender: UIButton) {
        let vc = ManageDocumentVC()
        vc.isFromHome = true
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    @objc func instantJobBtnAction(_ sender: UIButton) {
        if isDriverActive == true {
        let vc = InstantTripVC()
        vc.typeID = self.typeId
        self.navigationController?.pushViewController(vc, animated: true)
        } else {
            showAlert("", message: "txt_you_offline".localize())
        }
    }

    @objc func apiForChangingDriverAvailablity(_ sender: UIButton) {
        toggleDriverStatus()
        
    }
}


//MARK: API'S
extension OnlineOfflineVC {
    
    func toggleDriverStatus() {
        if ConnectionCheck.isConnectedToNetwork() {
            NKActivityLoader.sharedInstance.show()
            let url = APIHelper.shared.BASEURL + APIHelper.toggleDriverStatus
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: APIHelper.shared.authHeader).responseJSON { response in
                NKActivityLoader.sharedInstance.hide()
                print(response.result.value as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if response.response?.statusCode == 200 {
                        if let data = result["data"] as? [String: AnyObject] {
                            if let isActive = data["online_by"] as? Bool, isActive {
                                self.isDriverActive = true
                                self.onlineData()
                            } else {
                                self.isDriverActive = false
                                self.offlineData()
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
        } else {
            self.showAlert("txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
        }
    }
    
    @objc func checkRequestinprogress() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            let url = APIHelper.shared.BASEURL + APIHelper.getRequestInProgress
            
            print("AuthHeader = ",APIHelper.shared.authHeader)
            
            Alamofire.request(url, method:.get, parameters: nil, headers:APIHelper.shared.authHeader)
                .responseJSON { response in
                   
                    print("request in progress",response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        if response.response?.statusCode == 200 {
                            
//                            UpdateChecker.shared.isUpdateAvailable() { hasUpdates in
//                                print("is update available: \(hasUpdates)")
//                                if hasUpdates {
//                                    let vc = UpdateAppVC()
//                                    vc.modalPresentationStyle = .fullScreen
//                                    vc.view.backgroundColor = .themeColor
//                                    self.present(vc, animated: true, completion: nil)
//                                }
//                            }
                            
                            if let data = result["data"] as? [String: AnyObject] {
                                if let adminNum = data["customer_care_number"] as? String {
                                    self.adminPhNo = adminNum
                                }
                                if let driverDict = data["driver"] as? [String: AnyObject] {
                                    self.getDriverActiveStatus(driverDict)
                                    
                                    if let meta = driverDict["meta"] as? [String: AnyObject] {
                                        if let metaData = meta["data"] as? [String: AnyObject] {
                                            self.showTripRequest(metaData)
                                        }
                                    }
                                }
                                
                                if let tripDict = data["trips"] as? [String: AnyObject],let driverDict = data["driver"] as? [String: AnyObject] {
                                    if let tripData = tripDict["data"] as? [String:AnyObject] {
                                        self.navigateToTrip(tripData, locationData: driverDict)
                                    }
                                } else {
                                    WaitingTimeHandler.shared.stopTimer()
                                    MySocketManager.shared.stopSingleTripEmitTimer()
                                }
                            }
                            
                        } else if response.response?.statusCode == 401 {
                            LocalDB.shared.deleteUser()
                        }
                    }
                }
        } else {
            self.showAlert("txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
        }
    }
    
    func getDriverActiveStatus(_ driverDict: [String:AnyObject]) {
       
        if let typeId = driverDict["type_id"] {
            self.typeId = "\(typeId)"
        }
        if let isActive = driverDict["online"] as? Bool {
            if isActive {
                UIApplication.shared.isIdleTimerDisabled = true
                self.isDriverActive = true
                self.onlineData()
            } else {
                UIApplication.shared.isIdleTimerDisabled = false
                self.isDriverActive = false
                self.offlineData()
            }
        }
        
        if let completedTrips = driverDict["today_completed"] {
            onlineOfflineView.completedLbl.text = "txt_completed".localize() + ":" + " " + "\(completedTrips)"
        }
        
        if let cancelledTrips = driverDict["today_cancelled"] {
            onlineOfflineView.cancelledLbl.text = "txt_cancelled".localize() + ":" + " " + "\(cancelledTrips)"
        }
        
        guard let currency = driverDict["currency_symbol"] as? String else {
            return
        }
        
        if let walletAmount = driverDict["wallet_amount"] {
            if let amount = Double("\(walletAmount)") {
                if amount <= -450  {
                    onlineOfflineView.walletbalance.textColor = .red
                } else {
                    onlineOfflineView.walletbalance.textColor = .txtColor
                }
            }
            onlineOfflineView.walletbalance.text = currency + " " + "\(walletAmount)"
        }
        
        if let earnings = driverDict["today_earnings"] {
            let num = Double("\(earnings)")
            let amt = Double(round(1000 * (num ?? 0)) / 1000)
            onlineOfflineView.earningsLbl.text = currency + " " + "\(amt)"
        }
        
        if let isApprove = driverDict["approve_status"] as? Bool, !isApprove {
            if let documentUploadStatusInt = driverDict["document_upload_status"] as? Int,
               let documentUploadStatus = DocumentUploadStatus(rawValue: documentUploadStatusInt) {
                self.onlineOfflineView.declinedView.closeBtn.removeTarget(nil, action: nil, for: .allEvents)

                switch documentUploadStatus {
                case .other:
                    if let reason = driverDict["block_reson"] as? String {
                        if reason != "" {
                            self.onlineOfflineView.declinedView.infoLbl.text = reason + " \n" + "text_driver_declined_note".localize()
                        } else {
                            self.onlineOfflineView.declinedView.infoLbl.text = "text_driver_declined_note".localize()
                        }
                    } else {
                        self.onlineOfflineView.declinedView.infoLbl.text = "text_driver_declined_note".localize()
                    }
                    if let subscriptionType = driverDict["subscription_type"] as? Int {
                        if subscriptionType == 2 {
                            if let subscriptionStatus = driverDict["subscription_status"] as? Bool, !subscriptionStatus {
                                self.onlineOfflineView.declinedView.closeBtn.setTitle("txt_subscribe".localize(), for: .normal)
                                self.onlineOfflineView.declinedView.closeBtn.addTarget(self, action: #selector(self.gotToSubscribe(_:)), for: .touchUpInside)
                            } else {
                                self.onlineOfflineView.declinedView.closeBtn.setTitle("text_call_admin".localize(), for: .normal)
                                self.onlineOfflineView.declinedView.closeBtn.addTarget(self, action: #selector(self.callAdmin(_:)), for: .touchUpInside)
                            }
                        } else {
                            self.onlineOfflineView.declinedView.closeBtn.setTitle("text_call_admin".localize(), for: .normal)
                            self.onlineOfflineView.declinedView.closeBtn.addTarget(self, action: #selector(self.callAdmin(_:)), for: .touchUpInside)
                        }
                    }
                    
                    
                case .approved:
                    self.onlineOfflineView.declinedView.infoLbl.text = "text_driver_declined_note".localize()
                    self.onlineOfflineView.declinedView.closeBtn.setTitle("text_call_admin".localize(), for: .normal)
                    self.onlineOfflineView.declinedView.closeBtn.addTarget(self, action: #selector(self.callAdmin(_:)), for: .touchUpInside)
                case .uploadedWaitingForApproval:
                    self.onlineOfflineView.declinedView.infoLbl.text = "text_driver_uploadedWaitingForApproval".localize()
                    self.onlineOfflineView.declinedView.closeBtn.setTitle("text_call_admin".localize(), for: .normal)
                    self.onlineOfflineView.declinedView.closeBtn.addTarget(self, action: #selector(self.callAdmin(_:)), for: .touchUpInside)
                case .modifiedWaitingForApproval:
                    self.onlineOfflineView.declinedView.infoLbl.text = "text_driver_modifiedWaitingForApproval".localize()
                    self.onlineOfflineView.declinedView.closeBtn.setTitle("text_call_admin".localize(), for: .normal)
                    self.onlineOfflineView.declinedView.closeBtn.addTarget(self, action: #selector(self.callAdmin(_:)), for: .touchUpInside)
                case .expired:
                    self.onlineOfflineView.declinedView.infoLbl.text = "doc_expired".localize()
                    self.onlineOfflineView.declinedView.closeBtn.setTitle("text_upload_doc".localize(), for: .normal)
                    self.onlineOfflineView.declinedView.closeBtn.addTarget(self, action: #selector(self.uploadDocuments(_:)), for: .touchUpInside)
                case .notUploaded:
                   // self.onlineOfflineView.declinedView.lblHint.text = "text_manage_documents".localize()
                    self.onlineOfflineView.declinedView.infoLbl.text = "text_driver_notUploaded".localize()
                    self.onlineOfflineView.declinedView.closeBtn.setTitle("text_upload_doc".localize(), for: .normal)
                    self.onlineOfflineView.declinedView.closeBtn.addTarget(self, action: #selector(self.uploadDocuments(_:)), for: .touchUpInside)
                }
                print(documentUploadStatus)
            }

            self.onlineOfflineView.declinedView.isHidden = false
            self.isDriverActive = false
        } else {
            self.onlineOfflineView.declinedView.isHidden = true

        }
        
        if let subscriptionType = driverDict["subscription_type"] as? Int {
            if subscriptionType == 2 {
                LocalDB.shared.isSubscriptionEnabled = true
            } else {
                LocalDB.shared.isSubscriptionEnabled = false
            }
        }
        
        var driverData = Dictionary<String, Any>()
        driverData["id"] = LocalDB.shared.driverDetails?.id
        driverData["first_name"] = LocalDB.shared.driverDetails?.firstName
        driverData["last_name"] = LocalDB.shared.driverDetails?.lastName
        driverData["is_active"] = self.isDriverActive
        if let typeId = driverDict["type_id"] {
            driverData["type"] = "\(typeId)"
        }
        if let serviceCatagory = driverDict["service_category"] as? String {
          
            driverData["service_category"] = serviceCatagory
        }
        
        if let driverPhoneNumber = driverDict["phone_number"] as? String {
            driverData["phone_number"] = driverPhoneNumber
        }
        
        
        guard let authId = LocalDB.shared.driverDetails?.id else {
            return
        }
        self.ref.child(authId).updateChildValues(driverData)
    }
    
    func showTripRequest(_ data: [String: AnyObject]) {
        
        if let isCancelled = data["is_cancelled"] as? Bool, isCancelled {
            return
        }
        if let isDriverStarted = data["is_driver_started"] as? Bool, !isDriverStarted {
            
            let vc = AcceptRejectVC()
            vc.requestDetails = data
            if self.navigationController?.topViewController is OnlineOfflineVC {
                self.navigationController?.pushViewController(vc, animated: true)
            }
            
        }
        
    }
    
    func navigateToTrip(_ data: [String: AnyObject], locationData: [String: AnyObject]) {
        if let isCompleted = data["is_completed"] as? Bool, isCompleted {
            LocalDB.shared.currentTripDetail = TripDetail(tripDetails: data)
            let vc = InvoiceVC()
            self.navigationController?.pushViewController(vc, animated: true)
            
        } else if let isDriverStarted = data["is_driver_started"] as? Bool, isDriverStarted {
            LocalDB.shared.currentTripDetail = TripDetail(tripDetails: data)
            MySocketManager.shared.stopSingleTripEmitTimer()
            MySocketManager.shared.startSingleTripLocation()
            MySocketManager.shared.currentEmitType = .none
            let vc = TripVC()
            if let changedLocAddress = locationData["changed_location_adddress"] as? String {
                vc.changedLocationAddress = changedLocAddress
            }
            if let locationId = locationData["changed_location_id"] {
                vc.changedLocationId = "\(locationId)"
            }
            if let lat = locationData["changed_location_lat"], let lng = locationData["changed_location_long"] {
                vc.changedLocationCoord = CLLocationCoordinate2D(latitude: Double("\(lat)")!, longitude: Double("\(lng)")!)
            }
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
  
    
}

// MARK: Delegates (update location)
extension OnlineOfflineVC: AppLocationManagerDelegate {
    func appLocationManager(didUpdateLocations locations: [CLLocation]) {
        self.currentLocUpdatedTime = Date()
        guard let location = locations.last else {
            return
        }
        
      // MARK: Finding location update intervel for animation
        var diff = Calendar.current.dateComponents([.second], from: self.previousLocUpdateTime, to: self.currentLocUpdatedTime).second ?? 1
        if !self.onlineOfflineView.mapview.projection.contains(location.coordinate) {
            diff = 1
        }
        diff = min(diff, 2)
        CATransaction.begin()
        CATransaction.setValue(diff, forKey: kCATransactionAnimationDuration)
        self.onlineOfflineView.driverMarker.position = location.coordinate
        self.onlineOfflineView.mapview.animate(toLocation: location.coordinate)
        self.onlineOfflineView.mapview.animate(toBearing: location.course)
        CATransaction.commit()
        self.previousLocUpdateTime = Date()
        
    }
    
    func appLocationManager(didUpdateHeading newHeading: CLHeading) {
        
        guard let location = AppLocationManager.shared.locationManager.location else {
            return
        }
        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        if !self.onlineOfflineView.mapview.projection.contains(location.coordinate) {
            self.onlineOfflineView.mapview.animate(toLocation: location.coordinate)
        }
        self.onlineOfflineView.mapview.animate(toBearing: newHeading.trueHeading)
        CATransaction.commit()

    }
    
    static func radiansToDegress(radians: CGFloat) -> CGFloat {
        return radians * 180 / CGFloat(Double.pi)
    }
    
    func applocationManager(didChangeAuthorization status: CLAuthorizationStatus) {
        
        changeAuthorization()
    }
    
    func changeAuthorization() {
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            
            case .authorizedAlways, .authorizedWhenInUse:
                
                break
            case .restricted, .denied, .notDetermined:
                self.navigationController?.pushViewController(EnableLocationScreen(), animated: true)
                break
            @unknown default:
                break
            }
        } else {
            self.navigationController?.pushViewController(EnableLocationScreen(), animated: true)
        }
    }
}


//MARK: SOCKET DELEGATE
extension OnlineOfflineVC: MySocketManagerDelegate {
   
    func driverRequestResponseReceived(_ response: [String : AnyObject]) {
        print("Show Trip Request", response)
        if let result = response["result"] as? [String: AnyObject] {
            if let metaData = result["data"] as? [String: AnyObject] {
                self.showTripRequest(metaData)
            }
        }
    }
}

//MARK:- PUSH NOTIFICATION- OBSERVER
extension OnlineOfflineVC {
    
    @objc func driverActivationStatusChanged(_ notification:Notification) {
        checkRequestinprogress()
    }

}
