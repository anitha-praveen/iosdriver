//
//  OnlineOfflineView.swift
//  Taxiappz Driver
//
//  Created by spextrum on 22/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit
import SWRevealViewController
import GoogleMaps

class OnlineOfflineView: UIView {
    
    let declinedView = DeclineView()
    
    var mapview = GMSMapView()
    let driverMarker = GMSMarker()
    
    var profileBtn = UIButton()
    var activityIndicator = UIActivityIndicatorView()
    let instantJobBtn = UIButton(type: .custom)
    
    
    var offlineOnlineBtnView = UIView()
    var onlineBtn = UIButton()
    var onOfflbl = UILabel()
    var offlineBtn = UIButton()
    
    
    let goToAddressView = UIView()
    let lblGoToAddress = UILabel()
    let btnAddGoToAddress = UIButton()
    
    var stackBottomView = UIStackView()
    
    let viewDriverOption = UIView()
    let lblOffDuty = UILabel()
    let lblOnDuty = UILabel()
    let lblGoto = UILabel()
    
    var dragger: UISlider = {
        let slider = UISlider()
        slider.minimumTrackTintColor = .red
        slider.maximumTrackTintColor = .red
        slider.isContinuous = false
        slider.minimumValue = 1
        slider.maximumValue = 5
        slider.setThumbImage(UIImage(named: "delete"), for: .normal)
        slider.translatesAutoresizingMaskIntoConstraints = false
        return slider
    }()
    
    var btnOffDuty: UIButton = {
        let view = UIButton()
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var btnOnDuty: UIButton = {
        let view = UIButton()
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    var btnGoTo: UIButton = {
        let view = UIButton()
        view.backgroundColor = .red
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    var draggerValue:Float = 1.0
    
    let lblCantGetTrip = UILabel()
    var offlineOnlinelbl = UILabel()
    
    var driverDetialsView = UIView()
    
    var todaystripsView = UIView()
    var todaysStatusTitleLbl = UILabel()
    var completedLbl = UILabel()
    var cancelledLbl = UILabel()

    var walletBalanceView = UIView()
    var walletBalanceTitleLabel = UILabel()
    var walletbalance = UILabel()
    var earningsTitleLbl = UILabel()
    var earningsLbl = UILabel()
    
    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView, controller: UIViewController) {
        
        baseView.subviews.forEach({
            $0.removeAllConstraints()
            $0.removeFromSuperview()
        })
        
        baseView.backgroundColor = .secondaryColor
        
        
        // MARK: - MapView Initial Set
        mapview.setMinZoom(5, maxZoom: 19)
        mapview.isTrafficEnabled = false
        mapview.settings.compassButton = false
        mapview.isMyLocationEnabled = true
        mapview.isBuildingsEnabled = false
        mapview.isIndoorEnabled = true
        layoutDict["mapview"] = mapview
        mapview.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(mapview)
        
        driverMarker.icon = UIImage(named: "pin_driver")
        driverMarker.groundAnchor = CGPoint(x: 0.5, y: 0.5)
        
        
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            profileBtn.addTarget(controller.revealViewController(), action: #selector(SWRevealViewController.revealToggle(_:)),for: .touchUpInside)
        } else {
            profileBtn.addTarget(controller.revealViewController(), action: #selector(SWRevealViewController.rightRevealToggle(_:)),for: .touchUpInside)
        }
        
        profileBtn.setImage(UIImage(named: "ic_menu"), for: .normal)
//        profileBtn.layer.cornerRadius = 28
//        profileBtn.layer.borderColor = UIColor.themeColor.cgColor
//        profileBtn.layer.borderWidth = 2
//        profileBtn.clipsToBounds = true
//        profileBtn.backgroundColor = .hexToColor("C4C4C4")
//        profileBtn.addShadow()
        layoutDict["profileBtn"] = profileBtn
        profileBtn.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(profileBtn)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .lightGray
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(activityIndicator)
        
        instantJobBtn.contentEdgeInsets = UIEdgeInsets(top: 3, left: 20, bottom: 3, right: 20)
        instantJobBtn.addShadow()
        instantJobBtn.backgroundColor = .secondaryColor
        instantJobBtn.setTitleColor(.txtColor, for: .normal)
        instantJobBtn.setTitle("txt_intant_trip".localize(), for: .normal)
        instantJobBtn.titleLabel?.font = UIFont.appFont(ofSize: 15)
        instantJobBtn.layer.cornerRadius = 5
        instantJobBtn.layer.borderColor = UIColor.themeColor.cgColor
        instantJobBtn.layer.borderWidth = 1.5
        layoutDict["instantJobBtn"] = instantJobBtn
        instantJobBtn.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(instantJobBtn)
        
        offlineOnlineBtnView.isHidden = false
        offlineOnlineBtnView.isUserInteractionEnabled = true
        offlineOnlineBtnView.backgroundColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        offlineOnlineBtnView.layer.cornerRadius = 15
        layoutDict["offlineOnlineBtnView"] = offlineOnlineBtnView
        offlineOnlineBtnView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(offlineOnlineBtnView)
        
        [onlineBtn, offlineBtn].forEach {
            $0.setImage(UIImage(named: "onlineOfflineImg")?.withRenderingMode(.alwaysTemplate), for: .normal)
            $0.backgroundColor = .secondaryColor
            $0.layer.cornerRadius = 15
            $0.clipsToBounds = true
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        onlineBtn.isHidden = true
        onlineBtn.imageView?.tintColor = .hexToColor("FD6F70")
        layoutDict["onlineBtn"] = onlineBtn
        offlineOnlineBtnView.addSubview(onlineBtn)
        
        
        onOfflbl.textAlignment = .center
        onOfflbl.textColor = .secondaryColor
        onOfflbl.font = UIFont.appSemiBold(ofSize: 16)
        onOfflbl.backgroundColor = .clear
        layoutDict["onOfflbl"] = onOfflbl
        onOfflbl.translatesAutoresizingMaskIntoConstraints = false
        offlineOnlineBtnView.addSubview(onOfflbl)
        onOfflbl.sizeToFit()
        
        
        offlineBtn.imageView?.tintColor = UIColor(red: 0.769, green: 0.769, blue: 0.769, alpha: 1)
        layoutDict["offlineBtn"] = offlineBtn
        offlineOnlineBtnView.addSubview(offlineBtn)
        
        // -------------Go to address
        
        goToAddressView.isHidden = true
        goToAddressView.layer.cornerRadius = 8
        goToAddressView.backgroundColor = .secondaryColor
        goToAddressView.addShadow()
        layoutDict["goToAddressView"] = goToAddressView
        goToAddressView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(goToAddressView)
        
        lblGoToAddress.text = "Add your go to address to get rides"
        lblGoToAddress.numberOfLines = 0
        lblGoToAddress.lineBreakMode = .byWordWrapping
        lblGoToAddress.textAlignment = APIHelper.appTextAlignment
        lblGoToAddress.textColor = .txtColor
        lblGoToAddress.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["lblGoToAddress"] = lblGoToAddress
        lblGoToAddress.translatesAutoresizingMaskIntoConstraints = false
        goToAddressView.addSubview(lblGoToAddress)
        
        btnAddGoToAddress.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        btnAddGoToAddress.setTitle("ADD", for: .normal)
        btnAddGoToAddress.layer.cornerRadius = 5
        btnAddGoToAddress.titleLabel?.font = UIFont.appSemiBold(ofSize: 15)
        btnAddGoToAddress.setTitleColor(.themeTxtColor, for: .normal)
        btnAddGoToAddress.backgroundColor = .themeColor
        layoutDict["btnAddGoToAddress"] = btnAddGoToAddress
        btnAddGoToAddress.translatesAutoresizingMaskIntoConstraints = false
        goToAddressView.addSubview(btnAddGoToAddress)
        
        // ---------------
        
        stackBottomView.axis = .vertical
        stackBottomView.distribution = .fill
        stackBottomView.spacing = 0
        layoutDict["stackBottomView"] = stackBottomView
        stackBottomView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(stackBottomView)
        
        // ---------------------- Driver Options
        
        viewDriverOption.isHidden = true
        viewDriverOption.layer.cornerRadius = 30
        viewDriverOption.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewDriverOption.backgroundColor = .secondaryColor
        layoutDict["viewDriverOption"] = viewDriverOption
        viewDriverOption.translatesAutoresizingMaskIntoConstraints = false
        stackBottomView.addArrangedSubview(viewDriverOption)
        
    
        lblOffDuty.text = "Off Duty"
        lblOffDuty.numberOfLines = 0
        lblOffDuty.lineBreakMode = .byWordWrapping
        lblOffDuty.font = UIFont.appBoldFont(ofSize: 14)
        lblOffDuty.textAlignment = .center
        lblOffDuty.textColor = .txtColor
        layoutDict["lblOffDuty"] = lblOffDuty
        lblOffDuty.translatesAutoresizingMaskIntoConstraints = false
        viewDriverOption.addSubview(lblOffDuty)
        
      
        lblOnDuty.text = "On Duty"
        lblOnDuty.numberOfLines = 0
        lblOnDuty.lineBreakMode = .byWordWrapping
        lblOnDuty.font = UIFont.appBoldFont(ofSize: 14)
        lblOnDuty.textAlignment = .center
        lblOnDuty.textColor = .txtColor
        layoutDict["lblOnDuty"] = lblOnDuty
        lblOnDuty.translatesAutoresizingMaskIntoConstraints = false
        viewDriverOption.addSubview(lblOnDuty)
        
    
        
        lblGoto.text = "Go To"
        lblGoto.numberOfLines = 0
        lblGoto.lineBreakMode = .byWordWrapping
        lblGoto.font = UIFont.appBoldFont(ofSize: 14)
        lblGoto.textAlignment = .center
        lblGoto.textColor = .txtColor
        layoutDict["lblGoto"] = lblGoto
        lblGoto.translatesAutoresizingMaskIntoConstraints = false
        viewDriverOption.addSubview(lblGoto)
       
        
        
        layoutDict["btnOffDuty"] = btnOffDuty
        self.viewDriverOption.addSubview(btnOffDuty)
        
        layoutDict["btnOnDuty"] = btnOnDuty
        self.viewDriverOption.addSubview(btnOnDuty)
        
        layoutDict["btnGoTo"] = btnGoTo
        self.viewDriverOption.addSubview(btnGoTo)
        
        layoutDict["dragger"] = dragger
        self.viewDriverOption.addSubview(dragger)
        
        
        // ----------------------
        
        lblCantGetTrip.isHidden = true
        lblCantGetTrip.numberOfLines = 0
        lblCantGetTrip.lineBreakMode = .byWordWrapping
        lblCantGetTrip.textAlignment = .center
        lblCantGetTrip.font = UIFont.appRegularFont(ofSize: 14)
        lblCantGetTrip.backgroundColor = UIColor.yellow.withAlphaComponent(0.6)
        lblCantGetTrip.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblCantGetTrip"] = lblCantGetTrip
        stackBottomView.addArrangedSubview(lblCantGetTrip)
        
        offlineOnlinelbl.isHidden = true
        offlineOnlinelbl.textColor = .txtColor
        offlineOnlinelbl.textAlignment = .center
        offlineOnlinelbl.font = UIFont.appSemiBold(ofSize: 20)
        offlineOnlinelbl.addShadow()
        offlineOnlinelbl.backgroundColor = .secondaryColor
        layoutDict["offlineOnlinelbl"] = offlineOnlinelbl
        offlineOnlinelbl.translatesAutoresizingMaskIntoConstraints = false
        stackBottomView.addArrangedSubview(offlineOnlinelbl)
    
        driverDetialsView.backgroundColor = .secondaryColor
        driverDetialsView.addBorder(edges: .top, colour: .themeColor, thickness: 1 )
        driverDetialsView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["driverDetialsView"] = driverDetialsView
        stackBottomView.addArrangedSubview(driverDetialsView)
        
        todaystripsView.backgroundColor = .secondaryColor
        todaystripsView.addBorder(edges: .right, colour: .txtColor, thickness: 1 )
        todaystripsView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["todaystripsView"] = todaystripsView
        driverDetialsView.addSubview(todaystripsView)
        
        
        todaysStatusTitleLbl.textAlignment = .center
        todaysStatusTitleLbl.textColor = .txtColor
        todaysStatusTitleLbl.font = UIFont.boldSystemFont(ofSize: 16)
        todaysStatusTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["todaysStatusTitleLbl"] = todaysStatusTitleLbl
        todaystripsView.addSubview(todaysStatusTitleLbl)
        
        completedLbl.textAlignment = .center
        completedLbl.textColor = .txtColor
        completedLbl.font = UIFont.appSemiBold(ofSize: 12)
        completedLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["completedLbl"] = completedLbl
        todaystripsView.addSubview(completedLbl)
        
        cancelledLbl.textAlignment = .center
        cancelledLbl.textColor = .txtColor
        cancelledLbl.font = UIFont.appSemiBold(ofSize: 12)
        cancelledLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["cancelledLbl"] = cancelledLbl
        todaystripsView.addSubview(cancelledLbl)
                
        walletBalanceView.backgroundColor = .secondaryColor
        walletBalanceView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["walletBalanceView"] = walletBalanceView
        driverDetialsView.addSubview(walletBalanceView)
    
       
        walletBalanceTitleLabel.textAlignment = .center
        walletBalanceTitleLabel.textColor = .txtColor
        walletBalanceTitleLabel.font = UIFont.boldSystemFont(ofSize: 16)
        walletBalanceTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["walletBalanceTitleLabel"] = walletBalanceTitleLabel
        walletBalanceView.addSubview(walletBalanceTitleLabel)
       
        walletbalance.textAlignment = .center
        walletbalance.textColor = .txtColor
        walletbalance.font = UIFont.appSemiBold(ofSize: 12)
        walletbalance.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["walletbalance"] = walletbalance
        walletBalanceView.addSubview(walletbalance)
        
        
        earningsTitleLbl.textAlignment = .center
        earningsTitleLbl.textColor = .txtColor
        earningsTitleLbl.font = UIFont.boldSystemFont(ofSize: 16)
        earningsTitleLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["earningsTitleLbl"] = earningsTitleLbl
        walletBalanceView.addSubview(earningsTitleLbl)
        
        earningsLbl.textAlignment = .center
        earningsLbl.textColor = .txtColor
        earningsLbl.font = UIFont.appSemiBold(ofSize: 12)
        earningsLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["earningsLbl"] = earningsLbl
        walletBalanceView.addSubview(earningsLbl)
        
        
        declinedView.removeFromSuperview()
        declinedView.isHidden = true
        layoutDict["declinedView"] = declinedView
        declinedView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(declinedView)
        
        earningsTitleLbl.text = "txt_earnings".localize()
        todaysStatusTitleLbl.text = "txt_tdy_status".localize()
        walletBalanceTitleLabel.text = "txt_wallet_bal".localize()
        
        
        mapview.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        declinedView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        stackBottomView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        mapview.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        declinedView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[declinedView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: self.layoutDict))
        
        
        instantJobBtn.heightAnchor.constraint(equalToConstant: 38).isActive = true
        instantJobBtn.centerYAnchor.constraint(equalTo: profileBtn.centerYAnchor, constant: 0).isActive = true
       
        profileBtn.topAnchor.constraint(equalTo: mapview.topAnchor, constant: 25).isActive = true
        profileBtn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[profileBtn(50)]-(>=15)-[instantJobBtn]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        activityIndicator.centerXAnchor.constraint(equalTo: profileBtn.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: profileBtn.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        
        //-10-[offlineOnlineBtnView(30)]
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[offlineOnlineBtnView(30)]-15-[stackBottomView]", options: [], metrics: nil, views: layoutDict))
        
        offlineOnlineBtnView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 0).isActive = true
        offlineOnlineBtnView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-1-[onOfflbl]-1-|", options: [], metrics: nil, views: layoutDict))
        offlineOnlineBtnView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-1-[offlineBtn(30)]-5-[onOfflbl]-5-[onlineBtn(30)]-1-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
        lblCantGetTrip.heightAnchor.constraint(equalToConstant: 30).isActive = true
        offlineOnlinelbl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        driverDetialsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[todaystripsView][walletBalanceView(==todaystripsView)]|", options: [], metrics: nil, views: layoutDict))
        
        driverDetialsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-[walletBalanceView]-|", options: [], metrics: nil, views: layoutDict))
        
        todaystripsView.centerYAnchor.constraint(equalTo: walletBalanceView.centerYAnchor).isActive = true
        
        todaystripsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[todaysStatusTitleLbl(20)]-10-[completedLbl]-8-[cancelledLbl]-10-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        
        todaystripsView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[todaysStatusTitleLbl]-10-|", options: [], metrics: nil, views: layoutDict))
        
        walletBalanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[walletBalanceTitleLabel(20)]-8-[walletbalance(20)]-8-[earningsTitleLbl(20)]-8-[earningsLbl(20)]-10-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        walletBalanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[walletBalanceTitleLabel]-10-|", options: [], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[stackBottomView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        // -------------Driver options
        
  
        viewDriverOption.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblOffDuty][lblOnDuty(==lblOffDuty)][lblGoto(==lblOffDuty)]|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
        viewDriverOption.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[dragger(30)]-8-[lblOffDuty]-8-|", options: [], metrics: nil, views: layoutDict))
       
        
        dragger.leadingAnchor.constraint(equalTo: lblOffDuty.centerXAnchor, constant: -10).isActive = true
        dragger.trailingAnchor.constraint(equalTo: lblGoto.centerXAnchor, constant: 10).isActive = true
       
        btnOffDuty.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btnOffDuty.centerYAnchor.constraint(equalTo: dragger.centerYAnchor, constant: 0).isActive = true
        btnOffDuty.widthAnchor.constraint(equalToConstant: 20).isActive = true
        btnOffDuty.leadingAnchor.constraint(equalTo: dragger.leadingAnchor, constant: 0).isActive = true
        
        btnOnDuty.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btnOnDuty.centerYAnchor.constraint(equalTo: dragger.centerYAnchor, constant: 0).isActive = true
        btnOnDuty.widthAnchor.constraint(equalToConstant: 20).isActive = true
        btnOnDuty.centerXAnchor.constraint(equalTo: dragger.centerXAnchor, constant: 0).isActive = true
        
        btnGoTo.heightAnchor.constraint(equalToConstant: 20).isActive = true
        btnGoTo.centerYAnchor.constraint(equalTo: dragger.centerYAnchor, constant: 0).isActive = true
        btnGoTo.widthAnchor.constraint(equalToConstant: 20).isActive = true
        btnGoTo.trailingAnchor.constraint(equalTo: dragger.trailingAnchor, constant: 0).isActive = true
        
        
        // ------------Go to address
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[goToAddressView]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        goToAddressView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[lblGoToAddress]-15-[btnAddGoToAddress(80)]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        lblGoToAddress.setContentHuggingPriority(.defaultLow, for: .horizontal)
        goToAddressView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[lblGoToAddress(>=40)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        btnAddGoToAddress.heightAnchor.constraint(equalToConstant: 35).isActive = true
        btnAddGoToAddress.centerYAnchor.constraint(equalTo: lblGoToAddress.centerYAnchor, constant: 0).isActive = true
    }
}

