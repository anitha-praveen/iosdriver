//
//  InstantRidePhotoUploadView.swift
//  Roda Driver
//
//  Created by Apple on 13/07/22.
//

import UIKit

class InstantRidePhotoUploadView: UIView {

    let viewContent = UIView()
    let lblTitle = UILabel()
    let lblHint = UILabel()
    
    let viewDriverImage = UIView()
    let driverImg = UIImageView()
    let lblDriver = UILabel()
    
    let viewUserImage = UIView()
    let userImg = UIImageView()
    let lblUser = UILabel()
    
    let btnProceed = UIButton()
    
    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        
        baseView.backgroundColor = UIColor.txtColor.withAlphaComponent(0.6)
        
        viewContent.layer.cornerRadius = 20
        viewContent.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        viewContent.backgroundColor = .secondaryColor
        layoutDict["viewContent"] = viewContent
        viewContent.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewContent)
        
        lblTitle.text = "txt_snap_title".localize().uppercased()
        lblTitle.textAlignment = .center
        lblTitle.textColor = .txtColor
        lblTitle.font = UIFont.appSemiBold(ofSize: 22)
        layoutDict["lblTitle"] = lblTitle
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblTitle)
        
        lblHint.text = "txt_both_image_snap_desc".localize()
        lblHint.numberOfLines = 0
        lblHint.lineBreakMode = .byWordWrapping
        lblHint.textAlignment = .center
        lblHint.textColor = .txtColor
        lblHint.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblHint"] = lblHint
        lblHint.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblHint)
        
        layoutDict["viewDriverImage"] = viewDriverImage
        viewDriverImage.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(viewDriverImage)
        
        driverImg.image = UIImage(named: "profilePlaceHolder")
        driverImg.isUserInteractionEnabled = true
        layoutDict["driverImg"] = driverImg
        driverImg.translatesAutoresizingMaskIntoConstraints = false
        viewDriverImage.addSubview(driverImg)
        
        lblDriver.text = "txt_driver".localize()
        lblDriver.textAlignment = .center
        lblDriver.textColor = .txtColor
        lblDriver.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["lblDriver"] = lblDriver
        lblDriver.translatesAutoresizingMaskIntoConstraints = false
        viewDriverImage.addSubview(lblDriver)
        
        layoutDict["viewUserImage"] = viewUserImage
        viewUserImage.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(viewUserImage)
        
        userImg.image = UIImage(named: "profilePlaceHolder")
        userImg.isUserInteractionEnabled = true
        layoutDict["userImg"] = userImg
        userImg.translatesAutoresizingMaskIntoConstraints = false
        viewUserImage.addSubview(userImg)
        
        lblUser.text = "txt_customer".localize()
        lblUser.textAlignment = .center
        lblUser.textColor = .txtColor
        lblUser.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["lblUser"] = lblUser
        lblUser.translatesAutoresizingMaskIntoConstraints = false
        viewUserImage.addSubview(lblUser)
        
        btnProceed.setTitle("txt_proceed".localize().uppercased(), for: .normal)
        btnProceed.contentEdgeInsets = UIEdgeInsets(top: 0, left: 40, bottom: 0, right: 40)
        btnProceed.layer.cornerRadius = 8
        btnProceed.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnProceed.setTitleColor(.themeTxtColor, for: .normal)
        btnProceed.backgroundColor = .themeColor
        layoutDict["btnProceed"] = btnProceed
        btnProceed.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnProceed)
        
        
        viewContent.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[lblTitle(30)]-12-[lblHint]-15-[viewDriverImage]-25-[btnProceed(40)]-25-|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblTitle]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblHint]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[viewDriverImage]-8-[viewUserImage(==viewDriverImage)]-8-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
        btnProceed.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        
        // -----------Driver Image
      
        viewDriverImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[driverImg(90)]-8-[lblDriver(30)]-8-|", options: [], metrics: nil, views: layoutDict))
        driverImg.widthAnchor.constraint(equalToConstant: 90).isActive = true
        driverImg.centerXAnchor.constraint(equalTo: viewDriverImage.centerXAnchor, constant: 0).isActive = true
        viewDriverImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblDriver]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        // -------------User image
        viewUserImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[userImg(90)]-8-[lblUser(30)]-8-|", options: [], metrics: nil, views: layoutDict))
        userImg.widthAnchor.constraint(equalToConstant: 90).isActive = true
        userImg.centerXAnchor.constraint(equalTo: viewUserImage.centerXAnchor, constant: 0).isActive = true
        viewUserImage.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[lblUser]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
    }

}
