//
//  TripVC.swift
//  Taxiappz Driver
//
//  Created by Apple on 24/08/20.
//  Copyright © 2020 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import NVActivityIndicatorView
import Kingfisher
import MessageUI
import MTSlideToOpen
import SWRevealViewController
import FirebaseDatabase
import CoreLocation
import GoogleMaps
class TripVC: UIViewController {

    let tripView = TripTrackingView()
    
    let driverMarker = GMSMarker()
    var driversCurrentLatitude = Double()
    var driversCurrentLongitude = Double()
    var pickMarker = GMSMarker()
    var dropMarker = GMSMarker()
    var stopMarker = GMSMarker()
    var animatedPolyline:AnimatedPolyLine?
    
    var receivedDistance = ""
    
    var tripstartKm = String()
    var tripEndKm = String()

    var selectedImage: UIImage?
    
    var changedLocationId: String?
    var changedLocationAddress: String?
    var locationChangedTime: String?
    var changedLocationCoord: CLLocationCoordinate2D?
    
    
#if DEBUG
   // var requestRef = Database.database(url: "https://development-db-a8581.firebaseio.com/").reference().child("requests")
    var requestRef = Database.database().reference().child("requests")
#else
    
    var requestRef = Database.database().reference().child("requests")
#endif
    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        
        if LocalDB.shared.currentTripDetail?.isInstantTrip ?? false {
            var startTime = 21
            var endTime = 06
            if let time1 = LocalDB.shared.currentTripDetail?.nytStartTime, let time2 = LocalDB.shared.currentTripDetail?.nytEndTime {
                startTime = Int(time1) ?? 21
                endTime = Int(time2) ?? 06
            }
            self.checkTime(startTime: startTime, endTime: endTime) { crucialTime in
                if crucialTime {
                    if !(LocalDB.shared.currentTripDetail?.nytTimeDriverPhotoUploaded ?? false) {
                        let vc = InstantRidePhotoUploadVC()
                        vc.modalPresentationStyle = .overFullScreen
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                }
            }
        }
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
        AppLocationManager.shared.delegate.add(delegate: self)
        MySocketManager.shared.socketDelegate = self
        MySocketManager.shared.currentEmitType = .singleTripLocation
        NotificationCenter.default.addObserver(self, selector: #selector(methodOfReceivedNotification(notification:)), name: Notification.Name("TripCancelledNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(tripLocationChanged(_:)), name: .tripLocationChanged, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkRequestinprogress), name: .localToRental, object: nil)
        
    
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            tripView.btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)),for: .touchUpInside)
        } else {
            tripView.btnMenu.addTarget(self.revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)),for: .touchUpInside)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        NotificationCenter.default.removeObserver(self, name: Notification.Name("TripCancelledNotification"), object: nil)
        NotificationCenter.default.removeObserver(self, name: .tripLocationChanged, object: nil)
        NotificationCenter.default.removeObserver(self, name: .localToRental, object: nil)
    }
    
    func setupViews() {
        
        self.tripView.setupViews(Base: self.view, controller: self)
        self.tripView.btnCancelTrip.delegate = self
        self.setupMap()
        self.setCurrentAppState()
        self.setupDriverData()
        self.setupTarget()
        
        WaitingTimeHandler.shared.timerValueChanged = { [weak self] waitingSecs in
            if WaitingTimeHandler.shared.waitingTime > 0 {
            
                self?.tripView.waitingTimeView.isHidden = false
                self?.tripView.waitingTimeLbl.text = "txt_waiting_time".localize()  + " "  + WaitingTimeHandler.shared.waitingTimeLabelFormat

            } else {
                self?.tripView.waitingTimeView.isHidden = true
            }
        }
        
        RentalTripTimeHandler.shared.rentalTimerValueChanged = { [weak self] time in
            if RentalTripTimeHandler.shared.rentalTripTime > 0 {
            
                self?.tripView.waitingTimeView.isHidden = false
                self?.tripView.waitingTimeLbl.text = "txt_trip_time_text".localize()  + " "  + RentalTripTimeHandler.shared.rentalTripTimeLabelFormat
               
            } else {
                self?.tripView.waitingTimeView.isHidden = true
               
            }
        }
    }
    
    func setupTarget() {
        tripView.btnArrived.addTarget(self, action: #selector(btnArrivedPressed(_ :)), for: .touchUpInside)
        tripView.btnStartTrip.addTarget(self, action: #selector(btnStartTripPressed(_ :)), for: .touchUpInside)
        tripView.btnEndTrip.addTarget(self, action: #selector(btnEndTripPressed(_ :)), for: .touchUpInside)
       
        tripView.btnSos.addTarget(self, action: #selector(sosBtnAction(_:)), for: .touchUpInside)
       
        tripView.btnNav.addTarget(self, action: #selector(openGoogleMap(_:)), for: .touchUpInside)
        tripView.smsBtn.addTarget(self, action: #selector(smsBtnAction(_:)), for: .touchUpInside)
        tripView.callBtn.addTarget(self, action: #selector(CallBtn(_:)), for: .touchUpInside)
        
        if LocalDB.shared.currentTripDetail?.isInstantTrip == false {
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(detectPan(recognizer:)))
        panGesture.delaysTouchesBegan = false
        panGesture.delaysTouchesEnded = false
        tripView.containerView.addGestureRecognizer(panGesture)
        } else {
            tripView.driverView.isHidden = true
            
        }
        
        
        let notesTap = UITapGestureRecognizer(target: self, action: #selector(notesTapped(_:)))
        tripView.notesLabel.addGestureRecognizer(notesTap)
        
        let notesViewTap = UITapGestureRecognizer(target: self, action: #selector(notesViewTapped(_:)))
        tripView.notesView.addGestureRecognizer(notesViewTap)
        
        tripView.submitBtn.addTarget(self, action: #selector(btnSubmitPressed(_ :)), for: .touchUpInside)
        tripView.backButton.addTarget(self, action: #selector(backbtnAction(_ :)), for: .touchUpInside)
        tripView.tripEndImgBtn.addTarget(self, action: #selector(uploadImage(_ :)), for: .touchUpInside)
    }
    
    func setupMap() {
        tripView.mapview.mapType = .normal
        driverMarker.icon = UIImage(named: "pin_driver")
        driverMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        
        if let currentLocation = AppLocationManager.shared.locationManager.location {
            let bearing = AppLocationManager.shared.currentHeading?.trueHeading ?? currentLocation.course
            tripView.mapview.camera = GMSCameraPosition.camera(withTarget: currentLocation.coordinate, zoom: 15)
            driverMarker.rotation = bearing
        }
        
    }
   
    func setCurrentAppState() {
        if LocalDB.shared.currentTripDetail != nil {
            if LocalDB.shared.currentTripDetail?.requestIsTripStarted == true {
                
                if let dropLocation = LocalDB.shared.currentTripDetail?.dropLocation {
            
                    self.tripView.lblAddress.text = dropLocation
                    self.tripView.viewAddress.backgroundColor = .green
                } else {
                    self.tripView.viewAddress.isHidden = true
                }

                self.tripView.btnArrived.isHidden = true
                self.tripView.btnStartTrip.isHidden = true
                self.tripView.btnEndTrip.isHidden = false
                self.tripView.btnCancelTrip.isEnabled = false
                self.tripView.viewCancelTrip.isHidden = true
                
                if LocalDB.shared.currentTripDetail?.choosenServiceCatagory != "RENTAL" {
                    WaitingTimeHandler.shared.clearArrivedTime()
                    WaitingTimeHandler.shared.startTimer()
                    
                    if WaitingTimeHandler.shared.waitingTime > 0 {
                        self.tripView.waitingTimeView.isHidden = false
                        self.tripView.waitingTimeLbl.text = "txt_waiting_time".localize() + " "  + WaitingTimeHandler.shared.waitingTimeLabelFormat
                    } else {
                        self.tripView.waitingTimeView.isHidden = true
                    }
                } else if LocalDB.shared.currentTripDetail?.choosenServiceCatagory == "RENTAL" {
                    if let tripStartTime = RentalTripTimeHandler.shared.rentalTripStartTime {
                        let minutes = Calendar.current
                            .dateComponents([.minute], from: tripStartTime, to: Date()).minute ?? 0
                        print("trip start min diff",minutes as Any)
                        
                        RentalTripTimeHandler.shared.rentalTripTime = minutes * 60
                        RentalTripTimeHandler.shared.startRentalTimer()
                        if RentalTripTimeHandler.shared.rentalTripTime > 0 {
                            self.tripView.waitingTimeView.isHidden = false
                            self.tripView.waitingTimeLbl.text = "txt_trip_time_text".localize() + " "  + RentalTripTimeHandler.shared.rentalTripTimeLabelFormat
                        } else {
                            self.tripView.waitingTimeView.isHidden = true
                        }
                    }
                }
                
            }
            else if LocalDB.shared.currentTripDetail?.requestIsDriverArrived == true {
                
                if let dropLocation = LocalDB.shared.currentTripDetail?.dropLocation {
                    
                    self.tripView.lblAddress.text = dropLocation
                    self.tripView.viewAddress.backgroundColor = .green
                }
                
                
                self.tripView.btnArrived.isHidden = true
                self.tripView.btnStartTrip.isHidden = false
                self.tripView.btnEndTrip.isHidden = true
                self.tripView.btnCancelTrip.isEnabled = true
                
                if LocalDB.shared.currentTripDetail?.choosenServiceCatagory != "RENTAL" {
                    if let killTime = WaitingTimeHandler.shared.arrivedTime {
                        let minutes = Calendar.current
                            .dateComponents([.minute], from: killTime, to: Date()).minute ?? 0
                        print("arrived min diff",minutes as Any)
                        
                        let val = minutes * 60
                        if ((LocalDB.shared.currentTripDetail?.waitingGraceTime ?? 0)*60) > (Double(val)) {
                            
                            let sec = ((LocalDB.shared.currentTripDetail?.waitingGraceTime ?? 0)*60) - (Double(val))
                            WaitingTimeHandler.shared.startGraceTimer(after: sec)
                        } else {
                            WaitingTimeHandler.shared.startTimer()
                        }
                    } else {
                        WaitingTimeHandler.shared.startGraceTimer(after: (LocalDB.shared.currentTripDetail?.waitingGraceTime ?? 0)*60)
                    }
                    
                    if WaitingTimeHandler.shared.waitingTime > 0 {
                        
                        self.tripView.waitingTimeView.isHidden = false
                        self.tripView.waitingTimeLbl.text = "txt_waiting_time".localize() + " "  + WaitingTimeHandler.shared.waitingTimeLabelFormat
                    } else {
                        self.tripView.waitingTimeView.isHidden = true
                    }
                }
            }
            else if LocalDB.shared.currentTripDetail?.isDriverStarted == true {
                
                if let pickUpLocation = LocalDB.shared.currentTripDetail?.pickLocation {
                    
                    self.tripView.lblAddress.text = pickUpLocation
                    self.tripView.viewAddress.backgroundColor = .themeColor
                }
               

                self.tripView.btnArrived.isHidden = false
                self.tripView.btnStartTrip.isHidden = true
                self.tripView.btnEndTrip.isHidden = true
                self.tripView.btnCancelTrip.isEnabled = true
            }
            addMarkers()
            
            if LocalDB.shared.currentTripDetail?.needLocationApprove ?? false {
               
                self.moveToConfirmLocationScreen(with: self.changedLocationCoord ?? CLLocationCoordinate2D())
              
            }
        }
    }
    
    func setupDriverData() {
        
        if let imgStr = LocalDB.shared.currentTripDetail?.customerDetails.profilePicture, let url = URL(string: imgStr) {
            self.tripView.imgProfile.kf.indicatorType = .activity
            let resource = ImageResource(downloadURL: url)
            self.tripView.imgProfile.kf.setImage(with: resource, placeholder: UIImage(named: "profilePlaceHolder"), options: nil, progressBlock: nil, completionHandler: nil)
        } else {
            self.tripView.imgProfile.image = UIImage(named: "profilePlaceHolder")
        }
        
// Using S3
//        if let profilePic = LocalDB.shared.currentTripDetail?.customerDetails.profilePicture {
//            self.tripView.activityIndicator.startAnimating()
//            self.retriveImg(key: profilePic) { data in
//                self.tripView.imgProfile.image = UIImage(data: data)
//                self.tripView.activityIndicator.stopAnimating()
//            }
//        }
        
        
        
        if let notes = LocalDB.shared.currentTripDetail?.driverNotes {
            self.tripView.notesStackView.isHidden = false
            self.tripView.notesView.isHidden = false
            print("NOTES:",notes)
            self.tripView.notesLabel.text = notes
            self.tripView.detailedNotes.text = notes
        }
        
        if let reqId = LocalDB.shared.currentTripDetail?.requestNumber {
            self.tripView.requestIdLabel.text = reqId
        }
        
        if LocalDB.shared.currentTripDetail?.isInstantTrip == true {
            if let firstName = LocalDB.shared.currentTripDetail?.customerDetails.firstName,
                let lastName = LocalDB.shared.currentTripDetail?.customerDetails.lastName {
                self.tripView.lblDriverName.text = firstName + " " + lastName
            } else {
                if let instantTripPhoneNumber = LocalDB.shared.currentTripDetail?.instantPhoneNumber {
                    self.tripView.lblDriverName.text = instantTripPhoneNumber
                }
            }
        } else {
            if let firstName = LocalDB.shared.currentTripDetail?.customerDetails.firstName,
                let lastName = LocalDB.shared.currentTripDetail?.customerDetails.lastName {
                self.tripView.lblDriverName.text = firstName + " " + lastName
            }
        }
        
        if LocalDB.shared.currentTripDetail?.isInstantTrip == true {
            self.tripView.ratingLbl.isHidden = true
        } else {
            self.tripView.ratingLbl.isHidden = false
            if let rating = LocalDB.shared.currentTripDetail?.userRating {
                self.tripView.ratingLbl.set(text: String(format: "%.2f", rating), with: UIImage(named: "star"))
            }
        }
        if let rating = LocalDB.shared.currentTripDetail?.userRating {
            self.tripView.ratingLbl.set(text: String(format: "%.2f", rating), with: UIImage(named: "star"))
        }
        
        if let paymentMethod = LocalDB.shared.currentTripDetail?.paymentOpt {
            self.tripView.paymentBtn.setTitle(paymentMethod, for: .normal)
        }
        
    }
    
    
    func addMarkers(path needPath:Bool? = false) {
        guard let currentLat =  AppLocationManager.shared.locationManager.location?.coordinate.latitude,let currentLong =  AppLocationManager.shared.locationManager.location?.coordinate.longitude else {
            return
        }
        self.tripView.mapview.clear()
        self.pickMarker.map = nil
        self.dropMarker.map = nil
        self.stopMarker.map = nil
        
        driverMarker.position = CLLocationCoordinate2DMake(currentLat, currentLong)
        driverMarker.map = tripView.mapview
    
        if let pLat = LocalDB.shared.currentTripDetail?.pickLatitude, let pLong = LocalDB.shared.currentTripDetail?.pickLongitude,let dLat = LocalDB.shared.currentTripDetail?.dropLatitude, let dLong = LocalDB.shared.currentTripDetail?.dropLongitude  {
            print("DLATLONG",dLat,dLong)
            
            pickMarker.position = CLLocationCoordinate2DMake(pLat, pLong)
            pickMarker.icon = UIImage(named: "ic_pick_pin")
            pickMarker.map = tripView.mapview

            
            dropMarker.position = CLLocationCoordinate2D(latitude: dLat, longitude: dLong)
            dropMarker.icon = UIImage(named: "ic_destination_pin")
            dropMarker.map = tripView.mapview
            
                if let stoplat = LocalDB.shared.currentTripDetail?.reqestStopLat,let stopLong = LocalDB.shared.currentTripDetail?.reqestStopLong {
                    stopMarker.position = CLLocationCoordinate2DMake(stoplat,stopLong)
                    stopMarker.map = tripView.mapview
                }
                
            if LocalDB.shared.currentTripDetail?.requestIsDriverArrived == false {
                if let getPath = needPath {
                    if LocalDB.arrivalPath == "" || getPath {
                        self.getPolylineRoute(from: CLLocationCoordinate2DMake(currentLat, currentLong), to: CLLocationCoordinate2DMake(pLat, pLong))
                    } else {
                        self.setPolyPath(path: LocalDB.arrivalPath)
                    }
                }
                
            } else {
                if let pathToDestination = LocalDB.shared.currentTripDetail?.pathToDestination {
                    self.setPolyPath(path: pathToDestination)
                } else {
                    self.getPolylineRoute(from: CLLocationCoordinate2DMake(pLat, pLong), to: CLLocationCoordinate2DMake(dLat, dLong))
                }
                
            }
        }
    }
}

//MARK:- TARGET ACTIONS
extension TripVC {
    
    @objc func detectPan(recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        let isDraggingDown = translation.y > 0
        
        switch recognizer.state {
        
        case .changed:

            print(translation.y)
        case .ended:
            
            if isDraggingDown {
                UIView.animate(withDuration: 0.5) {
                    self.tripView.driverView.isHidden = true
                   
                    self.view.layoutIfNeeded()
                }
            } else {
                UIView.animate(withDuration: 0.5) {
                    self.tripView.driverView.isHidden = false
                   
                    self.view.layoutIfNeeded()
                }
            }
        default:
            break
        }
    }
    
    @objc func notesTapped(_ sender: UIGestureRecognizer) {
        tripView.notesView.isHidden = false
        tripView.bgView.isHidden = false
        tripView.detailedNotes.text = tripView.notesLabel.text 

    }
    
    @objc func notesViewTapped(_ sender: UIGestureRecognizer) {
        tripView.notesView.isHidden = true
        tripView.bgView.isHidden = true
    }
    
   
    
    @objc func sosBtnAction(_ sender: UIButton) {
        self.navigationController?.pushViewController(SOSVC(), animated: false)
    }
    @objc func recenterBtnAction(_ sender: UIButton) {
        if let currentLocation = AppLocationManager.shared.locationManager.location {
            let bearing = AppLocationManager.shared.currentHeading?.trueHeading ?? currentLocation.course
            tripView.mapview.camera = GMSCameraPosition.camera(withTarget: currentLocation.coordinate, zoom: 15)
            
            driverMarker.rotation = bearing
        }
    }
    
    @objc func smsBtnAction(_ sender: UIButton) {
        if MFMessageComposeViewController.canSendText() {
            UINavigationBar.appearance().titleTextAttributes = [
                NSAttributedString.Key.font: UIFont.appBoldTitleFont(ofSize: 18),NSAttributedString.Key.foregroundColor:UIColor.themeColor]
            UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedString.Key.font: UIFont.appBoldTitleFont(ofSize: 15),NSAttributedString.Key.foregroundColor:UIColor.themeColor], for: UIControl.State())
            let controller = MFMessageComposeViewController()
            if let phNo = LocalDB.shared.currentTripDetail?.customerDetails.phoneNumber {
                controller.recipients = [phNo]
            }
            controller.messageComposeDelegate = self
            self.present(controller, animated: true, completion: nil)
        }
    }
    
    @objc func CallBtn(_ sender: UIButton) {
        
        
        if LocalDB.shared.currentTripDetail?.isInstantTrip == true {
            if let phNo = LocalDB.shared.currentTripDetail?.customerDetails.phoneNumber {
                if let url = URL(string: "tel://\(phNo)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else {
                if let instantTripPhoneNumber = LocalDB.shared.currentTripDetail?.instantPhoneNumber {
                    if let url = URL(string: "tel://\(instantTripPhoneNumber)") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        } else {
            
            if let phNo = LocalDB.shared.currentTripDetail?.otherPersonPhoneNumber {
                if let url = URL(string: "tel://\(phNo)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            } else if let phNo = LocalDB.shared.currentTripDetail?.customerDetails.phoneNumber {
                if let url = URL(string: "tel://\(phNo)") {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    @objc func btnSubmitPressed(_ sender: UIButton) {
        print("TRIP START KM",tripstartKm)
        if let txt = self.tripView.tripEndTxtfield.text {
            self.tripEndKm = txt
        }
        if selectedImage == nil {
            showAlert("", message: "txt_upload_tripmeter_image".localize())
        }
        else if tripView.tripEndTxtfield.text == "" {
            showAlert("", message: "txt_enter_tripmeter_kilometres".localize())
        } else if (Double(tripstartKm) ?? 0) >= (Double(tripEndKm) ?? 0) {
            self.showAlert("", message: "trip_km_validation".localize())
        } else {
            if LocalDB.shared.currentTripDetail?.requestIsTripStarted == true {
                self.endOutStationRide("", status: "")
            }
        }
        
    }
    
    @objc func backbtnAction(_ sender: UIButton) {
        tripView.tripDistanceView.isHidden = true
    }
    
    @objc func uploadImage(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.allowsEditing = true
        vc.delegate = self
        present(vc, animated: true)
    }
    
    @objc func btnArrivedPressed(_ sender: UIButton) {
        if LocalDB.shared.currentTripDetail?.ifDipatch ?? false {
            self.arriveDriver()
        } else {
            self.arriveDriver()
        }
    }
    
    @objc func btnStartTripPressed(_ sender: UIButton) {
        var startTime = 21
        var endTime = 06
        if let time1 = LocalDB.shared.currentTripDetail?.nytStartTime, let time2 = LocalDB.shared.currentTripDetail?.nytEndTime {
            startTime = Int(time1) ?? 21
            endTime = Int(time2) ?? 06
        }
        if LocalDB.shared.currentTripDetail?.isInstantTrip ?? false || LocalDB.shared.currentTripDetail?.ifDipatch ?? false {
            self.startTheTrip()
        } else {
            
            self.checkTime(startTime: startTime, endTime: endTime) { crucialTime in
                if crucialTime {
//                    if !(LocalDB.shared.currentTripDetail?.nytTimeDriverPhotoUploaded ?? false) || !(LocalDB.shared.currentTripDetail?.nytTimeUserPhotoUploaded ?? false) {
                        
                        if !(LocalDB.shared.currentTripDetail?.isNytTimePhotoSkipped ?? false) {
                            let vc = NytTimePictureUploadVC()
                            vc.modalPresentationStyle = .overFullScreen
                            vc.callBack = {[weak self] arrive in
                                if arrive {
                                    self?.startTheTrip()
                                }
                            }
                            vc.cancelCallBack = {[unowned self] cancel in
                                if cancel {
                                    let cancelList = cancelListVC()
                                    cancelList.delegate = self
                                    cancelList.requestId = LocalDB.shared.currentTripDetail?.acceptedRequestId ?? ""
                                    cancelList.view.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
                                    cancelList.modalPresentationStyle = .overCurrentContext
                                    present(cancelList, animated: false, completion: nil)
                                }
                            }
                            self.present(vc, animated: true, completion: nil)
                        } else {
                            self.startTheTrip()
                        }
                    
                } else {
                    self.startTheTrip()
                }
            }
        }
        
    }
    
    
    @objc func btnEndTripPressed(_ sender: UIButton) {
        let alert = UIAlertController(title: "", message: "txt_end_confirm".localize(), preferredStyle: .alert)
        let ok = UIAlertAction(title: "text_yes".localize(), style: .default) { (action) in
            let serviceCategory = LocalDB.shared.currentTripDetail?.choosenServiceCatagory
            if LocalDB.shared.currentTripDetail?.choosenServiceCatagory == "OUTSTATION" || serviceCategory == "RENTAL" {
                self.tripView.tripDistanceView.isHidden = false
            } else {
                self.endTheRide("", status: "")
            }
            
        }
        let cancel = UIAlertAction(title: "text_no".localize(), style: .default, handler: nil)
        alert.addAction(ok)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    
    
    @objc func openGoogleMap(_ sender:UIButton) {

        guard let url = URL(string:"comgooglemaps://") else {
            return
        }
        if UIApplication.shared.canOpenURL(url) {
            if LocalDB.shared.currentTripDetail?.requestIsDriverArrived == true {
                if LocalDB.shared.currentTripDetail?.reqestStopLat == nil {
                    if let myLocation = AppLocationManager.shared.locationManager.location?.coordinate, let dropLat = LocalDB.shared.currentTripDetail?.dropLatitude, let dropLong = LocalDB.shared.currentTripDetail?.dropLongitude {
                        if let url = URL(string:"comgooglemaps://?saddr=\(myLocation.latitude),\(myLocation.longitude)&daddr=\(dropLat),\(dropLong)&directionsmode=driving") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                } else {
                    if let myLocation = AppLocationManager.shared.locationManager.location?.coordinate, let dropLat = LocalDB.shared.currentTripDetail?.dropLatitude, let dropLong = LocalDB.shared.currentTripDetail?.dropLongitude, let waypointLat = LocalDB.shared.currentTripDetail?.reqestStopLat, let waypointlong = LocalDB.shared.currentTripDetail?.reqestStopLong {
                        if let url = URL(string:"comgooglemaps://?saddr=\(myLocation.latitude),\(myLocation.longitude)&daddr=\(waypointLat),\(waypointlong)+to:\(dropLat),\(dropLong)&directionsmode=driving") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                    
                }
                
            } else {
                if let myLocation = AppLocationManager.shared.locationManager.location?.coordinate, let pickLat = LocalDB.shared.currentTripDetail?.pickLatitude, let pickLong = LocalDB.shared.currentTripDetail?.pickLongitude {
                    if let url = URL(string:"comgooglemaps://?saddr=\(myLocation.latitude),\(myLocation.longitude)&daddr=\(pickLat),\(pickLong)&directionsmode=driving") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        } else {
            if LocalDB.shared.currentTripDetail?.requestIsDriverArrived == true {
                if LocalDB.shared.currentTripDetail?.reqestStopLat == nil {
                    if let myLocation = AppLocationManager.shared.locationManager.location?.coordinate, let dropLat = LocalDB.shared.currentTripDetail?.dropLatitude, let dropLong = LocalDB.shared.currentTripDetail?.dropLongitude {
                        if let url = URL(string:"https://www.google.co.in/maps/dir/?saddr=\(myLocation.latitude),\(myLocation.longitude)&daddr=\(dropLat),\(dropLong)&directionsmode=driving") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                } else {
                    if let myLocation = AppLocationManager.shared.locationManager.location?.coordinate, let dropLat = LocalDB.shared.currentTripDetail?.dropLatitude, let dropLong = LocalDB.shared.currentTripDetail?.dropLongitude, let waypointLat = LocalDB.shared.currentTripDetail?.reqestStopLat, let waypointlong = LocalDB.shared.currentTripDetail?.reqestStopLong {
                        if let url = URL(string:"comgooglemaps://?saddr=\(myLocation.latitude),\(myLocation.longitude)&daddr=\(waypointLat),\(waypointlong)+to:\(dropLat),\(dropLong)&directionsmode=driving") {
                            UIApplication.shared.open(url, options: [:], completionHandler: nil)
                        }
                    }
                }
            } else {
                if let myLocation = AppLocationManager.shared.locationManager.location?.coordinate, let pickLat = LocalDB.shared.currentTripDetail?.pickLatitude, let pickLong = LocalDB.shared.currentTripDetail?.pickLongitude {
                    if let url = URL(string:"https://www.google.co.in/maps/dir/?saddr=\(myLocation.latitude),\(myLocation.longitude)&daddr=\(pickLat),\(pickLong)&directionsmode=driving") {
                        UIApplication.shared.open(url, options: [:], completionHandler: nil)
                    }
                }
            }
        }
    }
    
    func moveToConfirmLocationScreen(with coord: CLLocationCoordinate2D) {
        let vc = ConfirmChangeLocationVC()
        vc.modalPresentationStyle = .overFullScreen
        vc.locationId = self.changedLocationId
        vc.locationAddress = self.changedLocationAddress
        vc.locationChangedTime = self.locationChangedTime
        vc.locationCoord = coord
        vc.callBack = {[weak self] accepted in
            if accepted {
                print("returned to trip vc")
                self?.addMarkers()
                
                self?.tripView.lblAddress.text = self?.changedLocationAddress
                self?.tripView.viewAddress.backgroundColor = .green
            }
        }
        dismissPresent(vc, animated: true, completion: nil)
    }
    
}

//MARK:- Image Picker
extension TripVC: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let img = info[.originalImage] as? UIImage {
            self.selectedImage = img
            tripView.tripEndImgBtn.setImage(selectedImage, for: .normal)
            tripView.tripEndImgBtn.layer.borderWidth = 0
        } else if let img = info[.editedImage] as? UIImage {
            self.selectedImage = img
            tripView.tripEndImgBtn.setImage(selectedImage, for: .normal)
            tripView.tripEndImgBtn.layer.borderWidth = 0
        }
        picker.dismiss(animated: true)
    }
    
}


//MARK:- API'S
extension TripVC {
    func arriveDriver() {
        if ConnectionCheck.isConnectedToNetwork() {
            guard let myLocation = AppLocationManager.shared.locationManager.location else {
                self.showAlert("text_Alert".localize(), message: "txt_location_not_found".localize())
                return
            }
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityPulseData,nil)
            
            let url = APIHelper.shared.BASEURL + APIHelper.driverArrival
            var paramdict = Dictionary<String, Any>()
            
            paramdict["request_id"] = LocalDB.shared.currentTripDetail?.acceptedRequestId
            paramdict["driver_latitude"] = myLocation.coordinate.latitude
            paramdict["driver_longitude"] = myLocation.coordinate.longitude
            
            print("URL & Parameters for Driver Arrived API  = ",url,paramdict)
            Alamofire.request(url, method:.post, parameters: paramdict, encoding: JSONEncoding.default, headers:APIHelper.shared.authHeader)
                .responseJSON { response in
                    NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                    print(response.result.value as Any)
                    if let result = response.result.value as? [String: AnyObject] {
                        if response.response?.statusCode == 200 {
                            if let data = result["data"] as? [String: AnyObject] {
                                if let tripData = data["data"] as? [String: AnyObject] {
                                    LocalDB.shared.currentTripDetail = TripDetail(tripDetails: tripData)
                                    
                                    if let dropLocation = LocalDB.shared.currentTripDetail?.dropLocation {
                                       
                                        self.tripView.lblAddress.text = dropLocation
                                        self.tripView.viewAddress.backgroundColor = .green
                                    }
                                   
                                    
                                    self.tripView.btnArrived.isHidden = true
                                    self.tripView.btnStartTrip.isHidden = false
                                    self.tripView.btnEndTrip.isHidden = true
                                    self.showToast("txt_arrived".localize())
                                    
                                    self.addMarkers()

                                    if LocalDB.shared.currentTripDetail?.choosenServiceCatagory != "RENTAL" {
                                        WaitingTimeHandler.shared.arrivedTime = Date()
                                        
                                        WaitingTimeHandler.shared.startGraceTimer(after: TimeInterval((LocalDB.shared.currentTripDetail?.waitingGraceTime ?? 1)*60))

                                        if WaitingTimeHandler.shared.waitingTime > 0 {
                                            
                                            self.tripView.waitingTimeView.isHidden = false
                                            self.tripView.waitingTimeLbl.text = "txt_waiting_time".localize() + " " + WaitingTimeHandler.shared.waitingTimeLabelFormat
                                        } else {
                                            
                                            self.tripView.waitingTimeView.isHidden = true
                                        }
                                    } else {
                                        self.tripView.btnNav.isHidden = true
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
                }
        } else {
           
            self.showAlert("txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
        }
    }
    
    func startTheTrip() {
        let vc = TripOTP()
        vc.view.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        
        vc.callBack = { [unowned self] tripData, location, startKm in
            LocalDB.shared.currentTripDetail = TripDetail(tripDetails: tripData)
            print("START KM RECIVED",startKm as Any)
            self.tripstartKm = startKm ?? ""
            if let dropLocation = LocalDB.shared.currentTripDetail?.dropLocation {
                
                self.tripView.lblAddress.text = dropLocation
                self.tripView.viewAddress.backgroundColor = .green
            }
            
            self.tripView.btnCancelTrip.isEnabled = false
            self.tripView.viewCancelTrip.isHidden = true
            self.tripView.btnArrived.isHidden = true
            self.tripView.btnStartTrip.isHidden = true
            self.tripView.btnEndTrip.isHidden = false
            self.showToast("txt_trip_started".localize())
            
            self.addMarkers()
            RentalTripTimeHandler.shared.clearRentalStartTime()
            RentalTripTimeHandler.shared.rentalTripStartTime = Date()
            if LocalDB.shared.currentTripDetail?.choosenServiceCatagory != "RENTAL" {
                WaitingTimeHandler.shared.clearArrivedTime()
                
                WaitingTimeHandler.shared.startTimer()
                if WaitingTimeHandler.shared.waitingTime > 0 {
                    self.tripView.waitingTimeView.isHidden = false
                    self.tripView.waitingTimeLbl.text = "txt_waiting_time".localize() + " "  + WaitingTimeHandler.shared.waitingTimeLabelFormat
                } else {
                    self.tripView.waitingTimeView.isHidden = true
                }
            } else if LocalDB.shared.currentTripDetail?.choosenServiceCatagory == "RENTAL" {
                
                RentalTripTimeHandler.shared.startRentalTimer()
                if RentalTripTimeHandler.shared.rentalTripTime > 0 {
                    self.tripView.waitingTimeView.isHidden = false
                    self.tripView.waitingTimeLbl.text = "txt_trip_time_text".localize() + " "  + RentalTripTimeHandler.shared.rentalTripTimeLabelFormat
                } else {
                    self.tripView.waitingTimeView.isHidden = true
                }
            }
            
        }
        vc.modalPresentationStyle = .overCurrentContext
        present(vc, animated: false, completion: nil)
    }
  
    func endTheRide(_ cancelAmount: String,status: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            guard let myLocation = AppLocationManager.shared.locationManager.location else {
                self.showAlert("text_Alert".localize(), message: "txt_location_not_found".localize())
                return
            }
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityPulseData,nil)
            let coord = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
            self.getaddress(coord, completion: { address in
                
                let url = APIHelper.shared.BASEURL + APIHelper.endTheRide
                var paramdict = Dictionary<String, Any>()
                
                
                paramdict["request_id"] = LocalDB.shared.currentTripDetail?.acceptedRequestId
                
                paramdict["drop_lat"] = myLocation.coordinate.latitude
                paramdict["drop_lng"] = myLocation.coordinate.longitude
                paramdict["drop_address"] = address
                
                
                paramdict["distance"] = self.receivedDistance.isEmpty ? "0" : self.receivedDistance
                paramdict["waiting_time"] = WaitingTimeHandler.shared.waitingTimeServerFormat
                
                if status == "success" {
                    paramdict["cancellation_fee_amount"] = cancelAmount
                }
            
                print("URL & Parameters for End Trip API  = ",url,paramdict)
                Alamofire.request(url, method:.post, parameters: paramdict, encoding: JSONEncoding.default, headers:APIHelper.shared.authHeader)
                    .responseJSON { response in
                        NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                        
                        switch response.result {
                        case .failure(_):
                            self.checkRequestinprogress()
                        case .success(_):
                            print(response.result.value as Any)
                            if let result = response.result.value as? [String: AnyObject] {
                                if response.response?.statusCode == 200 {
                                    if let data = result["data"] as? [String: AnyObject] {
                                        if let tripData = data["data"] as? [String: AnyObject] {
                                            self.showToast("txt_trip_completed".localize())
                                            
                                            self.requestRef.child(LocalDB.shared.currentTripDetail?.acceptedRequestId ?? "").updateChildValues(["driver_trip_status": 3])
                                            
                                            LocalDB.shared.currentTripDetail = TripDetail(tripDetails: tripData)
                                            WaitingTimeHandler.shared.stopTimer()
                                            RentalTripTimeHandler.shared.stopRentalTimer()
                                            RentalTripTimeHandler.shared.clearRentalStartTime()
                                            self.arrivedMapVCToTripInvoiceVC()
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
            })
        } else {
            
            self.showAlert("txt_NoInternet_title".localize(), message: "txt_NoInternet".localize())
        }
    }
    
    
    func endOutStationRide(_ cancelAmount: String,status: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            guard let myLocation = AppLocationManager.shared.locationManager.location else {
                self.showAlert("text_Alert".localize(), message: "txt_location_not_found".localize())
                return
            }
            NVActivityIndicatorPresenter.sharedInstance.startAnimating(APIHelper.shared.activityPulseData,nil)
            let coord = CLLocationCoordinate2D(latitude: myLocation.coordinate.latitude, longitude: myLocation.coordinate.longitude)
            self.getaddress(coord, completion: { address in
                
                let url = APIHelper.shared.BASEURL + APIHelper.endTheRide
                var paramdict = Dictionary<String, Any>()
                
                guard let urlRequest = try? URLRequest(url: APIHelper.shared.BASEURL + APIHelper.endTheRide, method: .post, headers: APIHelper.shared.authHeader) else {
                    return
                }
                
                var newImage: UIImage? = nil
                newImage = self.selectedImage
                while let image = newImage, let imgData = image.pngData(), imgData.count > 1999999 {
                    newImage = newImage?.resized(withPercentage: 0.5)
                }
                
                paramdict["request_id"] = (LocalDB.shared.currentTripDetail?.acceptedRequestId)
                paramdict["drop_lat"] = "\(myLocation.coordinate.latitude)"
                paramdict["drop_lng"] = "\(myLocation.coordinate.longitude)"
                paramdict["drop_address"] = "\(address)"
                
                paramdict["distance"] = self.receivedDistance.isEmpty ? "0" : self.receivedDistance
                paramdict["waiting_time"] = "\(WaitingTimeHandler.shared.waitingTimeServerFormat)"
                if self.tripEndKm > self.tripstartKm {
                    paramdict["end_km"] = self.tripEndKm
                }
                
                let enddate = Date()
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                let dateStr = dateFormatter.string(from: enddate)
                paramdict["trip_end_time"] = dateStr
                
                
                
                if status == "success" {
                    paramdict["cancellation_fee_amount"] = cancelAmount
                }
            
                print("URL & Parameters for End Trip API  = ",url,paramdict)
                
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
                                
                                print(response.result.value as Any)
                                if let result = response.result.value as? [String: AnyObject] {
                                    if response.response?.statusCode == 200 {
                                        if let data = result["data"] as? [String: AnyObject] {
                                            if let tripData = data["data"] as? [String: AnyObject] {
                                                self.showToast("txt_trip_completed".localize())
                                                
                                                self.requestRef.child(LocalDB.shared.currentTripDetail?.acceptedRequestId ?? "").updateChildValues(["driver_trip_status": 3])
                                                
                                                LocalDB.shared.currentTripDetail = TripDetail(tripDetails: tripData)
                                                WaitingTimeHandler.shared.stopTimer()
                                                self.arrivedMapVCToTripInvoiceVC()
                                                
                                                self.tripstartKm = ""
                                                self.tripEndKm = ""
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
                            case .failure(_):
                                self.checkRequestinprogress()
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
    
    func removeHandlers() {
        LocalDB.arrivalPath = ""
        WaitingTimeHandler.shared.stopTimer()
        RentalTripTimeHandler.shared.stopRentalTimer()
        RentalTripTimeHandler.shared.clearRentalStartTime()
        MySocketManager.shared.currentEmitType = .none
        AppLocationManager.shared.locationArray.removeAll()
        AppLocationManager.shared.delegate.remove(delegate: self)
        
    }

    func arrivedMapVCToTripInvoiceVC() {
        self.removeHandlers()
        let tripInvoiceVC = InvoiceVC()
        tripInvoiceVC.navigationItem.hidesBackButton = true
        self.navigationController?.pushViewController(tripInvoiceVC, animated: true)
    }
    
    @objc func checkRequestinprogress() {
        if ConnectionCheck.isConnectedToNetwork() {
            let url = APIHelper.shared.BASEURL + APIHelper.getRequestInProgress
            print("URL & Parameters for Checking current Request API =",url)
            
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.authHeader)
                .responseJSON { response in
                    print("request in progress",response.result.value as AnyObject)
                    if let result = response.result.value as? [String: AnyObject] {
                        if response.response?.statusCode == 200 {
                            if let data = result["data"] as? [String: AnyObject] {
                                if let tripDict = data["trips"] as? [String: AnyObject] {
                                    if let tripData = tripDict["data"] as? [String:AnyObject] {
                                        if let isCompleted = tripData["is_completed"] as? Bool, isCompleted {
                                            self.showToast("txt_trip_completed".localize())
                                            LocalDB.shared.currentTripDetail = TripDetail(tripDetails: tripData)
                                            WaitingTimeHandler.shared.stopTimer()
                                            RentalTripTimeHandler.shared.stopRentalTimer()
                                            RentalTripTimeHandler.shared.clearRentalStartTime()
                                            self.arrivedMapVCToTripInvoiceVC()
                                        } else if let isDriverStarted = tripData["is_driver_started"] as? Bool, isDriverStarted {
                                            
                                            LocalDB.shared.currentTripDetail = TripDetail(tripDetails: tripData)
                                            if let serviceCategory = LocalDB.shared.currentTripDetail?.choosenServiceCatagory, serviceCategory == "RENTAL" {
                                                WaitingTimeHandler.shared.stopTimer()
                                                self.setCurrentAppState()
                                            }
                                        }
                                        
                                    }
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
    
}

//MARK:- Slider and Cancel Delegate
extension TripVC: MTSlideToOpenDelegate,CancelDetailsViewDelegate {
    
    func mtSlideToOpenDelegateDidFinish(_ sender: MTSlideToOpenView) {
        if let requestId = LocalDB.shared.currentTripDetail?.acceptedRequestId {
            let cancelList = cancelListVC()
            cancelList.delegate = self
            cancelList.requestId = requestId
            cancelList.view.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
            cancelList.modalPresentationStyle = .overCurrentContext
            present(cancelList, animated: false, completion: nil)
        }
        sender.resetStateWithAnimation(true)
    }
    
    func tripCancelled(_ msg: String) {
        
        LocalDB.shared.currentTripDetail = nil
        self.removeHandlers()
        self.navigationController?.view.showToast(msg)
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension TripVC:AppLocationManagerDelegate {
    
    func appLocationManager(didUpdateHeading newHeading: CLHeading) {

        CATransaction.begin()
        CATransaction.setValue(1.0, forKey: kCATransactionAnimationDuration)
        
        self.tripView.mapview.animate(toBearing: newHeading.trueHeading)
       // driverMarker.rotation = newHeading.trueHeading
        CATransaction.commit()
    }
    
    func appLocationManager(didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else {
            return
        }
        
        if driversCurrentLatitude == userLocation.coordinate.latitude && driversCurrentLongitude == userLocation.coordinate.longitude {
            return
        }
        tripView.mapview.animate(toLocation: userLocation.coordinate)
        driverMarker.position = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
        driverMarker.map = tripView.mapview
        driversCurrentLatitude = userLocation.coordinate.latitude
        driversCurrentLongitude = userLocation.coordinate.longitude
    }
}

//MARK: - GOOGLE MAPS DELEGATE
extension TripVC {
    
    func getPolylineRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D){
        print("Am hitted")
        let queryItems = [URLQueryItem(name: "origin", value: "\(source.latitude),\(source.longitude)"),URLQueryItem(name: "destination", value: "\(destination.latitude),\(destination.longitude)"),URLQueryItem(name: "sensor", value: "false"),URLQueryItem(name: "mode", value: "driving"),URLQueryItem(name: "key", value: APIHelper.shared.gmsDirectionKey)]
        let url = APIHelper.googleApiComponents.googleURLComponents("/maps/api/directions/json", queryItem: queryItems)

        Alamofire.request(url).responseJSON { response in
            if case .failure(_) = response.result {
                self.setupMap()
            } else if case .success = response.result {
                if let JSON = response.result.value as? [String:AnyObject], let status = JSON["status"] as? String {
                    if status == "OK" {
                        if let routes = JSON["routes"] as? [[String:AnyObject]], let route = routes.first, let polyline = route["overview_polyline"] as? [String:AnyObject], let points = polyline["points"] as? String {
                            if LocalDB.shared.currentTripDetail?.requestIsDriverArrived == false {
                                LocalDB.arrivalPath = points
                            } else {
                                LocalDB.shared.currentTripDetail?.pathToDestination = points
                            }
                            DispatchQueue.main.async {
                                self.setPolyPath(path: points)
                            }
                        }
                    } else {
                        self.setupMap()
                    }
                }
            }
        }
    }
    
    func setPolyPath(path: String) {

        let path = GMSPath(fromEncodedPath: path)
        let polyline = GMSPolyline(path: path)
        polyline.strokeWidth = 4.0
        let redYellow = GMSStrokeStyle.gradient(from: .hexToColor("FED200"), to: .hexToColor("FE0000"))
        polyline.spans = [GMSStyleSpan(style: redYellow)]
        polyline.map = self.tripView.mapview
        
        let bounds = GMSCoordinateBounds(path: path!)
        self.tripView.mapview.animate(with: GMSCameraUpdate.fit(bounds, with: UIEdgeInsets(top: 100, left: 20, bottom: 100, right: 20)))
    }
}

//MARK:- SOCKET DELEGATE
extension TripVC: MySocketManagerDelegate {
    
    func driverRequestResponseReceived(_ response: [String : AnyObject]) {
        
        if let result = response["result"] as? [String: AnyObject] {
            if let metaData = result["data"] as? [String: AnyObject] {
                if let isCancelled = metaData["is_cancelled"] as? Bool, isCancelled {
                    self.showToast("Txt_TripCanceled".localize())
                    LocalDB.shared.currentTripDetail = nil
                    self.removeHandlers()
                    
                    let alertVC = AlertVC()
                    alertVC.view.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
                    alertVC.fileName = "cancelled"
                    alertVC.lbl.text = "Txt_TripCanceled".localize()
                    alertVC.callBack = {
                        self.navigationController?.popViewController(animated: true)
                    }
                    alertVC.modalPresentationStyle = .overCurrentContext
                    dismissPresent(alertVC, animated: false, completion: nil)
                }
            }
        }
    }
    
    func updateTripDistance(_ distance: String) {
        self.tripView.distanceLbl.text = distance + " " + "kms".localize()
        // "txt_distance".localize()
        self.receivedDistance = distance
    }
    
    func rideLocationChanged(_ response: [String : AnyObject]) {
        print("ride location changed",response)
        if let result = response["result"] as? [String: AnyObject] {
            
            if let lat = result["latitude"], let lng = result["longitude"], let address = result["address"] as? String {
                
                if let type = result["type"] {
                    let locType = "\(type)"
                    if locType == "1" {
                        LocalDB.shared.currentTripDetail?.pickLatitude = Double("\(lat)")
                        LocalDB.shared.currentTripDetail?.pickLongitude = Double("\(lng)")
                        LocalDB.shared.currentTripDetail?.pickLocation = address
                        
                        addMarkers()
                        
                        let alertVC = AlertVC()
                        alertVC.view.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
                        alertVC.fileName = "pickupchanged"
                        alertVC.lbl.text = "text_pickup_changed".localize()
                        alertVC.modalPresentationStyle = .overCurrentContext
                        dismissPresent(alertVC, animated: false, completion: nil)
                    } else {
  
                        if let locationId = result["location_id"] {
                            self.changedLocationAddress = address
                            self.changedLocationId = "\(locationId)"
                            
                            self.moveToConfirmLocationScreen(with: CLLocationCoordinate2D(latitude: Double("\(lat)")!, longitude: Double("\(lng)")!))
                        }
                    }
                }
            }
        }
    }
    
    func serviceTypeChanged(_ response: [String : AnyObject]) {
        
        print("service type changed",response)
        checkRequestinprogress()
    }
    
    func passengerPhotoUploaded(_ response: [String : AnyObject]) {
        if let result = response["result"] as? [String: AnyObject] {
            if let retakePhoto = result["retake_image"] as? Bool, retakePhoto {
                LocalDB.shared.currentTripDetail?.nytTimeDriverPhotoUploaded = false
            } else {
                if let uploadStatus = result["upload_status"] as? Bool {
                    LocalDB.shared.currentTripDetail?.nytTimeUserPhotoUploaded = uploadStatus
                }
            }
        }
    }
}

//MARK:- PUSH NOTIFICATION OBSERVER
extension TripVC {

    @objc func tripLocationChanged(_ notification: Notification) {
        if let object = notification.userInfo as? [String: AnyObject] {
            self.rideLocationChanged(object)
        }
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        guard let pushcancelleddatadict = notification.userInfo as? [String:AnyObject] else {
            return
        }
        print("Cancelled by User notification", pushcancelleddatadict)
        let JSON = pushcancelleddatadict
        
        if let isCancelled = JSON["is_cancelled"] as? Bool, isCancelled {
            self.showToast("Txt_TripCanceled".localize())
            LocalDB.shared.currentTripDetail = nil
            
            self.removeHandlers()
            
            let alertVC = AlertVC()
            alertVC.view.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
            alertVC.fileName = "cancelled"
            alertVC.lbl.text = "Txt_TripCanceled".localize()
            alertVC.callBack = {
                self.navigationController?.popViewController(animated: true)
            }
            alertVC.modalPresentationStyle = .overCurrentContext
            dismissPresent(alertVC, animated: false, completion: nil)
            
        }
    }

}

extension TripVC:  MFMessageComposeViewControllerDelegate {
    func messageComposeViewController(_ controller: MFMessageComposeViewController, didFinishWith result: MessageComposeResult) {
        self.dismiss(animated: true, completion: nil)
    }
}

