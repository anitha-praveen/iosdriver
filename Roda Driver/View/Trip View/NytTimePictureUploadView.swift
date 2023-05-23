//
//  NytTimePictureUploadView.swift
//  Roda Driver
//
//  Created by Apple on 01/07/22.
//

import UIKit

class NytTimePictureUploadView: UIView {
    
    let viewContent = UIView()
    let lblTitle = UILabel()
    let lblHint = UILabel()
    let btnProceed = UIButton()
    
    let waitingView = UIView()
    let lblWait = UILabel()
    let imgview = UIImageView()
    let btnSkip = UIButton()
    let btnCancelTrip = UIButton()
    
    let btnRetake = UIButton()
    let btnConfirmPassenger = UIButton()
    
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
        
        lblTitle.text = "txt_snap_title".localize()
        lblTitle.textAlignment = APIHelper.appTextAlignment
        lblTitle.textColor = .txtColor
        lblTitle.font = UIFont.appSemiBold(ofSize: 18)
        layoutDict["lblTitle"] = lblTitle
        lblTitle.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblTitle)
        
        lblHint.text = "txt_snap_description".localize()
        lblHint.numberOfLines = 0
        lblHint.lineBreakMode = .byWordWrapping
        lblHint.textAlignment = APIHelper.appTextAlignment
        lblHint.textColor = .txtColor
        lblHint.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblHint"] = lblHint
        lblHint.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(lblHint)
        
        btnProceed.setTitle("txt_proceed".localize(), for: .normal)
        btnProceed.contentEdgeInsets = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        btnProceed.layer.cornerRadius = 8
        btnProceed.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnProceed.setTitleColor(.themeTxtColor, for: .normal)
        btnProceed.backgroundColor = .themeColor
        layoutDict["btnProceed"] = btnProceed
        btnProceed.translatesAutoresizingMaskIntoConstraints = false
        viewContent.addSubview(btnProceed)
        
        
        // -------------Waiting View
        
        waitingView.layer.cornerRadius = 20
        waitingView.layer.maskedCorners = [.layerMinXMinYCorner,.layerMaxXMinYCorner]
        waitingView.backgroundColor = .secondaryColor
        layoutDict["waitingView"] = waitingView
        waitingView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(waitingView)
        
        lblWait.text = "txt_user_photo_deny".localize()
        lblWait.numberOfLines = 0
        lblWait.lineBreakMode = .byWordWrapping
        lblWait.textAlignment = .center
        lblWait.textColor = .txtColor
        lblWait.font = UIFont.appRegularFont(ofSize: 15)
        layoutDict["lblWait"] = lblWait
        lblWait.translatesAutoresizingMaskIntoConstraints = false
        waitingView.addSubview(lblWait)
        
        imgview.image = UIImage(named: "profilePlaceHolder")
        imgview.contentMode = .scaleAspectFit
        layoutDict["imgview"] = imgview
        imgview.translatesAutoresizingMaskIntoConstraints = false
        waitingView.addSubview(imgview)
        
        btnCancelTrip.setTitle("txt_cancel_trip".localize(), for: .normal)
        btnCancelTrip.layer.cornerRadius = 8
        btnCancelTrip.layer.borderColor = UIColor.themeColor.cgColor
        btnCancelTrip.layer.borderWidth = 1.0
        btnCancelTrip.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnCancelTrip.setTitleColor(.txtColor, for: .normal)
        btnCancelTrip.backgroundColor = .secondaryColor
        layoutDict["btnCancelTrip"] = btnCancelTrip
        btnCancelTrip.translatesAutoresizingMaskIntoConstraints = false
        waitingView.addSubview(btnCancelTrip)
        
        btnSkip.setTitle("txt_skip".localize(), for: .normal)
        btnSkip.layer.cornerRadius = 8
        btnSkip.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnSkip.setTitleColor(.themeTxtColor, for: .normal)
        btnSkip.backgroundColor = .themeColor
        layoutDict["btnSkip"] = btnSkip
        btnSkip.translatesAutoresizingMaskIntoConstraints = false
        waitingView.addSubview(btnSkip)
        
        btnRetake.isHidden = true
        btnRetake.setTitle("txt_retake".localize(), for: .normal)
        btnRetake.layer.cornerRadius = 8
        btnRetake.layer.borderColor = UIColor.themeColor.cgColor
        btnRetake.layer.borderWidth = 1.0
        btnRetake.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnRetake.setTitleColor(.txtColor, for: .normal)
        btnRetake.backgroundColor = .secondaryColor
        layoutDict["btnRetake"] = btnRetake
        btnRetake.translatesAutoresizingMaskIntoConstraints = false
        waitingView.addSubview(btnRetake)
        
        btnConfirmPassenger.isHidden = true
        btnConfirmPassenger.setTitle("txt_confirm".localize(), for: .normal)
        btnConfirmPassenger.layer.cornerRadius = 8
        btnConfirmPassenger.titleLabel?.font = UIFont.appSemiBold(ofSize: 16)
        btnConfirmPassenger.setTitleColor(.themeTxtColor, for: .normal)
        btnConfirmPassenger.backgroundColor = .themeColor
        layoutDict["btnConfirmPassenger"] = btnConfirmPassenger
        btnConfirmPassenger.translatesAutoresizingMaskIntoConstraints = false
        waitingView.addSubview(btnConfirmPassenger)
        
        
        // -------------------
        
        viewContent.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[viewContent]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[lblTitle(30)]-12-[lblHint]-25-[btnProceed(40)]-25-|", options: [], metrics: nil, views: layoutDict))
        
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblTitle]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        viewContent.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblHint]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        btnProceed.centerXAnchor.constraint(equalTo: viewContent.centerXAnchor, constant: 0).isActive = true
        
        // -------------------
        
        waitingView.bottomAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[waitingView]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        
        waitingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-15-[lblWait]-12-[imgview(80)]-25-[btnSkip(40)]-25-|", options: [], metrics: nil, views: layoutDict))
        
        
        waitingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[lblWait]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        imgview.widthAnchor.constraint(equalToConstant: 80).isActive = true
        imgview.centerXAnchor.constraint(equalTo: waitingView.centerXAnchor, constant: 0).isActive = true
        
        waitingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnCancelTrip]-8-[btnSkip(==btnCancelTrip)]-16-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
       
        waitingView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[btnRetake]-8-[btnConfirmPassenger(==btnRetake)]-16-|", options: [APIHelper.appLanguageDirection,.alignAllTop,.alignAllBottom], metrics: nil, views: layoutDict))
        
        btnConfirmPassenger.topAnchor.constraint(equalTo: btnSkip.topAnchor, constant: 0).isActive = true
        btnConfirmPassenger.bottomAnchor.constraint(equalTo: btnSkip.bottomAnchor, constant: 0).isActive = true
        
    }

}
