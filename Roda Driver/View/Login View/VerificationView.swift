//
//  VerificationView.swift
//  Taxiappz Driver
//
//  Created by spextrum on 22/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit

class VerificationView: UIView {

    let btnBack = UIButton()
    let lblVerify = UILabel()
    let hintLbl = UILabel()
    
    let lblGetAnotherCode = UILabel()
    let otpTfd = UIView()
    
    let textField = UITextField()
    
    let verifyotpBtn = UIButton()

    let resendBtn = UIButton()
    let otpRecieveHint = UILabel()
    
    var layoutDict = [String:AnyObject]()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        baseView.backgroundColor = .secondaryColor
        
        btnBack.setImage(UIImage(named: "back_img"), for: .normal)
        btnBack.layer.cornerRadius = 25
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnBack"] = btnBack
        baseView.addSubview(btnBack)
        
        lblVerify.text = "txt_verify_num".localize()
        lblVerify.numberOfLines = 0
        lblVerify.lineBreakMode = .byWordWrapping
        lblVerify.textColor = .txtColor
        lblVerify.font = UIFont.appSemiBold(ofSize: 25)
        lblVerify.textAlignment = APIHelper.appTextAlignment
        lblVerify.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblVerify"] = lblVerify
        baseView.addSubview(lblVerify)

        hintLbl.textColor = .txtColor
        hintLbl.text = "txt_chk_sms".localize() + " " + "txt_pin_sent".localize()
        hintLbl.numberOfLines = 0
        hintLbl.lineBreakMode = .byWordWrapping
        hintLbl.font = UIFont.appSemiBold(ofSize: 15)
        hintLbl.textAlignment = APIHelper.appTextAlignment
        hintLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["hintLbl"] = hintLbl
        baseView.addSubview(hintLbl)

        
        otpTfd.addBorder(edges: .bottom, colour: .txtColor, thickness: 1)
        otpTfd.semanticContentAttribute = .forceLeftToRight
        otpTfd.backgroundColor = .secondaryColor
        otpTfd.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["otpTfd"] = otpTfd
        baseView.addSubview(otpTfd)
        
        textField.defaultTextAttributes.updateValue(24.0, forKey: NSAttributedString.Key.kern)
        textField.becomeFirstResponder()
        textField.placeholder = "*   *   *   *"
        textField.textContentType = .oneTimeCode
        textField.keyboardType = .numberPad
        textField.font = UIFont.appBoldFont(ofSize: 20)
        textField.textColor = .txtColor
        textField.textAlignment = APIHelper.appTextAlignment
        textField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["textField"] = textField
        otpTfd.addSubview(textField)
        
        verifyotpBtn.setTitleColor(.themeTxtColor, for: .normal)
        verifyotpBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 18)
        verifyotpBtn.setTitle("txt_next".localize().uppercased(), for: .normal)
        verifyotpBtn.backgroundColor = .themeColor
        verifyotpBtn.layer.cornerRadius = 5
        verifyotpBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["verifyotpBtn"] = verifyotpBtn
        baseView.addSubview(verifyotpBtn)
    
        resendBtn.layer.cornerRadius = 5
        resendBtn.contentEdgeInsets = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        self.resendBtn.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        resendBtn.setTitle("txt_send_new_code".localize(), for: .normal)
        resendBtn.setTitleColor(.themeTxtColor, for: .normal)
        resendBtn.backgroundColor = .themeColor
        resendBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["resendBtn"] = resendBtn
        baseView.addSubview(resendBtn)
        
        otpRecieveHint.isHidden = true
        otpRecieveHint.text = "txt_otp_wait".localize()
        otpRecieveHint.font = UIFont.appRegularFont(ofSize: 15)
        otpRecieveHint.numberOfLines = 0
        otpRecieveHint.lineBreakMode = .byWordWrapping
        otpRecieveHint.textColor = .txtColor
        otpRecieveHint.textAlignment = APIHelper.appTextAlignment
        otpRecieveHint.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["otpRecieveHint"] = otpRecieveHint
        baseView.addSubview(otpRecieveHint)

        lblGetAnotherCode.textColor = .hexToColor("#636363")
        lblGetAnotherCode.textAlignment = APIHelper.appTextAlignment
        lblGetAnotherCode.font = UIFont.appRegularFont(ofSize: 14)
        lblGetAnotherCode.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblGetAnotherCode"] = lblGetAnotherCode
        baseView.addSubview(lblGetAnotherCode)
        
        
        btnBack.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 20).isActive = true
        
        btnBack.widthAnchor.constraint(equalToConstant: 50).isActive = true
        btnBack.leadingAnchor.constraint(equalTo: baseView.leadingAnchor, constant: 20).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnBack(50)]-20-[lblVerify]-(30)-[hintLbl]-(30)-[otpTfd(50)]-(25)-[lblGetAnotherCode(30)]-15-[resendBtn(40)]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[lblGetAnotherCode]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
    
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(32)-[otpTfd]", options: [], metrics: nil, views: layoutDict))
        
        otpTfd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-5-[textField(150)]-5-|", options: [.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        otpTfd.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[textField]|", options: [], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[lblVerify]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(16)-[hintLbl]-(16)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(32)-[resendBtn]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lblGetAnotherCode]-15-[otpRecieveHint]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(30)-[otpRecieveHint]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        verifyotpBtn.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: -20).isActive = true
        verifyotpBtn.heightAnchor.constraint(equalToConstant: 45).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(32)-[verifyotpBtn]-(32)-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.layoutIfNeeded()
        baseView.setNeedsLayout()
    }
}

