//
//  AppStatusView.swift
//  Roda Driver
//
//  Created by NPlus Technologies on 09/06/22.
//

import UIKit
import Starscream

class AppStatusView: UIView {

    let backBtn = UIButton()

    let titleView = UIView()
    let titleLbl = UILabel()
    
    let updatedAtLbl = UILabel()
    let datelbl = UILabel()
    let updatDiscriptLbl = UILabel()
    let updatedImgView = UIImageView()
    let networkCheckLbl = UILabel()
    let networkImgView = UIImageView()
    let nonetworklbl = UILabel()
    let gpsCheckLbl = UILabel()
    let enableGpsLbl = UILabel()
    let gpsImgView = UIImageView()
    let appStatusDiscriptLbl = UILabel()
    let appVersionLbl = UILabel()
    
    var layoutDic = [String: AnyObject]()
    
    override init(frame:CGRect) {
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
        
        titleLbl.text = "txt_app_status".localize()
        titleLbl.font = .appBoldFont(ofSize: 16)
        titleLbl.textColor = .txtColor
        titleLbl.textAlignment = APIHelper.appTextAlignment
        layoutDic["titleLbl"] = titleLbl
        titleLbl.translatesAutoresizingMaskIntoConstraints = false
        titleView.addSubview(titleLbl)
        
        
        updatedAtLbl.text = "txt_last_updated".localize() + ":"
        updatedAtLbl.textColor = .txtColor
        updatedAtLbl.textAlignment = .left
        updatedAtLbl.font = UIFont.boldSystemFont(ofSize: 20)
        updatedAtLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["updatedAtLbl"] = updatedAtLbl
        baseView.addSubview(updatedAtLbl)
    
        datelbl.textColor = .systemGray
        datelbl.textAlignment = .left
        datelbl.font = UIFont.systemFont(ofSize: 13)
        datelbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["datelbl"] = datelbl
        baseView.addSubview(datelbl)
        
        updatedImgView.contentMode = .scaleAspectFit
        updatedImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["updatedImgView"] = updatedImgView
        baseView.addSubview(updatedImgView)
        
        updatDiscriptLbl.isHidden = true
        updatDiscriptLbl.text = "txt_last_update_error".localize()
        updatDiscriptLbl.textColor = .red
        updatDiscriptLbl.textAlignment = .left
        updatDiscriptLbl.font = UIFont.systemFont(ofSize: 12)
        updatDiscriptLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["updatDiscriptLbl"] = updatDiscriptLbl
        baseView.addSubview(updatDiscriptLbl)
        
        networkCheckLbl.textColor = .txtColor
        networkCheckLbl.textAlignment = .left
        networkCheckLbl.font = UIFont.boldSystemFont(ofSize: 20)
        networkCheckLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["networkCheckLbl"] = networkCheckLbl
        baseView.addSubview(networkCheckLbl)
        
        networkImgView.contentMode = .scaleAspectFit
        networkImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["networkImgView"] = networkImgView
        baseView.addSubview(networkImgView)
        
        nonetworklbl.isHidden = true
        nonetworklbl.text = "txt_NoInternet".localize()
        nonetworklbl.textColor = .red
        nonetworklbl.textAlignment = .left
        nonetworklbl.font = UIFont.systemFont(ofSize: 12)
        nonetworklbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["nonetworklbl"] = nonetworklbl
        baseView.addSubview(nonetworklbl)
        
        gpsCheckLbl.textColor = .txtColor
        gpsCheckLbl.textAlignment = .left
        gpsCheckLbl.font = UIFont.boldSystemFont(ofSize: 20)
        gpsCheckLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["gpsCheckLbl"] = gpsCheckLbl
        baseView.addSubview(gpsCheckLbl)
        
        enableGpsLbl.isHidden = true
        enableGpsLbl.text = "txt_location_error".localize()
        enableGpsLbl.textColor = .red
        enableGpsLbl.textAlignment = .left
        enableGpsLbl.font = UIFont.systemFont(ofSize: 12)
        enableGpsLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["enableGpsLbl"] = enableGpsLbl
        baseView.addSubview(enableGpsLbl)
        
        gpsImgView.contentMode = .scaleAspectFit
        gpsImgView.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["gpsImgView"] = gpsImgView
        baseView.addSubview(gpsImgView)
    
        appStatusDiscriptLbl.textColor = .secondaryColor
        appStatusDiscriptLbl.backgroundColor = .darkGreen
        appStatusDiscriptLbl.layer.cornerRadius = 12
        appStatusDiscriptLbl.clipsToBounds = true
        appStatusDiscriptLbl.textAlignment = .center
        appStatusDiscriptLbl.font = UIFont.boldSystemFont(ofSize: 14)
        appStatusDiscriptLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["appStatusDiscriptLbl"] = appStatusDiscriptLbl
        baseView.addSubview(appStatusDiscriptLbl)
        
        
        if let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersionLbl.text = "txt_app_version".localize() + " - V \(appVersion)"
        }
        appVersionLbl.textColor = .txtColor
        appVersionLbl.textAlignment = .center
        appVersionLbl.font = UIFont.systemFont(ofSize: 15)
        appVersionLbl.translatesAutoresizingMaskIntoConstraints = false
        layoutDic["appVersionLbl"] = appVersionLbl
        baseView.addSubview(appVersionLbl)
        
        
        
        titleView.topAnchor.constraint(equalTo: baseView.safeAreaLayoutGuide.topAnchor, constant: 10).isActive = true
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-5-[titleLbl(30)]-5-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        titleView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[titleLbl]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[backBtn(40)]-15-[titleView]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        backBtn.heightAnchor.constraint(equalToConstant: 40).isActive = true
        backBtn.centerYAnchor.constraint(equalTo: titleView.centerYAnchor, constant: 0).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[titleView]-30-[updatedAtLbl(25)]-4-[updatDiscriptLbl(17)]-30-[networkCheckLbl(25)]-4-[nonetworklbl(17)]-30-[gpsCheckLbl(25)]-4-[enableGpsLbl(17)]-30-[appStatusDiscriptLbl(35)]", options: [], metrics: nil, views: layoutDic))
        
     
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[updatedAtLbl(>=130)]-5-[datelbl]-[updatedImgView(25)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        datelbl.centerYAnchor.constraint(equalTo: updatedAtLbl.centerYAnchor).isActive = true
        datelbl.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[updatDiscriptLbl]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        updatedImgView.centerYAnchor.constraint(equalTo: updatedAtLbl.centerYAnchor).isActive = true
        updatedImgView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[networkCheckLbl(>=130)]-[networkImgView(25)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        networkImgView.centerYAnchor.constraint(equalTo: networkCheckLbl.centerYAnchor).isActive = true
        networkImgView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[nonetworklbl]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[gpsCheckLbl(>=130)]-[gpsImgView(25)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        gpsImgView.centerYAnchor.constraint(equalTo: gpsCheckLbl.centerYAnchor).isActive = true
        gpsImgView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-12-[enableGpsLbl]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[appStatusDiscriptLbl]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
    
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[appVersionLbl]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDic))
        
        appVersionLbl.bottomAnchor.constraint(equalTo: baseView.bottomAnchor, constant: -20).isActive = true
        
        
    }
    
}
