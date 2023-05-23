//
//  ProfileView.swift
//  Taxiappz Driver
//
//  Created by NPlus Technologies on 02/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit

/*
class ProfileView: UIView {
    
    let backBtn = UIButton()

    let titleView = UIView()
    let titleLbl = UILabel()

    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let nameLbl = UILabel()
    let profpicBtn = UIButton()
    let profpicEditBtn = UIButton()
    var activityIndicator = UIActivityIndicatorView()
    
    let lblFirstName = UILabel()
    let viewFirstName = UIView()
    let txtFirstName = UITextField()
    let arrowFirstName = UIImageView()
    
    let lblLastName = UILabel()
    let viewLastName = UIView()
    let txtLastName = UITextField()
    let arrowLastName = UIImageView()
    
    let lblEmail = UILabel()
    let viewEmail = UIView()
    let txtEmail = UITextField()
    let arrowEmail = UIImageView()
    
    let lblPhoneNumber = UILabel()
    let viewPhoneNumber = UIView()
    let txtPhoneNumber = UITextField()
    let arrowPhoneNumber = UIImageView()
    
    let lblSetLanguage = UILabel()
    let viewSetLanguage = UIView()
    let txtSetLanguage = UITextField()
    let arrowSetLanguage = UIImageView()
    
    let lblVehicle = UILabel()
    let viewVehicle = UIView()
    let txtVehicle = UITextField()
    let arrowVehicle = UIImageView()
    
   
    let lblPrefference = UILabel()
    let viewPrefference = UIView()
    let lblRecieveNotification = UILabel()
    let lblPrefferenceHint = UILabel()
    let switchPrefference = UISwitch()
    
    let btnLogout = UIButton()
    
    var layoutDic = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        

        baseView.backgroundColor = .secondaryColor
        

        backBtn.contentMode = .scaleAspectFit
        backBtn.setAppImage("backDark")
        backBtn.layer.cornerRadius = 20
        backBtn.addShadow()
        backBtn.backgroundColor = .secondaryColor
        layoutDic["backBtn"] = backBtn
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(backBtn)
      
        
        titleView.backgroundColor = .secondaryColor
        titleView.layer.cornerRadius = 8
        titleView.addShadow()
        layoutDic["titleView"] = titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(titleView)
        
        titleLbl.text = "text_profile".localize()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDic["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
        
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["scrollView"] = scrollView
        baseView.addSubview(scrollView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["containerView"] = containerView
        scrollView.addSubview(containerView)
        
        nameLbl.isHidden = true
        nameLbl.font = .appSemiBold(ofSize: 30)
        nameLbl.textColor = .txtColor
        nameLbl.textAlignment = APIHelper.appTextAlignment
        layoutDic["nameLbl"] = nameLbl
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
      //  containerView.addSubview(nameLbl)
        
        profpicBtn.layer.cornerRadius = 33
        profpicBtn.layer.masksToBounds = true
        profpicBtn.setImage(UIImage(named: "profileEditPlaceHolder"), for: .normal)
        profpicBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profpicBtn"] = profpicBtn
        containerView.addSubview(profpicBtn)
        profpicEditBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profpicEditBtn"] = profpicEditBtn
        containerView.addSubview(profpicEditBtn)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(activityIndicator)
        
        [lblFirstName,lblLastName,lblEmail,lblPhoneNumber,lblSetLanguage,lblVehicle,lblPrefference].forEach({
            
            $0.font = UIFont.appRegularFont(ofSize: 14)
            $0.textColor = UIColor(red: 0.537, green: 0.573, blue: 0.639, alpha: 1)
            $0.textAlignment = APIHelper.appTextAlignment
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        })
        
        lblFirstName.text = "text_firstname".localize().uppercased()
        layoutDic["lblFirstName"] = lblFirstName
        lblLastName.text = "text_lastname".localize().uppercased()
        layoutDic["lblLastName"] = lblLastName
        lblEmail.text = "email".localize().uppercased()
        layoutDic["lblEmail"] = lblEmail
        lblPhoneNumber.text = "hint_phone_number".localize().uppercased()
        layoutDic["lblPhoneNumber"] = lblPhoneNumber
        lblSetLanguage.text = "txt_set_lang".localize().uppercased()
        layoutDic["lblSetLanguage"] = lblSetLanguage
        lblVehicle.text = "txt_vec_info".localize().uppercased()
        layoutDic["lblVehicle"] = lblVehicle
        
        
        lblPrefference.text = "txt_preference".localize().uppercased()
        layoutDic["lblPrefference"] = lblPrefference
        
        [viewFirstName,viewLastName,viewEmail,viewPhoneNumber,viewSetLanguage,viewVehicle,viewPrefference].forEach({
            $0.layer.cornerRadius = 5
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.hexToColor("DADADA").cgColor
            $0.backgroundColor = UIColor(red: 0.969, green: 0.973, blue: 0.98, alpha: 0.5)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isUserInteractionEnabled = true
            containerView.addSubview($0)
        })
        
        layoutDic["viewFirstName"] = viewFirstName
        layoutDic["viewLastName"] = viewLastName
        layoutDic["viewEmail"] = viewEmail
        layoutDic["viewPhoneNumber"] = viewPhoneNumber
        layoutDic["viewSetLanguage"] = viewSetLanguage
        layoutDic["viewVehicle"] = viewVehicle
        layoutDic["viewPrefference"] = viewPrefference
        
        [txtFirstName,txtLastName,txtEmail,txtPhoneNumber,txtSetLanguage,txtVehicle].forEach({
            $0.isUserInteractionEnabled = false
            $0.textColor = .txtColor
            $0.textAlignment = APIHelper.appTextAlignment
            $0.font = UIFont.appRegularFont(ofSize: 16)
            $0.translatesAutoresizingMaskIntoConstraints = false
            
        })
        
       
        layoutDic["txtFirstName"] = txtFirstName
        viewFirstName.addSubview(txtFirstName)
        
       
        layoutDic["txtLastName"] = txtLastName
        viewLastName.addSubview(txtLastName)
        
        txtEmail.placeholder = "text_email_plain".localize()
        layoutDic["txtEmail"] = txtEmail
        viewEmail.addSubview(txtEmail)
        
        
        layoutDic["txtPhoneNumber"] = txtPhoneNumber
        viewPhoneNumber.addSubview(txtPhoneNumber)
        
        txtSetLanguage.text = "Language"
        layoutDic["txtSetLanguage"] = txtSetLanguage
        viewSetLanguage.addSubview(txtSetLanguage)
        
        txtVehicle.text = "txt_vec_info".localize()
        layoutDic["txtVehicle"] = txtVehicle
        viewVehicle.addSubview(txtVehicle)
        
     
        [arrowFirstName,arrowLastName,arrowEmail,arrowSetLanguage,arrowVehicle,arrowPhoneNumber].forEach({
            $0.image = UIImage(named: "rightSideArrow")?.imageFlippedForRightToLeftLayoutDirection()
            $0.contentMode = .scaleAspectFit
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        layoutDic["arrowFirstName"] = arrowFirstName
        viewFirstName.addSubview(arrowFirstName)
        
        layoutDic["arrowLastName"] = arrowLastName
        viewLastName.addSubview(arrowLastName)
        
        layoutDic["arrowEmail"] = arrowEmail
        viewEmail.addSubview(arrowEmail)
        
        arrowPhoneNumber.isHidden = true
        arrowPhoneNumber.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["arrowPhoneNumber"] = arrowPhoneNumber
        viewPhoneNumber.addSubview(arrowPhoneNumber)
        
        layoutDic["arrowSetLanguage"] = arrowSetLanguage
        viewSetLanguage.addSubview(arrowSetLanguage)
        
        layoutDic["arrowVehicle"] = arrowVehicle
        viewVehicle.addSubview(arrowVehicle)
        
       
        
        // -------------Prefference
        
        lblRecieveNotification.text = "txt_preference_title_text".localize().uppercased()
        lblRecieveNotification.textColor = .txtColor
        lblRecieveNotification.textAlignment = APIHelper.appTextAlignment
        lblRecieveNotification.font = UIFont.appRegularFont(ofSize: 14)
        lblPrefference.numberOfLines = 0
        lblPrefference.lineBreakMode = .byWordWrapping
        layoutDic["lblRecieveNotification"] = lblRecieveNotification
        lblRecieveNotification.translatesAutoresizingMaskIntoConstraints = false
        viewPrefference.addSubview(lblRecieveNotification)
        
        lblPrefferenceHint.text = "txt_preference_text_desc".localize()
        lblPrefferenceHint.textColor = .hexToColor("ACB1C0")
        lblPrefferenceHint.textAlignment = APIHelper.appTextAlignment
        lblPrefferenceHint.font = UIFont.appRegularFont(ofSize: 14)
        lblPrefferenceHint.numberOfLines = 0
        lblPrefferenceHint.lineBreakMode = .byWordWrapping
        layoutDic["lblPrefferenceHint"] = lblPrefferenceHint
        lblPrefferenceHint.translatesAutoresizingMaskIntoConstraints = false
        viewPrefference.addSubview(lblPrefferenceHint)
        
        switchPrefference.isOn = true
        switchPrefference.onTintColor = .themeColor
        layoutDic["switchPrefference"] = switchPrefference
        switchPrefference.translatesAutoresizingMaskIntoConstraints = false
        viewPrefference.addSubview(switchPrefference)
        
        lblPrefference.isHidden = true
        viewPrefference.isHidden = true
        
        // -----------------Constraints
        
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(40)]-15-[titleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        backBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleView]-10-[scrollView]", options: [], metrics: nil, views: layoutDic))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        
        scrollView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true

        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|", options: [], metrics: nil, views: layoutDic))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        containerView.widthAnchor.constraint(equalTo: baseView.widthAnchor).isActive = true
        let containerHgt = containerView.heightAnchor.constraint(equalTo: baseView.heightAnchor)
        containerHgt.priority = UILayoutPriority(rawValue: 200)
        containerHgt.isActive = true
        
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[profpicBtn(66)]-20-[lblFirstName(30)]-5-[viewFirstName]-10-[lblLastName(30)]-5-[viewLastName]-10-[lblEmail(30)]-5-[viewEmail]-10-[lblPhoneNumber(30)]-5-[viewPhoneNumber]-10-[lblSetLanguage(30)]-5-[viewSetLanguage]-10-[lblVehicle(30)]-5-[viewVehicle]-20-|", options: [], metrics: nil, views: layoutDic))//-10-[lblPrefference(30)]-5-[viewPrefference]
        
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[profpicBtn(66)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
//        nameLbl.centerYAnchor.constraint(equalTo: profpicBtn.centerYAnchor, constant: 0).isActive = true
//        nameLbl.heightAnchor.constraint(equalToConstant: 50).isActive = true
        profpicEditBtn.bottomAnchor.constraint(equalTo: profpicBtn.bottomAnchor, constant: 0).isActive = true
        profpicEditBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true
        profpicEditBtn.centerXAnchor.constraint(equalTo: profpicBtn.centerXAnchor, constant: 0).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: profpicBtn.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: profpicBtn.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        // --------FirstName
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblFirstName]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewFirstName]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewFirstName.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[txtFirstName]-10-[arrowFirstName(20)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewFirstName.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[txtFirstName(30)]-10-|", options: [], metrics: nil, views: layoutDic))
        arrowFirstName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        arrowFirstName.centerYAnchor.constraint(equalTo: txtFirstName.centerYAnchor, constant: 0).isActive = true
        
        // --------LastName
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblLastName]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewLastName]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewLastName.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[txtLastName]-10-[arrowLastName(20)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewLastName.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[txtLastName(30)]-10-|", options: [], metrics: nil, views: layoutDic))
        arrowLastName.heightAnchor.constraint(equalToConstant: 20).isActive = true
        arrowLastName.centerYAnchor.constraint(equalTo: txtLastName.centerYAnchor, constant: 0).isActive = true
        
        // --------Email
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblEmail]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewEmail]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewEmail.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[txtEmail]-10-[arrowEmail(20)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewEmail.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[txtEmail(30)]-10-|", options: [], metrics: nil, views: layoutDic))
        arrowEmail.heightAnchor.constraint(equalToConstant: 20).isActive = true
        arrowEmail.centerYAnchor.constraint(equalTo: txtEmail.centerYAnchor, constant: 0).isActive = true
        
        // --------PhoneNumber
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblPhoneNumber]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewPhoneNumber]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewPhoneNumber.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[txtPhoneNumber]-10-[arrowPhoneNumber(20)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewPhoneNumber.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[txtPhoneNumber(30)]-10-|", options: [], metrics: nil, views: layoutDic))
        arrowPhoneNumber.heightAnchor.constraint(equalToConstant: 20).isActive = true
        arrowPhoneNumber.centerYAnchor.constraint(equalTo: txtPhoneNumber.centerYAnchor, constant: 0).isActive = true
        
        // --------Set Language
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblSetLanguage]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewSetLanguage]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewSetLanguage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[txtSetLanguage]-10-[arrowSetLanguage(20)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewSetLanguage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[txtSetLanguage(30)]-10-|", options: [], metrics: nil, views: layoutDic))
        arrowSetLanguage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        arrowSetLanguage.centerYAnchor.constraint(equalTo: txtSetLanguage.centerYAnchor, constant: 0).isActive = true
        
        //--------------------View Vehicle
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblVehicle]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewVehicle]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewVehicle.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[txtVehicle]-10-[arrowVehicle(20)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewVehicle.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[txtVehicle(30)]-10-|", options: [], metrics: nil, views: layoutDic))
        arrowVehicle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        arrowVehicle.centerYAnchor.constraint(equalTo: txtVehicle.centerYAnchor, constant: 0).isActive = true
        
  
    
        
        //--------------------View Prefference
        
      //  containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblPrefference]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
      //  containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewPrefference]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        viewPrefference.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[lblRecieveNotification(50)][lblPrefferenceHint]-5-|", options: [], metrics: nil, views: layoutDic))
        

        viewPrefference.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[lblRecieveNotification]-10-[switchPrefference(52)]-10-|", options: [], metrics: nil, views: layoutDic))
        
        viewPrefference.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[lblPrefferenceHint]-10-[switchPrefference]-10-|", options: [], metrics: nil, views: layoutDic))
        
        switchPrefference.centerYAnchor.constraint(equalTo: lblRecieveNotification.centerYAnchor, constant: 0).isActive = true
        
       
    }

}
*/


class ProfileView: UIView {
    
    let backBtn = UIButton()

    let titleView = UIView()
    let titleLbl = UILabel()

    let scrollView = UIScrollView()
    let containerView = UIView()
    
    let nameLbl = UILabel()
    let profpicBtn = UIButton()
    let profpicEditBtn = UIButton()
    var activityIndicator = UIActivityIndicatorView()
    
    let lblFirstName = UILabel()
    let txtFirstName = UITextField()
    
    
    let lblLastName = UILabel()
    let txtLastName = UITextField()
    
    
    let lblEmail = UILabel()
    let txtEmail = UITextField()
    
    let lblPhoneNumber = UILabel()
    let txtPhoneNumber = UITextField()
    
    let lblSetLanguage = UILabel()
    let viewSetLanguage = UIView()
    let txtSetLanguage = UITextField()
    let arrowSetLanguage = UIImageView()
    
    let lblVehicle = UILabel()
    let viewVehicle = UIView()
    let txtVehicle = UITextField()
    let arrowVehicle = UIImageView()
    
   
    let btnSave = UIButton()
    let viewStack = UIStackView()
    let contentView = UIView()
    let imgDeleteButton = UIButton()
    let deleteButton = UIButton()
    var layoutDic = [String: AnyObject]()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        

        baseView.backgroundColor = .secondaryColor
        

        backBtn.contentMode = .scaleAspectFit
        backBtn.setAppImage("backDark")
        backBtn.layer.cornerRadius = 20
        backBtn.addShadow()
        backBtn.backgroundColor = .secondaryColor
        layoutDic["backBtn"] = backBtn
        backBtn.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(backBtn)
      
        
        titleView.backgroundColor = .secondaryColor
        titleView.layer.cornerRadius = 8
        titleView.addShadow()
        layoutDic["titleView"] = titleView
        titleView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(titleView)
        
        titleLbl.text = "text_profile".localize()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDic["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
        
        scrollView.bounces = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["scrollView"] = scrollView
        baseView.addSubview(scrollView)
        
        containerView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["containerView"] = containerView
        scrollView.addSubview(containerView)
        
        nameLbl.isHidden = true
        nameLbl.font = .appSemiBold(ofSize: 30)
        nameLbl.textColor = .txtColor
        nameLbl.textAlignment = APIHelper.appTextAlignment
        layoutDic["nameLbl"] = nameLbl
        nameLbl.translatesAutoresizingMaskIntoConstraints = false
      //  containerView.addSubview(nameLbl)
        
        profpicBtn.layer.cornerRadius = 33
        profpicBtn.layer.masksToBounds = true
        profpicBtn.setImage(UIImage(named: "profileEditPlaceHolder"), for: .normal)
        profpicBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profpicBtn"] = profpicBtn
        containerView.addSubview(profpicBtn)
        profpicEditBtn.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["profpicEditBtn"] = profpicEditBtn
        containerView.addSubview(profpicEditBtn)
        
        activityIndicator.hidesWhenStopped = true
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(activityIndicator)
        
        [lblFirstName,lblLastName,lblEmail,lblPhoneNumber,lblSetLanguage,lblVehicle].forEach({
            
            $0.font = UIFont.appRegularFont(ofSize: 14)
            $0.textColor = UIColor(red: 0.537, green: 0.573, blue: 0.639, alpha: 1)
            $0.textAlignment = APIHelper.appTextAlignment
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
            
        })
        
        lblFirstName.text = "text_firstname".localize()
        layoutDic["lblFirstName"] = lblFirstName
        lblLastName.text = "text_lastname".localize()
        layoutDic["lblLastName"] = lblLastName
        lblEmail.text = "email".localize()
        layoutDic["lblEmail"] = lblEmail
        lblPhoneNumber.text = "hint_phone_number".localize()
        layoutDic["lblPhoneNumber"] = lblPhoneNumber
        lblSetLanguage.text = "txt_set_lang".localize()
        layoutDic["lblSetLanguage"] = lblSetLanguage
        lblVehicle.text = "txt_vec_info".localize()
        layoutDic["lblVehicle"] = lblVehicle
    
      
        
        [txtFirstName,txtLastName,txtEmail,txtPhoneNumber].forEach({
            
            if $0 != txtPhoneNumber {
                $0.addBorder(edges: .bottom,colour: .txtColor)
                $0.isUserInteractionEnabled = true
            }
            
            $0.textColor = .txtColor
            $0.textAlignment = APIHelper.appTextAlignment
            $0.font = UIFont.appRegularFont(ofSize: 16)
            $0.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview($0)
        })
        
       
        layoutDic["txtFirstName"] = txtFirstName
        layoutDic["txtLastName"] = txtLastName
        txtEmail.placeholder = "text_email_plain".localize()
        layoutDic["txtEmail"] = txtEmail
        
        txtPhoneNumber.isUserInteractionEnabled = false
        layoutDic["txtPhoneNumber"] = txtPhoneNumber
    

        [viewSetLanguage,viewVehicle].forEach({
            $0.layer.cornerRadius = 5
            $0.layer.borderWidth = 1.0
            $0.layer.borderColor = UIColor.hexToColor("DADADA").cgColor
            $0.backgroundColor = UIColor(red: 0.969, green: 0.973, blue: 0.98, alpha: 0.5)
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.isUserInteractionEnabled = true
            layoutDic["\($0)"] = $0
            containerView.addSubview($0)
        })
        
        layoutDic["viewSetLanguage"] = viewSetLanguage
        layoutDic["viewVehicle"] = viewVehicle
        
        [txtSetLanguage,txtVehicle].forEach({
            $0.isUserInteractionEnabled = false
            $0.textColor = .txtColor
            $0.textAlignment = APIHelper.appTextAlignment
            $0.font = UIFont.appRegularFont(ofSize: 16)
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        
        txtSetLanguage.text = "txt_Lang".localize()
        layoutDic["txtSetLanguage"] = txtSetLanguage
        viewSetLanguage.addSubview(txtSetLanguage)
        
        
        txtVehicle.text = "txt_vec_info".localize()
        layoutDic["txtVehicle"] = txtVehicle
        viewVehicle.addSubview(txtVehicle)
        
        
        [arrowSetLanguage,arrowVehicle].forEach({
            $0.image = UIImage(named: "rightSideArrow")?.imageFlippedForRightToLeftLayoutDirection()
            $0.contentMode = .scaleAspectFit
            $0.translatesAutoresizingMaskIntoConstraints = false
        })
        
        layoutDic["arrowSetLanguage"] = arrowSetLanguage
        viewSetLanguage.addSubview(arrowSetLanguage)
        
        layoutDic["arrowVehicle"] = arrowVehicle
        viewVehicle.addSubview(arrowVehicle)
        
        btnSave.setTitle("txt_save".localize(), for: .normal)
        btnSave.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnSave.setTitleColor(.themeTxtColor, for: .normal)
        btnSave.layer.cornerRadius = 8
        btnSave.backgroundColor = .themeColor
        layoutDic["btnSave"] = btnSave
        btnSave.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(btnSave)
        
        self.viewStack.axis = .vertical
        self.viewStack.distribution = .fill
        self.viewStack.translatesAutoresizingMaskIntoConstraints = false
        self.layoutDic["viewStack"] = viewStack
        containerView.addSubview(viewStack)
        
        self.contentView.translatesAutoresizingMaskIntoConstraints = false
        self.layoutDic["contentView"] = contentView
        viewStack.addArrangedSubview(contentView)
        
        self.imgDeleteButton.setImage(UIImage(named: "ic_logout"), for: .normal)
        self.imgDeleteButton.translatesAutoresizingMaskIntoConstraints = false
        self.layoutDic["imgDeleteButton"] = imgDeleteButton
        contentView.addSubview(imgDeleteButton)
        
        self.deleteButton.setTitle("txt_delete_account", for: .normal)
        self.deleteButton.titleLabel?.font = UIFont.appMediumFont(ofSize: 18)
        self.deleteButton.setTitleColor(.themeTxtColor, for: .normal)
        self.deleteButton.translatesAutoresizingMaskIntoConstraints = false
        self.layoutDic["deleteButton"] = deleteButton
        contentView.addSubview(deleteButton)
        
     
        // -----------------Constraints
        
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(40)]-15-[titleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        backBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleView]-10-[scrollView]", options: [], metrics: nil, views: layoutDic))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        
        scrollView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true

        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[containerView]|", options: [], metrics: nil, views: layoutDic))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[containerView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        containerView.widthAnchor.constraint(equalTo: baseView.widthAnchor).isActive = true
        let containerHgt = containerView.heightAnchor.constraint(equalTo: baseView.heightAnchor)
        containerHgt.priority = UILayoutPriority(rawValue: 200)
        containerHgt.isActive = true
        
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(10)-[profpicBtn(66)]-20-[lblFirstName(25)]", options: [], metrics: nil, views: layoutDic))
        
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[lblFirstName]-1-[txtFirstName(40)]-20-[lblLastName(25)]-1-[txtLastName(40)]-20-[lblEmail(25)]-1-[txtEmail(40)]-20-[lblPhoneNumber(25)]-1-[txtPhoneNumber(40)]-20-[btnSave(45)]-20-[lblSetLanguage(25)]-5-[viewSetLanguage]-20-[lblVehicle(25)]-5-[viewVehicle]-10-[viewStack]-10-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDic))
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[viewStack]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[deleteButton]-10-|", options: [], metrics: nil, views: layoutDic))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[imgDeleteButton(20)]-10-[deleteButton]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        imgDeleteButton.heightAnchor.constraint(equalToConstant: 20).isActive = true
        imgDeleteButton.centerYAnchor.constraint(equalTo: deleteButton.centerYAnchor).isActive = true
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[profpicBtn(66)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))

        profpicEditBtn.bottomAnchor.constraint(equalTo: profpicBtn.bottomAnchor, constant: 0).isActive = true
        profpicEditBtn.heightAnchor.constraint(equalToConstant: 18).isActive = true
        profpicEditBtn.centerXAnchor.constraint(equalTo: profpicBtn.centerXAnchor, constant: 0).isActive = true
        
        activityIndicator.centerXAnchor.constraint(equalTo: profpicBtn.centerXAnchor).isActive = true
        activityIndicator.centerYAnchor.constraint(equalTo: profpicBtn.centerYAnchor).isActive = true
        activityIndicator.heightAnchor.constraint(equalToConstant: 50).isActive = true
        activityIndicator.widthAnchor.constraint(equalToConstant: 50).isActive = true
        
        
        // --------FirstName
        containerView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[lblFirstName]-30-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        
        // --------Set Language
        
       
        viewSetLanguage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[txtSetLanguage]-10-[arrowSetLanguage(20)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewSetLanguage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[txtSetLanguage(30)]-10-|", options: [], metrics: nil, views: layoutDic))
        arrowSetLanguage.heightAnchor.constraint(equalToConstant: 20).isActive = true
        arrowSetLanguage.centerYAnchor.constraint(equalTo: txtSetLanguage.centerYAnchor, constant: 0).isActive = true
        
        //--------------------View Vehicle
        
        viewVehicle.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[txtVehicle]-10-[arrowVehicle(20)]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        viewVehicle.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-10-[txtVehicle(30)]-10-|", options: [], metrics: nil, views: layoutDic))
        arrowVehicle.heightAnchor.constraint(equalToConstant: 20).isActive = true
        arrowVehicle.centerYAnchor.constraint(equalTo: txtVehicle.centerYAnchor, constant: 0).isActive = true
       
    }

}
