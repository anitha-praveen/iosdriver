//
//  TripView.swift
//  Taxiappz
//
//  Created by Apple on 03/07/20.
//  Copyright © 2020 Mohammed Arshad. All rights reserved.
//

import UIKit
import GoogleMaps
import MTSlideToOpen

class TripView: UIView {

    let mapview = GMSMapView()
    
    let btnMenu = UIButton()
    let requestIdLabel = UILabel()
    let btnSos = UIButton()
    let waitingTimeView = UIView()
    let waitingTimeLbl = UILabel()
    
    
    let stackAddress = UIStackView()
    
    let pickupView = UIView()
    let viewPickupColor = UIView()
    let lblPickup = UILabel()
    
    let separator = UIView()
    
    let stopView = UIView()
    let viewStopColor = UIView()
    let lblStop = UILabel()
    
    let dropView = UIView()
    let viewDropColor = UIView()
    let lblDrop = UILabel()
    
    let containerView = UIView()
    
    let stackvw = UIStackView()

    let handleBarView = UIView()
    let handleBarImgView = UIImageView()
    
    let driverView = UIView()
    let callBtn = UIButton()
    let smsBtn = UIButton()
    let ratingLbl = UILabel()
    
    let imgProfile = UIImageView()
    var activityIndicator = UIActivityIndicatorView()
    let lblDriverName = UILabel()
    
    let notesStackView = UIStackView()
    let notesLabel = UILabel()
    
    let linedView = UIImageView()
    
    let bgView = UIView()
    let notesView = UIView()
    let detailedNotes = UILabel()
    
    let distanceView = UIView()
    let distanceLbl = UILabel()
    let paymentBtn = UIButton()
    let btnNav = UIButton()
    let promoStatusLbl = UILabel()
    let paySeparator = UIView()
    
    let viewTripButton = UIStackView()
    let btnArrived = UIButton()
    let btnStartTrip = UIButton()
    let btnEndTrip = UIButton()
    
    let viewCancelTrip = UIView()
    let btnCancelTrip = MTSlideToOpenView()
        
    let btnMapStyle = UIButton()
    let btnRefresh = UIButton()
    
    var tripDistanceView = UIView()
    let backButton = UIButton()
    let tripMeterTitleLabel = UILabel()
    var tripEndImgBtn = UIButton()
    let tripEndTxtfield = UITextField()
    let submitBtn = UIButton()
        
    var mapStyleBottomConstraint: NSLayoutConstraint?
    var refreshBottomConstraint: NSLayoutConstraint?
    
    var layoutDict = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView, controller: UIViewController) {
        
        baseView.backgroundColor = .secondaryColor
        
        
        if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
            self.mapview.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
        }
//        mapview.isTrafficEnabled = true
//        mapview.settings.compassButton = false
//        mapview.isBuildingsEnabled = true
//        mapview.isIndoorEnabled = true
        layoutDict["mapview"] = mapview
        mapview.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(mapview)
        
        stackAddress.layer.cornerRadius = 10
        stackAddress.axis = .vertical
        stackAddress.distribution = .fill
        stackAddress.backgroundColor = .secondaryColor
        layoutDict["stackAddress"] = stackAddress
        stackAddress.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(stackAddress)
        
        pickupView.backgroundColor = .secondaryColor
        pickupView.layer.cornerRadius = 10
        pickupView.addShadow()
        layoutDict["pickupView"] = pickupView
        pickupView.translatesAutoresizingMaskIntoConstraints = false
        stackAddress.addArrangedSubview(pickupView)
        
        viewPickupColor.layer.cornerRadius = 5
        viewPickupColor.backgroundColor = .txtColor
        layoutDict["viewPickupColor"] = viewPickupColor
        viewPickupColor.translatesAutoresizingMaskIntoConstraints = false
        pickupView.addSubview(viewPickupColor)
        
        lblPickup.textColor = .txtColor
        lblPickup.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblPickup"] = lblPickup
        lblPickup.translatesAutoresizingMaskIntoConstraints = false
        pickupView.addSubview(lblPickup)
        
        separator.backgroundColor = .hexToColor("E4E9F2")
        layoutDict["separator"] = separator
        separator.translatesAutoresizingMaskIntoConstraints = false
        stackAddress.addSubview(separator)
        
        stopView.backgroundColor = .secondaryColor
        stopView.layer.cornerRadius = 10
        stopView.addShadow()
        layoutDict["stopView"] = stopView
        stopView.translatesAutoresizingMaskIntoConstraints = false
        stackAddress.addArrangedSubview(stopView)
        
        viewStopColor.backgroundColor = .red
        layoutDict["viewStopColor"] = viewStopColor
        viewStopColor.translatesAutoresizingMaskIntoConstraints = false
        stopView.addSubview(viewStopColor)
        
        lblStop.textColor = .txtColor
        lblStop.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblStop"] = lblStop
        lblStop.translatesAutoresizingMaskIntoConstraints = false
        stopView.addSubview(lblStop)
        
        dropView.backgroundColor = .secondaryColor
        dropView.layer.cornerRadius = 10
        dropView.addShadow()
        layoutDict["dropView"] = dropView
        dropView.translatesAutoresizingMaskIntoConstraints = false
        stackAddress.addArrangedSubview(dropView)
        
        viewDropColor.backgroundColor = .red
        layoutDict["viewDropColor"] = viewDropColor
        viewDropColor.translatesAutoresizingMaskIntoConstraints = false
        dropView.addSubview(viewDropColor)
        
        lblDrop.textColor = .txtColor
        lblDrop.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblDrop"] = lblDrop
        lblDrop.translatesAutoresizingMaskIntoConstraints = false
        dropView.addSubview(lblDrop)
        
        containerView.layer.cornerRadius = 20
        containerView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        containerView.backgroundColor = .secondaryColor
        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["containerView"] = containerView
        baseView.addSubview(containerView)
        
        stackvw.axis = .vertical
        stackvw.distribution = .fill
        stackvw.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["stackvw"] = stackvw
        containerView.addSubview(stackvw)
        
        
        handleBarView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["handleBarView"] = handleBarView
        stackvw.addArrangedSubview(handleBarView)
        
        handleBarImgView.image = UIImage(named: "handleBar")
        handleBarImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["handleBarImgView"] = handleBarImgView
        handleBarView.addSubview(handleBarImgView)
    
        driverView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["driverView"] = driverView
        stackvw.addArrangedSubview(driverView)

        [imgProfile,activityIndicator,lblDriverName, callBtn, smsBtn, ratingLbl, linedView,notesStackView].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            driverView.addSubview($0)
        }
        
        imgProfile.image = UIImage(named: "profile")
        imgProfile.backgroundColor = .hexToColor("ACB1C0")
        imgProfile.layer.cornerRadius = 50
        imgProfile.clipsToBounds = true
        layoutDict["imgProfile"] = imgProfile
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
        
        lblDriverName.textAlignment = .center
        lblDriverName.font = UIFont.appSemiBold(ofSize: 18)
        layoutDict["lblDriverName"] = lblDriverName
        
        notesStackView.isHidden = true
        notesStackView.axis = .vertical
        notesStackView.distribution = .fill
        layoutDict["notesStackView"] = notesStackView
        
        notesLabel.isHidden = true
        notesLabel.isUserInteractionEnabled = true
        notesLabel.textColor = .txtColor
        notesLabel.textAlignment = .left
        notesLabel.numberOfLines = 2
        notesLabel.lineBreakMode = .byWordWrapping
        notesLabel.font = UIFont.systemFont(ofSize: 13)
        notesLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["notesLabel"] = notesLabel
        notesStackView.addArrangedSubview(notesLabel)
        
        callBtn.setImage(UIImage(named: "callBtn"), for: .normal)
        callBtn.contentMode = .scaleAspectFit
        callBtn.backgroundColor = .clear
        layoutDict["callBtn"] = callBtn
        
        smsBtn.setImage(UIImage(named: "smsBtn"), for: .normal)
        smsBtn.contentMode = .scaleAspectFit
        smsBtn.backgroundColor = .clear
        layoutDict["smsBtn"] = smsBtn
        
        ratingLbl.font = UIFont.appSemiBold(ofSize: 12)
        layoutDict["ratingLbl"] = ratingLbl
        
        linedView.image = UIImage(named: "lineLeftRight")
        layoutDict["linedView"] = linedView
        
        //-----------Distance
        
        layoutDict["distanceView"] = distanceView
        distanceView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(distanceView)
        
        [btnNav, distanceLbl, paymentBtn, paySeparator, viewTripButton].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            distanceView.addSubview($0)
        }
        
        distanceLbl.textColor = .txtColor
        distanceLbl.textAlignment = .center
        distanceLbl.font = UIFont.appSemiBold(ofSize: 16)
        layoutDict["distanceLbl"] = distanceLbl
        
        paymentBtn.setTitle("txt_cash_payment".localize(), for: .normal)
        
        paymentBtn.contentHorizontalAlignment = .leading
        paymentBtn.setImage(UIImage(named: "ic_dollar"), for: .normal)
        paymentBtn.setTitleColor(UIColor(red: 0.133, green: 0.169, blue: 0.271, alpha: 1), for: .normal)
        paymentBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 15)
        paymentBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        paymentBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        paymentBtn.imageView?.contentMode = .scaleAspectFill
        paymentBtn.layer.cornerRadius = 5
        paymentBtn.backgroundColor = .secondaryColor
        layoutDict["paymentBtn"] = paymentBtn
        
        btnNav.setImage(UIImage(named: "ic_trip_nav"), for: .normal)
        layoutDict["btnNav"] = btnNav
        
        paySeparator.backgroundColor = .hexToColor("F1F2F6")
        layoutDict["paySeparator"] = paySeparator
        
        viewTripButton.axis = .vertical
        viewTripButton.distribution = .fill
        viewTripButton.spacing = 8
        layoutDict["viewTripButton"] = viewTripButton
        
        btnArrived.setTitle("text_arrived".localize().uppercased(), for: .normal)
        btnArrived.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnArrived.setTitleColor(.themeTxtColor, for: .normal)
        btnArrived.backgroundColor = .themeColor
        btnArrived.layer.cornerRadius = 5
        btnArrived.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnArrived"] = btnArrived
        viewTripButton.addArrangedSubview(btnArrived)
        
        btnStartTrip.isHidden = true
        btnStartTrip.setTitle("text_start_trip".localize().uppercased(), for: .normal)
        btnStartTrip.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnStartTrip.setTitleColor(.themeTxtColor, for: .normal)
        btnStartTrip.backgroundColor = .themeColor
        btnStartTrip.layer.cornerRadius = 5
        btnStartTrip.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnStartTrip"] = btnStartTrip
        viewTripButton.addArrangedSubview(btnStartTrip)
        
        btnEndTrip.isHidden = true
        btnEndTrip.setTitle("text_end_trip".localize().uppercased(), for: .normal)
        btnEndTrip.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        btnEndTrip.setTitleColor(.themeTxtColor, for: .normal)
        btnEndTrip.backgroundColor = .themeColor
        btnEndTrip.layer.cornerRadius = 5
        btnEndTrip.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnEndTrip"] = btnEndTrip
        viewTripButton.addArrangedSubview(btnEndTrip)
        
        viewCancelTrip.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewCancelTrip"] = viewCancelTrip
        viewTripButton.addArrangedSubview(viewCancelTrip)
        
        if APIHelper.appLanguageDirection == . directionRightToLeft {
            btnCancelTrip.appLanguageEnglish = false
        } else {
            btnCancelTrip.appLanguageEnglish = true
        }
        btnCancelTrip.textLabelLeadingDistance = 10
        btnCancelTrip.sliderViewTopDistance = 0
        btnCancelTrip.sliderCornerRadius = 25
        btnCancelTrip.sliderBackgroundColor = .hexToColor("ACB1C0")
        btnCancelTrip.slidingColor = .clear
        btnCancelTrip.thumbnailViewTopDistance = 3
        btnCancelTrip.thumbnailViewStartingDistance = 3
        btnCancelTrip.thumnailImageView.backgroundColor = .secondaryColor
        btnCancelTrip.thumnailImageView.image = UIImage(named: "ic_reject_cross")
        btnCancelTrip.labelText = "txt_slide_cancel".localize().uppercased()
        btnCancelTrip.textFont = UIFont.appSemiBold(ofSize: 18)
        btnCancelTrip.textColor = .secondaryColor
        btnCancelTrip.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnCancelTrip"] = btnCancelTrip
        viewCancelTrip.addSubview(btnCancelTrip)
        
        btnMenu.setImage(UIImage(named:"ic_menu"), for: .normal)
        btnMenu.layer.cornerRadius = 24
        btnMenu.layer.masksToBounds = true
//        btnMenu.layer.borderColor = UIColor.themeColor.cgColor
//        btnMenu.layer.borderWidth = 2
        btnMenu.backgroundColor = .clear
//        btnMenu.addShadow()
        layoutDict["btnMenu"] = btnMenu
        btnMenu.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnMenu)
        
        requestIdLabel.textColor = .themeColor
        requestIdLabel.textAlignment = .center
        requestIdLabel.font = UIFont.boldSystemFont(ofSize: 14)
        requestIdLabel.backgroundColor = .secondaryColor
        requestIdLabel.addShadow(shadowColor: UIColor.lightGray.cgColor, shadowOpacity: 0.2, shadowRadius: 2)
        requestIdLabel.layer.cornerRadius = 12
        requestIdLabel.clipsToBounds = true
        layoutDict["requestIdLabel"] = requestIdLabel
        requestIdLabel.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(requestIdLabel)
        
        btnSos.addShadow()
        btnSos.setTitle("txt_sos".localize(), for: .normal)
        btnSos.layer.cornerRadius = 24
        btnSos.titleLabel?.font = UIFont.appBoldFont(ofSize: 16)
        btnSos.setTitleColor(.secondaryColor, for: .normal)
        btnSos.backgroundColor = .red
        layoutDict["btnSos"] = btnSos
        btnSos.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnSos)
        
        waitingTimeView.addShadow(shadowColor: UIColor.lightGray.cgColor, shadowOpacity: 0.2, shadowRadius: 2)
        waitingTimeView.isHidden = true
        waitingTimeView.layer.cornerRadius = 5
        waitingTimeView.backgroundColor = .themeColor
        layoutDict["waitingTimeView"] = waitingTimeView
        waitingTimeView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(waitingTimeView)
        
        waitingTimeLbl.textAlignment = APIHelper.appTextAlignment
        waitingTimeLbl.textColor = .secondaryColor
        waitingTimeLbl.font = UIFont.appFont(ofSize: 14)
        layoutDict["waitingTimeLbl"] = waitingTimeLbl
        waitingTimeLbl.translatesAutoresizingMaskIntoConstraints = false
        waitingTimeView.addSubview(waitingTimeLbl)
        
        btnMapStyle.setImage(UIImage(named: "satellite"), for: .normal)
        btnMapStyle.contentMode = .scaleAspectFill
        btnMapStyle.backgroundColor = .secondaryColor
        btnMapStyle.imageView?.tintColor = .themeColor
        btnMapStyle.layer.cornerRadius = 23
        btnMapStyle.backgroundColor = .secondaryColor
        btnMapStyle.addShadow()
        btnMapStyle.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnMapStyle"] = btnMapStyle
        baseView.addSubview(btnMapStyle)
        
        btnRefresh.setImage(UIImage(named: "currentLocation"), for: .normal)
        btnRefresh.contentMode = .center
        btnRefresh.backgroundColor = .secondaryColor
        btnRefresh.layer.cornerRadius = 23
        btnRefresh.backgroundColor = .secondaryColor
        btnRefresh.addShadow()
        btnRefresh.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnRefresh"] = btnRefresh
        baseView.addSubview(btnRefresh)
        
        tripDistanceView.isHidden = true
        tripDistanceView.backgroundColor = .secondaryColor
        layoutDict["tripDistanceView"] = tripDistanceView
        tripDistanceView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(tripDistanceView)
        
        backButton.setImage(UIImage(named: "BackImage"), for: .normal)
        layoutDict["backButton"] = backButton
        backButton.translatesAutoresizingMaskIntoConstraints = false
        tripDistanceView.addSubview(backButton)
        
        tripMeterTitleLabel.text = "txt_trip_meter".localize() + " :"
        tripMeterTitleLabel.textColor = .txtColor
        tripMeterTitleLabel.textAlignment = .left
        tripMeterTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        layoutDict["tripMeterTitleLabel"] = tripMeterTitleLabel
        tripMeterTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tripDistanceView.addSubview(tripMeterTitleLabel)
        
        tripEndImgBtn.setImage(UIImage(named: "uploadImg"), for: .normal)
        tripEndImgBtn.contentMode = .scaleAspectFit
        layoutDict["tripEndImgBtn"] = tripEndImgBtn
        tripEndImgBtn.layer.borderWidth = 2
        tripEndImgBtn.layer.borderColor = UIColor.txtColor.cgColor
        tripEndImgBtn.translatesAutoresizingMaskIntoConstraints = false
        tripDistanceView.addSubview(tripEndImgBtn)
        
        tripEndTxtfield.placeholder = "txt_enter_tripmeter_kilometres".localize()
        tripEndTxtfield.addPadding(.left(13))
        tripEndTxtfield.backgroundColor = .secondaryColor
        tripEndTxtfield.layer.cornerRadius = 5
        tripEndTxtfield.layer.borderColor = UIColor.gray.cgColor
        tripEndTxtfield.layer.borderWidth = 1
        tripEndTxtfield.textColor = .txtColor
        tripEndTxtfield.font = UIFont.appRegularFont(ofSize: 16)
        tripEndTxtfield.keyboardType = .decimalPad
        layoutDict["tripEndTxtfield"] = tripEndTxtfield
        tripEndTxtfield.translatesAutoresizingMaskIntoConstraints = false
        tripDistanceView.addSubview(tripEndTxtfield)
        
        submitBtn.setTitle("text_submit".localize(), for: .normal)
        submitBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        submitBtn.setTitleColor(.secondaryColor, for: .normal)
        submitBtn.layer.cornerRadius = 5
        submitBtn.backgroundColor = .themeColor
        layoutDict["submitBtn"] = submitBtn
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        tripDistanceView.addSubview(submitBtn)
        
        
        //---------NotesView
        
        notesView.isHidden = true
        notesView.backgroundColor = .txtColor.withAlphaComponent(0.35)
        notesView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["notesView"] = notesView
        baseView.addSubview(notesView)
        
        bgView.isHidden = true
        bgView.backgroundColor = .secondaryColor
        bgView.layer.cornerRadius = 10
        bgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["bgView"] = bgView
        baseView.addSubview(bgView)
        
        detailedNotes.backgroundColor = .secondaryColor
        detailedNotes.numberOfLines = 0
        detailedNotes.lineBreakMode = .byWordWrapping
        detailedNotes.textColor = .txtColor
        detailedNotes.textAlignment = .center
        detailedNotes.font = UIFont.systemFont(ofSize: 13)
        detailedNotes.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["detailedNotes"] = detailedNotes
        bgView.addSubview(detailedNotes)
        
        

        mapview.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        mapview.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        btnMenu.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 30).isActive = true
      

        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btnSos]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        btnSos.heightAnchor.constraint(equalToConstant: 48).isActive = true
        btnSos.widthAnchor.constraint(equalToConstant: 48).isActive = true
        btnSos.centerYAnchor.constraint(equalTo: btnMenu.centerYAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[waitingTimeView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        stackAddress.topAnchor.constraint(equalTo: btnMenu.bottomAnchor, constant: 12).isActive = true
        
        waitingTimeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[waitingTimeLbl]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        waitingTimeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[waitingTimeLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[btnMenu(48)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        btnMenu.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        waitingTimeView.topAnchor.constraint(equalTo: stackAddress.bottomAnchor, constant: 10).isActive = true

        requestIdLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        requestIdLabel.centerYAnchor.constraint(equalTo: btnMenu.centerYAnchor).isActive = true
        requestIdLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        requestIdLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
        // -------------------Stack Address

        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[stackAddress]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        pickupView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewPickupColor(10)]-16-[lblPickup]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        pickupView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblPickup(30)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewPickupColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        viewPickupColor.centerYAnchor.constraint(equalTo: lblPickup.centerYAnchor, constant: 0).isActive = true
        
        stopView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewStopColor(10)]-16-[lblStop]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        stopView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblStop(30)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewStopColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        viewStopColor.centerYAnchor.constraint(equalTo: lblStop.centerYAnchor, constant: 0).isActive = true
        
        dropView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewDropColor(10)]-16-[lblDrop]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        dropView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblDrop(30)]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewDropColor.heightAnchor.constraint(equalToConstant: 10).isActive = true
        viewDropColor.centerYAnchor.constraint(equalTo: lblDrop.centerYAnchor, constant: 0).isActive = true
        
        //----------------->MapStyle

        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[btnMapStyle(46)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        btnMapStyle.heightAnchor.constraint(equalToConstant: 46).isActive = true
        mapStyleBottomConstraint = btnMapStyle.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -10)
        mapStyleBottomConstraint?.isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btnRefresh(46)]-12-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        btnRefresh.heightAnchor.constraint(equalToConstant: 46).isActive = true
        refreshBottomConstraint = btnRefresh.bottomAnchor.constraint(equalTo: containerView.topAnchor, constant: -10)
        refreshBottomConstraint?.isActive = true
        
        // ----------------scrollview
        
//        if LocalDB.shared.currentTripDetail?.isInstantTrip == false {
//            self.driverView.isHidden = false
//        } else {
//            self.driverView.isHidden = true
//
//        }
       
        containerView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
       
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[stackvw][distanceView]|", options: [], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[stackvw]-10-|", options: [], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[distanceView]-10-|", options: [], metrics: nil, views: layoutDict))
        
        
        handleBarView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-2-[handleBarImgView(5)]-2-|", options: [], metrics: nil, views: layoutDict))
        handleBarImgView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        handleBarImgView.centerXAnchor.constraint(equalTo: handleBarView.centerXAnchor, constant: 0).isActive = true
        
        driverView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[imgProfile(100)]-8-[lblDriverName(25)]-12-[notesStackView]-12-[linedView(13)]|", options: [], metrics: nil, views: layoutDict))
       
        driverView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[imgProfile(100)]-(>=15)-[callBtn(50)]-20-[smsBtn(50)]-(>=30)-|", options: [APIHelper.appLanguageDirection ,.alignAllCenterY], metrics: nil, views: layoutDict))
        
        activityIndicator.centerXAnchor.constraint(equalTo: imgProfile.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: imgProfile.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true

        callBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        smsBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true

        ratingLbl.leadingAnchor.constraint(equalTo: lblDriverName.trailingAnchor, constant: 0).isActive = true
        ratingLbl.bottomAnchor.constraint(equalTo: lblDriverName.topAnchor, constant: 0).isActive = true
        lblDriverName.centerXAnchor.constraint(equalTo: imgProfile.centerXAnchor, constant: 0).isActive = true


        driverView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[linedView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        driverView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[notesStackView]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        notesLabel.heightAnchor.constraint(greaterThanOrEqualToConstant: 30).isActive = true
        
        
        // -----------NotesView
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[notesView]|", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[notesView]|", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[bgView]-15-|", options: [], metrics: nil, views: layoutDict))
        bgView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor).isActive = true
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[detailedNotes]-20-|", options: [], metrics: nil, views: layoutDict))
        bgView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[detailedNotes]-20-|", options: [], metrics: nil, views: layoutDict))
        
        // -----------distanceView
        
        distanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[distanceLbl(20)]-2-[btnNav(46)]-5-[paySeparator(1)]-8-[viewTripButton]-8-|", options: [], metrics: nil, views: layoutDict))
        
        distanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[distanceLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        distanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[paymentBtn(130)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        distanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btnNav(46)]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        distanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[paySeparator]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        paymentBtn.centerYAnchor.constraint(equalTo: btnNav.centerYAnchor, constant: 0).isActive = true
        paymentBtn.heightAnchor.constraint(equalToConstant: 22).isActive = true
        distanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[viewTripButton]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        btnArrived.heightAnchor.constraint(equalToConstant: 48).isActive = true
        btnStartTrip.heightAnchor.constraint(equalToConstant: 48).isActive = true
        btnEndTrip.heightAnchor.constraint(equalToConstant: 48).isActive = true
        viewCancelTrip.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        viewCancelTrip.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[btnCancelTrip]-40-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewCancelTrip.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[btnCancelTrip]|", options: [], metrics: nil, views: layoutDict))
        
        //-----------TripEndDetialsForOutstationScreen
        
        tripDistanceView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor).isActive = true
        tripDistanceView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tripDistanceView]|", options: [], metrics: nil, views: layoutDict))
        
        tripDistanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[backButton(32)]-20-[tripMeterTitleLabel(20)]-20-[tripEndImgBtn(200)]-32-[tripEndTxtfield(40)]", options: [], metrics: nil, views: layoutDict))
        
        tripDistanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[submitBtn(50)]-20-|", options: [], metrics: nil, views: layoutDict))
    
        tripDistanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backButton(30)]", options: [], metrics: nil, views: layoutDict))
        
        tripDistanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[tripMeterTitleLabel]-20-|", options: [], metrics: nil, views: layoutDict))
        
        tripEndImgBtn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        tripEndImgBtn.centerXAnchor.constraint(equalTo: tripDistanceView.centerXAnchor).isActive = true
        
        tripDistanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[tripEndTxtfield]-20-|", options: [], metrics: nil, views: layoutDict))
        
        tripDistanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[submitBtn]-20-|", options: [], metrics: nil, views: layoutDict))
    }
    
}
extension TripView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        mapStyleBottomConstraint?.constant = -scrollView.contentOffset.y - 10
        refreshBottomConstraint?.constant = -scrollView.contentOffset.y - 10
    }
}

class DashedCurvedView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.applyCurvedPath(givenView: self, curvedPercent: 0.5)
    }
    func pathCurvedForView(givenView: UIView, curvedPercent:CGFloat) ->UIBezierPath
    {
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:0, y:0))
        
        arrowPath.addQuadCurve(to: CGPoint(x:0, y:givenView.bounds.size.height), controlPoint: CGPoint(x:givenView.bounds.size.width, y:givenView.bounds.size.height/2))

        arrowPath.close()
        UIColor.txtColor.setFill()
        arrowPath.fill()
        return arrowPath
    }
    
    func applyCurvedPath(givenView: UIView,curvedPercent:CGFloat) {
        guard curvedPercent <= 1 && curvedPercent >= 0 else{
            return
        }
        
        let shapeLayer = CAShapeLayer(layer: givenView.layer)
        shapeLayer.path = self.pathCurvedForView(givenView: givenView,curvedPercent: curvedPercent).cgPath
        shapeLayer.frame = givenView.bounds
        shapeLayer.masksToBounds = true
        givenView.layer.mask = shapeLayer
    }
}


class DashedLeftCurvedView: UIView {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.applyCurvedPath(givenView: self, curvedPercent: 0.5)
    }
    func pathCurvedForView(givenView: UIView, curvedPercent:CGFloat) ->UIBezierPath
    {
        let arrowPath = UIBezierPath()
        arrowPath.move(to: CGPoint(x:givenView.bounds.size.width, y:0))
        
        arrowPath.addQuadCurve(to: CGPoint(x:givenView.bounds.size.width, y:givenView.bounds.size.height), controlPoint: CGPoint(x:0, y:givenView.bounds.size.height/2))

        arrowPath.close()
        UIColor.txtColor.setFill()
        arrowPath.fill()
        return arrowPath
    }
    
    func applyCurvedPath(givenView: UIView,curvedPercent:CGFloat) {
        guard curvedPercent <= 1 && curvedPercent >= 0 else{
            return
        }
        
        let shapeLayer = CAShapeLayer(layer: givenView.layer)
        shapeLayer.path = self.pathCurvedForView(givenView: givenView,curvedPercent: curvedPercent).cgPath
        shapeLayer.frame = givenView.bounds
        shapeLayer.masksToBounds = true
        givenView.layer.mask = shapeLayer
    }
}
