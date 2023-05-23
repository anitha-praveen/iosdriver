//
//  TripTrackingView.swift
//  Roda Driver
//
//  Created by Apple on 29/06/22.
//

import UIKit
import GoogleMaps
import MTSlideToOpen
class TripTrackingView: UIView {
    
    let mapview = GMSMapView()
    
    let btnMenu = UIButton()
    let requestIdLabel = UILabel()
    let btnSos = UIButton()
    let waitingTimeView = UIView()
    let waitingTimeLbl = UILabel()
    
    
    let viewAddress = UIView()
    let lblAddress = UILabel()
    
    let containerView = UIView()
    
    let stackvw = UIStackView()

    let driverView = UIView()
    let callBtn = UIButton()
    let btnNav = UIButton()
    let smsBtn = UIButton()
    let ratingLbl = UILabel()
    
    let imgProfile = UIImageView()
    var activityIndicator = UIActivityIndicatorView()
    let lblDriverName = UILabel()
    
    let notesStackView = UIStackView()
    let notesLabel = UILabel()
    
    let bgView = UIView()
    let notesView = UIView()
    let detailedNotes = UILabel()
    
    let distanceView = UIView()
    let distanceLbl = UILabel()
    let paymentBtn = UIButton()
    
   
    let viewTripButton = UIStackView()
    let btnArrived = UIButton()
    let btnStartTrip = UIButton()
    let btnEndTrip = UIButton()
    
    let viewCancelTrip = UIView()
    let btnCancelTrip = MTSlideToOpenView()
        
    
    var tripDistanceView = UIView()
    let backButton = UIButton()
    let tripMeterTitleLabel = UILabel()
    var tripEndImgBtn = UIButton()
    let tripEndTxtfield = UITextField()
    let submitBtn = UIButton()
        
   
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

        layoutDict["mapview"] = mapview
        mapview.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(mapview)
        
     
        viewAddress.layer.cornerRadius = 15
        viewAddress.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewAddress.backgroundColor = .themeColor
        viewAddress.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewAddress"] = viewAddress
        baseView.addSubview(viewAddress)
        
      
        lblAddress.font = UIFont.appRegularFont(ofSize: 15)
        lblAddress.textColor = .themeTxtColor
        lblAddress.textAlignment = .center
        lblAddress.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblAddress"] = lblAddress
        viewAddress.addSubview(lblAddress)
        
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
        
        driverView.addBorder(edges: .bottom,colour: .hexToColor("DADADA"))
        driverView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["driverView"] = driverView
        stackvw.addArrangedSubview(driverView)

        [imgProfile,activityIndicator,lblDriverName,callBtn,btnNav,ratingLbl,notesStackView].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            driverView.addSubview($0)
        }
        

        imgProfile.backgroundColor = .hexToColor("ACB1C0")
        imgProfile.layer.cornerRadius = 8
        imgProfile.clipsToBounds = true
        layoutDict["imgProfile"] = imgProfile
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
        
        lblDriverName.textAlignment = APIHelper.appTextAlignment
        lblDriverName.font = UIFont.appSemiBold(ofSize: 18)
        layoutDict["lblDriverName"] = lblDriverName
        
        ratingLbl.font = UIFont.appSemiBold(ofSize: 12)
        layoutDict["ratingLbl"] = ratingLbl
        
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
        
        btnNav.setImage(UIImage(named: "ic_trip_nav"), for: .normal)
        layoutDict["btnNav"] = btnNav
        

        //-----------Distance
        
        
        layoutDict["distanceView"] = distanceView
        distanceView.translatesAutoresizingMaskIntoConstraints = false
        //stackvw.addArrangedSubview(distanceView)
        containerView.addSubview(distanceView)
        
        [distanceLbl, paymentBtn,viewTripButton].forEach() {
            $0.translatesAutoresizingMaskIntoConstraints = false
            distanceView.addSubview($0)
        }
        
        distanceLbl.addBorder(edges: .left,colour: .hexToColor("DADADA"))
        distanceLbl.textColor = .txtColor
        distanceLbl.textAlignment = .center
        distanceLbl.font = UIFont.appSemiBold(ofSize: 16)
        layoutDict["distanceLbl"] = distanceLbl
        
        paymentBtn.setTitle("txt_cash_payment".localize(), for: .normal)
        //paymentBtn.contentHorizontalAlignment = .leading
        paymentBtn.setImage(UIImage(named: "ic_pay_mode_cash"), for: .normal)
        paymentBtn.setTitleColor(UIColor(red: 0.133, green: 0.169, blue: 0.271, alpha: 1), for: .normal)
        paymentBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 15)
        if APIHelper.appLanguageDirection == .directionRightToLeft {
            paymentBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
            paymentBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
        } else {
            paymentBtn.titleEdgeInsets = UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)
            paymentBtn.imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)
        }
        
        paymentBtn.imageView?.contentMode = .scaleAspectFill
        paymentBtn.layer.cornerRadius = 5
        paymentBtn.backgroundColor = .secondaryColor
        layoutDict["paymentBtn"] = paymentBtn
        
        
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
        btnCancelTrip.sliderCornerRadius = 22.5
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
        btnMenu.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
      

        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[btnSos]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        btnSos.heightAnchor.constraint(equalToConstant: 48).isActive = true
        btnSos.widthAnchor.constraint(equalToConstant: 48).isActive = true
        btnSos.centerYAnchor.constraint(equalTo: btnMenu.centerYAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[waitingTimeView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
       
        waitingTimeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[waitingTimeLbl]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        waitingTimeView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[waitingTimeLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[btnMenu(48)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        btnMenu.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        waitingTimeView.topAnchor.constraint(equalTo: btnSos.bottomAnchor, constant: 10).isActive = true

        requestIdLabel.centerXAnchor.constraint(equalTo: baseView.centerXAnchor).isActive = true
        requestIdLabel.centerYAnchor.constraint(equalTo: btnMenu.centerYAnchor).isActive = true
        requestIdLabel.widthAnchor.constraint(equalToConstant: 130).isActive = true
        requestIdLabel.heightAnchor.constraint(equalToConstant: 35).isActive = true
        
      
        // ----------------Container
        
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[viewAddress][containerView]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-25-[viewAddress]-25-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[lblAddress]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblAddress(25)]-2-|", options: [], metrics: nil, views: layoutDict))
        
       
        containerView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
       
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[stackvw][distanceView]|", options: [], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackvw]|", options: [], metrics: nil, views: layoutDict))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[distanceView]-10-|", options: [], metrics: nil, views: layoutDict))
        
        
       
        
        driverView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[imgProfile(60)]-8-[notesStackView]-8-|", options: [], metrics: nil, views: layoutDict))
        driverView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[lblDriverName(25)]-5-[ratingLbl(25)]", options: [.alignAllLeading], metrics: nil, views: layoutDict))
       
        driverView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[imgProfile(70)]-(10)-[lblDriverName]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        driverView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[callBtn(40)]-10-[btnNav(40)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        activityIndicator.centerXAnchor.constraint(equalTo: imgProfile.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: imgProfile.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 40).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 40).isActive = true

        callBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        callBtn.centerYAnchor.constraint(equalTo: imgProfile.centerYAnchor, constant: 0).isActive = true
        btnNav.heightAnchor.constraint(equalToConstant: 40).isActive = true
        btnNav.centerYAnchor.constraint(equalTo: imgProfile.centerYAnchor, constant: 0).isActive = true
        
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
        
        distanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[distanceLbl(30)]-8-[viewTripButton]-8-|", options: [], metrics: nil, views: layoutDict))
        
        distanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[paymentBtn][distanceLbl(==paymentBtn)]|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
       
       // --------------Trip Btns
        
        distanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewTripButton]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        btnArrived.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btnStartTrip.heightAnchor.constraint(equalToConstant: 45).isActive = true
        btnEndTrip.heightAnchor.constraint(equalToConstant: 45).isActive = true
        viewCancelTrip.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        viewCancelTrip.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[btnCancelTrip]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
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
