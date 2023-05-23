//
//  RegisterUserDetailsView.swift
//  Taxiappz Driver
//
//  Created by spextrum on 22/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit

class RegisterUserDetailsView: UIView {

    let scrollView = UIScrollView()
    let contentView = UIView()
    let btnBack = UIButton()
    let registrationLbl = UILabel()
    let firstNameTxtField = UITextField()
    let alrtEnterNameLbl = UILabel()
    let lastNameTxtField = UITextField()
    let alrtLstNameLbl = UILabel()
    let emailIDTxtField = UITextField()
    let alrtEmailIDLbl = UILabel()
    let countryCodeLbl = UILabel()
    let alrtCountryCodeLbl = UILabel()
    let selectedCountryFlag = UIImageView()
    let selectedCountryLbl = UILabel()
    let mobileNumberTxtField = UITextField()
    let alrtMobileNumberLbl = UILabel()
   
    let areaTxtField = RJKPickerTextField()
    let alrtSelectAreaLbl = UILabel()
    let btnAreaArrow = UIButton()
    
    let txtReferralCode = UITextField()
    
    let viewCategory = UIView()
    let lblCategoryTitle = UILabel()
    let btnIndividual = UIButton()
    let btnCompany = UIButton()
    
    let companyStackvw = UIStackView()
    let chooseCompanyTxtField = UITextField()
//    let alrtChooseCompanyLbl = UILabel()
    let companyNameTxtField = UITextField()
//    let alrtCompanyNameLbl = UILabel()
    let companyPhoneNumTxtField = UITextField()
//    let alrtCompanyPhoneNumLbl = UILabel()
    let companyVehicleCountTxtField = UITextField()
//    let alrtCompanyVehicleCountLbl = UILabel()
    
    let btnNext = UIButton()

    var layoutDict = [String:AnyObject]()

    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        baseView.backgroundColor = .secondaryColor

        scrollView.bounces = false
        scrollView.backgroundColor = .secondaryColor
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["scrollView"] = scrollView
        baseView.addSubview(scrollView)

        contentView.backgroundColor = .secondaryColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["contentView"] = contentView
        scrollView.addSubview(contentView)
        
        btnBack.setAppImage("BackImage")
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnBack"] = btnBack
        contentView.addSubview(btnBack)
        
        registrationLbl.text = "txt_sign_up".localize()
        registrationLbl.font = .appSemiBold(ofSize: 40)
        registrationLbl.textColor = .hexToColor("222B45")
        registrationLbl.textAlignment = APIHelper.appTextAlignment
        registrationLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["registrationLbl"] = registrationLbl
        contentView.addSubview(registrationLbl)
        
        let viewName = UIView()
        viewName.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewName"] = viewName
        contentView.addSubview(viewName)
        
        firstNameTxtField.returnKeyType = .next
        firstNameTxtField.addDropDown(text: "text_firstname".localize(),image:"")
        firstNameTxtField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["firstNameTxtField"] = firstNameTxtField
        viewName.addSubview(firstNameTxtField)
    
        alrtEnterNameLbl.isHidden = true
        alrtEnterNameLbl.text = "txt_first_name_hint".localize()
        alrtEnterNameLbl.textColor = .systemRed
        alrtEnterNameLbl.textAlignment = .left
        alrtEnterNameLbl.font = UIFont.systemFont(ofSize: 10)
        alrtEnterNameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["alrtEnterNameLbl"] = alrtEnterNameLbl
        viewName.addSubview(alrtEnterNameLbl)
        
        lastNameTxtField.returnKeyType = .next
        lastNameTxtField.addDropDown(text: "text_lastname".localize(), image: "")
        lastNameTxtField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lastNameTxtField"] = lastNameTxtField
        viewName.addSubview(lastNameTxtField)
        
        alrtLstNameLbl.isHidden = true
        alrtLstNameLbl.text = "txt_last_name_hint".localize()
        alrtLstNameLbl.textColor = .systemRed
        alrtLstNameLbl.textAlignment = .left
        alrtLstNameLbl.font = UIFont.systemFont(ofSize: 10)
        alrtLstNameLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["alrtLstNameLbl"] = alrtLstNameLbl
        viewName.addSubview(alrtLstNameLbl)

        emailIDTxtField.returnKeyType = .next
        emailIDTxtField.keyboardType = .emailAddress
        emailIDTxtField.addDropDown(text: "email".localize(), image: "")
        emailIDTxtField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["emailIDTxtField"] = emailIDTxtField
        contentView.addSubview(emailIDTxtField)
        
        alrtEmailIDLbl.isHidden = true
        alrtEmailIDLbl.text = "txt_enter_valid_email".localize()
        alrtEmailIDLbl.textColor = .systemRed
        alrtEmailIDLbl.textAlignment = .left
        alrtEmailIDLbl.font = UIFont.systemFont(ofSize: 10)
        alrtEmailIDLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["alrtEmailIDLbl"] = alrtEmailIDLbl
        contentView.addSubview(alrtEmailIDLbl)
        
        countryCodeLbl.text = "txt_country_code".localize().uppercased()
        countryCodeLbl.textAlignment = .left
        countryCodeLbl.textColor = .hexToColor("8992A3")
        countryCodeLbl.font = .appSemiBold(ofSize: 12)
        countryCodeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["countryCodeLbl"] = countryCodeLbl
        contentView.addSubview(countryCodeLbl)
        
        let viewPhone = UIView()
        viewPhone.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewPhone"] = viewPhone
        contentView.addSubview(viewPhone)
        
        let viewCode = UIView()
        viewCode.layer.cornerRadius = 4
        viewCode.layer.borderColor = UIColor.hexToColor("E4E9F2").cgColor
        viewCode.layer.borderWidth = 1
        viewCode.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewCode"] = viewCode
        viewPhone.addSubview(viewCode)
        
        selectedCountryLbl.contentMode = .scaleAspectFill
        selectedCountryFlag.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["selectedCountryFlag"] = selectedCountryFlag
        viewCode.addSubview(selectedCountryFlag)

        selectedCountryLbl.textAlignment = .center
        selectedCountryLbl.textColor = .txtColor
        selectedCountryLbl.font = .appSemiBold(ofSize: 15)
        selectedCountryLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["selectedCountryLbl"] = selectedCountryLbl
        viewCode.addSubview(selectedCountryLbl)
        
        let imgCountryArrow = UIImageView()
        imgCountryArrow.image = UIImage(named: "downarrow")
        imgCountryArrow.contentMode = .scaleAspectFit
        imgCountryArrow.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["imgCountryArrow"] = imgCountryArrow
        viewCode.addSubview(imgCountryArrow)
        
        alrtCountryCodeLbl.isHidden = true
        alrtCountryCodeLbl.text = "txt_enter_country_code".localize()
        alrtCountryCodeLbl.textColor = .systemRed
        alrtCountryCodeLbl.textAlignment = .left
        alrtCountryCodeLbl.font = UIFont.systemFont(ofSize: 10)
        alrtCountryCodeLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["alrtCountryCodeLbl"] = alrtCountryCodeLbl
        viewPhone.addSubview(alrtCountryCodeLbl)
        
        mobileNumberTxtField.isEnabled = false
        mobileNumberTxtField.addDropDown(text: "hint_phone_number".localize(), image: "")
        mobileNumberTxtField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["mobileNumberTxtField"] = mobileNumberTxtField
        viewPhone.addSubview(mobileNumberTxtField)
        
        alrtMobileNumberLbl.isHidden = true
        alrtMobileNumberLbl.text = "txt_enter_mobile_number".localize()
        alrtMobileNumberLbl.textColor = .systemRed
        alrtMobileNumberLbl.textAlignment = .left
        alrtMobileNumberLbl.font = UIFont.systemFont(ofSize: 10)
        alrtMobileNumberLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["alrtMobileNumberLbl"] = alrtMobileNumberLbl
        viewPhone.addSubview(alrtMobileNumberLbl)

        areaTxtField.addDropDown(text: "txt_area_location".localize(), image: "filled_down_arrow")
        areaTxtField.changeTextFieldType(.pickerView)
        areaTxtField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["areaTxtField"] = areaTxtField
        contentView.addSubview(areaTxtField)
        
        alrtSelectAreaLbl.isHidden = true
        alrtSelectAreaLbl.text = "txt_select_area".localize()
        alrtSelectAreaLbl.textColor = .systemRed
        alrtSelectAreaLbl.textAlignment = .left
        alrtSelectAreaLbl.font = UIFont.systemFont(ofSize: 10)
        alrtSelectAreaLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["alrtSelectAreaLbl"] = alrtSelectAreaLbl
        contentView.addSubview(alrtSelectAreaLbl)
        
        txtReferralCode.returnKeyType = .done
        txtReferralCode.addDropDown(text: "refferal_code".localize(), image: "")
        txtReferralCode.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["txtReferralCode"] = txtReferralCode
        contentView.addSubview(txtReferralCode)
        
        viewCategory.isHidden = true
        viewCategory.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["viewCategory"] = viewCategory
        contentView.addSubview(viewCategory)
        
        lblCategoryTitle.text = "txt_category".localize()
        lblCategoryTitle.font = UIFont.appFont(ofSize: 14)
        lblCategoryTitle.textAlignment = APIHelper.appTextAlignment
        lblCategoryTitle.textColor = .gray
        lblCategoryTitle.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["lblCategoryTitle"] = lblCategoryTitle
        viewCategory.addSubview(lblCategoryTitle)

        btnIndividual.isSelected = true
        btnIndividual.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        btnIndividual.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        btnIndividual.setImage(UIImage(named: "ic_check"), for: .selected)
        btnIndividual.setTitle("txt_type_individual".localize(), for: .normal)
        btnIndividual.setTitleColor(.txtColor, for: .normal)
        btnIndividual.titleLabel?.font = UIFont.appRegularFont(ofSize: 18)
        btnIndividual.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnIndividual"] = btnIndividual
        viewCategory.addSubview(btnIndividual)
        
        btnCompany.isSelected = false
        btnCompany.titleEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 0)
        btnCompany.setImage(UIImage(named: "ic_uncheck"), for: .normal)
        btnCompany.setImage(UIImage(named: "ic_check"), for: .selected)
        btnCompany.setTitle("txt_type_company".localize(), for: .normal)
        btnCompany.setTitleColor(.txtColor, for: .normal)
        btnCompany.titleLabel?.font = UIFont.appRegularFont(ofSize: 18)
        btnCompany.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnCompany"] = btnCompany
        viewCategory.addSubview(btnCompany)
        
        companyStackvw.axis = .vertical
        companyStackvw.spacing = 20
        companyStackvw.distribution = .fill
        companyStackvw.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["companyStackvw"] = companyStackvw
        contentView.addSubview(companyStackvw)
        
        chooseCompanyTxtField.isHidden = true
        chooseCompanyTxtField.addDropDown(text: "txt_choose_company".localize(), image: "filled_down_arrow")
        chooseCompanyTxtField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["companyStackvw"] = companyStackvw
        companyStackvw.addArrangedSubview(chooseCompanyTxtField)
        
//        alrtChooseCompanyLbl.text = "Choose Company"
//        alrtChooseCompanyLbl.textColor = .systemRed
//        alrtChooseCompanyLbl.textAlignment = .left
//        alrtChooseCompanyLbl.font = UIFont.systemFont(ofSize: 10)
//        alrtChooseCompanyLbl.translatesAutoresizingMaskIntoConstraints = false
//        layoutDict["alrtChooseCompanyLbl"] = alrtChooseCompanyLbl
//        companyStackvw.addArrangedSubview(alrtChooseCompanyLbl)
        
        companyNameTxtField.isHidden = true
        companyNameTxtField.addDropDown(text: "txt_company_name".localize(), image: "")
        companyNameTxtField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["companyNameTxtField"] = companyNameTxtField
        companyStackvw.addArrangedSubview(companyNameTxtField)
        
//        alrtCompanyNameLbl.isHidden = true
//        alrtCompanyNameLbl.text = "Enter Company Name"
//        alrtCompanyNameLbl.textColor = .systemRed
//        alrtCompanyNameLbl.textAlignment = .left
//        alrtCompanyNameLbl.font = UIFont.systemFont(ofSize: 10)
//        alrtCompanyNameLbl.translatesAutoresizingMaskIntoConstraints = false
//        layoutDict["alrtCompanyNameLbl"] = alrtCompanyNameLbl
//        companyStackvw.addArrangedSubview(alrtCompanyNameLbl)
        
        companyPhoneNumTxtField.isHidden = true
        companyPhoneNumTxtField.keyboardType = .phonePad
        companyPhoneNumTxtField.addDropDown(text: "txt_company_phone".localize(), image: "")
        companyPhoneNumTxtField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["companyPhoneNumTxtField"] = companyPhoneNumTxtField
        companyStackvw.addArrangedSubview(companyPhoneNumTxtField)
        
//        alrtCompanyPhoneNumLbl.isHidden = true
//        alrtCompanyPhoneNumLbl.text = "Enter Company Phone Number"
//        alrtCompanyPhoneNumLbl.textColor = .systemRed
//        alrtCompanyPhoneNumLbl.textAlignment = .left
//        alrtCompanyPhoneNumLbl.font = UIFont.systemFont(ofSize: 10)
//        alrtCompanyPhoneNumLbl.translatesAutoresizingMaskIntoConstraints = false
//        layoutDict["alrtCompanyPhoneNumLbl"] = alrtCompanyPhoneNumLbl
//        companyStackvw.addArrangedSubview(alrtCompanyPhoneNumLbl)
        
        companyVehicleCountTxtField.isHidden = true
        companyVehicleCountTxtField.keyboardType = .numberPad
        companyVehicleCountTxtField.addDropDown(text: "txt_number_of_vehicles".localize(), image: "")
        companyVehicleCountTxtField.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["companyVehicleCountTxtField"] = companyVehicleCountTxtField
        companyStackvw.addArrangedSubview(companyVehicleCountTxtField)
        
//        alrtCompanyVehicleCountLbl.isHidden = true
//        alrtCompanyVehicleCountLbl.text = "Enter Company Vehicle Count"
//        alrtCompanyVehicleCountLbl.textColor = .systemRed
//        alrtCompanyVehicleCountLbl.textAlignment = .left
//        alrtCompanyVehicleCountLbl.font = UIFont.systemFont(ofSize: 10)
//        alrtCompanyVehicleCountLbl.translatesAutoresizingMaskIntoConstraints = false
//        layoutDict["alrtCompanyVehicleCountLbl"] = alrtCompanyVehicleCountLbl
//        companyStackvw.addArrangedSubview(alrtCompanyVehicleCountLbl)
        
        btnNext.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        btnNext.setTitle("txt_next".localize().uppercased(), for: .normal)
        btnNext.titleLabel!.font = .appSemiBold(ofSize: 18)
        btnNext.setTitleColor(.secondaryColor, for: .normal)
        btnNext.backgroundColor = .themeColor
        btnNext.layer.cornerRadius = 4
        btnNext.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["btnNext"] = btnNext
        contentView.addSubview(btnNext)
        
        

        scrollView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor).isActive = true

        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[scrollView]|", options: [], metrics: nil, views: layoutDict))
        
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[contentView]|", options: [], metrics: nil, views: layoutDict))
        scrollView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[contentView]|", options: [], metrics: nil, views: layoutDict))
        contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        let height = contentView.heightAnchor.constraint(equalTo: scrollView.heightAnchor)
        height.priority = .defaultLow
        height.isActive = true
        
        btnBack.widthAnchor.constraint(equalToConstant: 30).isActive = true
        btnBack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12).isActive = true
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[btnBack(30)]-15-[registrationLbl]-15-[viewName]-15-[emailIDTxtField(48)]-5-[alrtEmailIDLbl]-20-[countryCodeLbl]-5-[viewPhone]-18-[areaTxtField(48)]-5-[alrtSelectAreaLbl]-20-[txtReferralCode(48)]-10-[companyStackvw]-20-[btnNext(48)]-20-|", options: [], metrics: nil, views: layoutDict))
        
//        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[btnBack(30)]-15-[registrationLbl]-15-[viewName]-15-[emailIDTxtField(48)]-5-[alrtEmailIDLbl]-20-[countryCodeLbl]-5-[viewPhone]-18-[areaTxtField(48)]-5-[alrtSelectAreaLbl]-20-[txtReferralCode(48)]-20-[viewCategory]-10-[companyStackvw]-20-[btnNext(48)]-20-|", options: [], metrics: nil, views: layoutDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[registrationLbl]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewName]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewName.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[firstNameTxtField(48)]-5-[alrtEnterNameLbl]|", options: [], metrics: nil, views: layoutDict))
        viewName.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lastNameTxtField(48)]-5-[alrtLstNameLbl]-|", options: [], metrics: nil, views: layoutDict))
        viewName.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[firstNameTxtField(==lastNameTxtField)]-16-[lastNameTxtField]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        alrtEnterNameLbl.widthAnchor.constraint(equalTo: firstNameTxtField.widthAnchor,constant: -4).isActive = true
        alrtEnterNameLbl.centerXAnchor.constraint(equalTo: firstNameTxtField.centerXAnchor, constant: 4).isActive = true
        
        alrtLstNameLbl.widthAnchor.constraint(equalTo: lastNameTxtField.widthAnchor,constant: -4).isActive = true
        alrtLstNameLbl.centerXAnchor.constraint(equalTo: lastNameTxtField.centerXAnchor, constant: 4).isActive = true

        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[emailIDTxtField]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[alrtEmailIDLbl]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewPhone]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[countryCodeLbl]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewPhone.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[viewCode(48)]-5-[alrtCountryCodeLbl]|", options: [], metrics: nil, views: layoutDict))
        viewPhone.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mobileNumberTxtField(48)]-5-[alrtMobileNumberLbl]|", options: [], metrics: nil, views: layoutDict))
        viewPhone.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewCode(114)]-16-[mobileNumberTxtField]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        alrtCountryCodeLbl.widthAnchor.constraint(equalTo: viewCode.widthAnchor, constant: -4).isActive = true
        alrtCountryCodeLbl.centerXAnchor.constraint(equalTo: viewCode.centerXAnchor, constant: 4).isActive = true
        alrtMobileNumberLbl.widthAnchor.constraint(equalTo: mobileNumberTxtField.widthAnchor, constant: -4).isActive = true
        alrtMobileNumberLbl.centerXAnchor.constraint(equalTo: mobileNumberTxtField.centerXAnchor, constant: 4).isActive = true
        
        viewCode.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-[selectedCountryFlag(20)]-[selectedCountryLbl]-[imgCountryArrow(14)]-|", options: [APIHelper.appLanguageDirection, .alignAllTop, .alignAllBottom], metrics: nil, views: layoutDict))
        selectedCountryFlag.heightAnchor.constraint(equalToConstant: 15).isActive = true
        selectedCountryFlag.centerYAnchor.constraint(equalTo: viewCode.centerYAnchor).isActive = true
        selectedCountryLbl.centerYAnchor.constraint(equalTo: viewCode.centerYAnchor).isActive = true
        imgCountryArrow.centerYAnchor.constraint(equalTo: viewCode.centerYAnchor).isActive = true
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[areaTxtField]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[alrtSelectAreaLbl]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[txtReferralCode]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[companyStackvw]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
//        contentView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewCategory]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewCategory.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[lblCategoryTitle(30)]-8-[btnIndividual(40)]-5-|", options: [], metrics: nil, views: layoutDict))
        viewCategory.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblCategoryTitle]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewCategory.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[btnIndividual(130)]-30-[btnCompany(130)]", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
        chooseCompanyTxtField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        companyNameTxtField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        companyPhoneNumTxtField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        companyVehicleCountTxtField.heightAnchor.constraint(equalToConstant: 45).isActive = true
      
        
        btnNext.widthAnchor.constraint(equalToConstant: 150).isActive = true
        btnNext.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true

        contentView.layoutIfNeeded()
        contentView.setNeedsLayout()

    }
}
