//
//  TripOTPView.swift
//  Taxiappz Driver
//
//  Created by spextrum on 23/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit

class TripOTPView: UIView {

    var viewContent = UIView()
    let lblHeader = UILabel()
    var lblEnterOtp = UILabel()
    var otpView = UIView()
    let textField1 = UITextField()
    let textField2 = UITextField()
    let textField3 = UITextField()
    let textField4 = UITextField()
    var btnVerify = UIButton()
    let btnCancel = UIButton()
    
    var tripDistanceView = UIView()
    let backButton = UIButton()
    let tripMeterTitleLabel = UILabel()
    var tripStartImgBtn = UIButton()
    let tripstartTxtfield = UITextField()
    let submitBtn = UIButton()

    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)

        viewContent.layer.cornerRadius = 5.0
        viewContent.backgroundColor = .secondaryColor
        viewContent.addShadow()
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewContent)
        
        otpView.semanticContentAttribute = .forceLeftToRight
        layoutDict["otpView"] = otpView
        otpView.translatesAutoresizingMaskIntoConstraints = false
        self.viewContent.addSubview(otpView)
        
        lblHeader.textAlignment = .center
        lblHeader.textColor = .txtColor
        lblHeader.text = APIHelper.shared.appName
        lblHeader.font = UIFont.appSemiBold(ofSize: 30)
        layoutDict["lblHeader"] = lblHeader
        lblHeader.translatesAutoresizingMaskIntoConstraints = false
        self.viewContent.addSubview(lblHeader)
        
        lblEnterOtp.textAlignment = .center
        lblEnterOtp.textColor = .hexToColor("333333")
        lblEnterOtp.text = "txt_note_start_ride".localize()
        lblEnterOtp.font = UIFont.appRegularFont(ofSize: 18)
        layoutDict["lblEnterOtp"] = lblEnterOtp
        lblEnterOtp.translatesAutoresizingMaskIntoConstraints = false
        self.viewContent.addSubview(lblEnterOtp)
        
        btnVerify.layer.cornerRadius = 5.0
        btnVerify.titleLabel?.font = UIFont.appRegularFont(ofSize: 18)
        btnVerify.setTitle("text_start_trip".localize(), for: .normal)
        btnVerify.backgroundColor = .themeColor
        btnVerify.addShadow()
        btnVerify.setTitleColor(.themeTxtColor, for: .normal)
        layoutDict["btnVerify"] = btnVerify
        btnVerify.translatesAutoresizingMaskIntoConstraints = false
        self.viewContent.addSubview(btnVerify)
        
        btnCancel.layer.cornerRadius = 5
        btnCancel.titleLabel?.font = UIFont.appRegularFont(ofSize: 16)
        btnCancel.setTitle("text_cancel".localize(), for: .normal)
        btnCancel.backgroundColor = .hexToColor("D9D9D9")
        btnCancel.setTitleColor(.txtColor, for: .normal)
        layoutDict["btnCancel"] = btnCancel
        btnCancel.translatesAutoresizingMaskIntoConstraints = false
        self.viewContent.addSubview(btnCancel)
        
        otpView.addSubview(textField1)
        textField1.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["textField1"] = textField1
        otpView.addSubview(textField2)
        textField2.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["textField2"] = textField2
        otpView.addSubview(textField3)
        textField3.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["textField3"] = textField3
        otpView.addSubview(textField4)
        textField4.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["textField4"] = textField4
        
        tripDistanceView.isHidden = true
        tripDistanceView.backgroundColor = .secondaryColor
        layoutDict["tripDistanceView"] = tripDistanceView
        tripDistanceView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(tripDistanceView)
        
        backButton.setImage(UIImage(named: "BackImage"), for: .normal)
        layoutDict["backButton"] = backButton
        backButton.translatesAutoresizingMaskIntoConstraints = false
        tripDistanceView.addSubview(backButton)
        
        tripMeterTitleLabel.text = "txt_trip_meter" + " :"
        tripMeterTitleLabel.textColor = .txtColor
        tripMeterTitleLabel.textAlignment = .left
        tripMeterTitleLabel.font = UIFont.boldSystemFont(ofSize: 15)
        layoutDict["tripMeterTitleLabel"] = tripMeterTitleLabel
        tripMeterTitleLabel.translatesAutoresizingMaskIntoConstraints = false
        tripDistanceView.addSubview(tripMeterTitleLabel)
        
        tripStartImgBtn.setImage(UIImage(named: "uploadImg"), for: .normal)
        tripStartImgBtn.contentMode = .scaleAspectFit
        layoutDict["tripStartImgBtn"] = tripStartImgBtn
        tripStartImgBtn.layer.borderWidth = 2
        tripStartImgBtn.layer.borderColor = UIColor.txtColor.cgColor
        tripStartImgBtn.translatesAutoresizingMaskIntoConstraints = false
        tripDistanceView.addSubview(tripStartImgBtn)
        
        tripstartTxtfield.placeholder = "txt_enter_tripmeter_kilometres".localize()
        tripstartTxtfield.addPadding(.left(13))
        tripstartTxtfield.backgroundColor = .secondaryColor
        tripstartTxtfield.layer.cornerRadius = 5
        tripstartTxtfield.layer.borderColor = UIColor.gray.cgColor
        tripstartTxtfield.layer.borderWidth = 1
        tripstartTxtfield.textColor = .txtColor
        tripstartTxtfield.font = UIFont.appRegularFont(ofSize: 16)
        tripstartTxtfield.keyboardType = .decimalPad
        layoutDict["tripstartTxtfield"] = tripstartTxtfield
        tripstartTxtfield.translatesAutoresizingMaskIntoConstraints = false
        tripDistanceView.addSubview(tripstartTxtfield)
        
        submitBtn.setTitle("text_submit".localize(), for: .normal)
        submitBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        submitBtn.setTitleColor(.secondaryColor, for: .normal)
        submitBtn.layer.cornerRadius = 5
        submitBtn.backgroundColor = .themeColor
        layoutDict["submitBtn"] = submitBtn
        submitBtn.translatesAutoresizingMaskIntoConstraints = false
        tripDistanceView.addSubview(submitBtn)
        
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[viewContent]-20-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.viewContent.centerYAnchor.constraint(equalTo: baseView.centerYAnchor, constant: 0).isActive = true
        
        self.viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblEnterOtp]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        self.viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblHeader]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
         self.viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[lblHeader]-8-[lblEnterOtp(35)]-8-[otpView(50)]-20-[btnVerify(40)]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
         self.viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[btnCancel]-10-[btnVerify(==btnCancel)]-10-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
        self.viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[otpView]-20-|", options: [], metrics: nil, views: layoutDict))
        otpView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[textField1]-(8)-[textField2(==textField1)]-(8)-[textField3(==textField1)]-(8)-[textField4(==textField1)]|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        otpView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[textField1]|", options: [], metrics: nil, views: layoutDict))
        
        tripDistanceView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor).isActive = true
        tripDistanceView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[tripDistanceView]|", options: [], metrics: nil, views: layoutDict))
        
        tripDistanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[backButton(32)]-20-[tripMeterTitleLabel(20)]-20-[tripStartImgBtn(200)]-32-[tripstartTxtfield(40)]", options: [], metrics: nil, views: layoutDict))
        
        tripDistanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[submitBtn(50)]-20-|", options: [], metrics: nil, views: layoutDict))
    
        tripDistanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backButton(30)]", options: [], metrics: nil, views: layoutDict))
        
        tripDistanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[tripMeterTitleLabel]-20-|", options: [], metrics: nil, views: layoutDict))
        
        tripStartImgBtn.widthAnchor.constraint(equalToConstant: 200).isActive = true
        tripStartImgBtn.centerXAnchor.constraint(equalTo: tripDistanceView.centerXAnchor).isActive = true
        
        tripDistanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[tripstartTxtfield]-20-|", options: [], metrics: nil, views: layoutDict))
        
        tripDistanceView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[submitBtn]-20-|", options: [], metrics: nil, views: layoutDict))
        
    }
}
