//
//  InstantTripView.swift
//  Roda Driver
//
//  Created by NPlus Technologies on 06/05/22.
//

import UIKit
import GoogleMaps
import GooglePlaces

class InstantTripView: UIView {

    var mapview = GMSMapView()
    let btnBack = UIButton()

    let viewAddress = UIView()
    let pickupView = UIView()
    let imgPickup = UIImageView()
    let pickupLabel = UILabel()
    let txtPickup = UITextField()
    
    let dropView = UIView()
    let imgDrop = UIImageView()
    let dropLabel = UILabel()
    let txtDrop = UITextField()
    
    let markerImageView = UIImageView()

    let btnSateliteMapType = UIButton()
    let btnNormalMapType = UIButton()
    let currentLocationBtn = UIButton()
    let btnStartTrip = UIButton()
    
    let activityView = UIActivityIndicatorView(style: .gray)

    var layoutDict = [String: AnyObject]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupViews(Base baseView: UIView) {
        baseView.backgroundColor = .secondaryColor
        
        mapview.padding = UIEdgeInsets(top: 50, left: 0, bottom: 50, right: 0)
        mapview.isTrafficEnabled = true
        mapview.settings.compassButton = false
        mapview.isMyLocationEnabled = true
//        mapview.settings.myLocationButton = true
        mapview.isBuildingsEnabled = true
        mapview.isIndoorEnabled = true
        layoutDict["mapview"] = mapview
        mapview.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(mapview)
        
        if let styleURL = Bundle.main.url(forResource: "mapStyle", withExtension: "json") {
            self.mapview.mapStyle = try? GMSMapStyle(contentsOfFileURL: styleURL)
        }
        
        btnBack.imageView?.tintColor = .secondaryColor
        btnBack.setImage(UIImage(named: "BackImage")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnBack.layer.cornerRadius = 20
        btnBack.clipsToBounds = true
        btnBack.backgroundColor = .themeColor
        layoutDict["btnBack"] = btnBack
        btnBack.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnBack)
        
        viewAddress.layer.cornerRadius = 20
        viewAddress.backgroundColor = .secondaryColor
        layoutDict["viewAddress"] = viewAddress
        viewAddress.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(viewAddress)
        
//        pickupView.isUserInteractionEnabled = true
        pickupView.layer.cornerRadius = 5
        pickupView.backgroundColor = .clear
        layoutDict["pickupView"] = pickupView
        pickupView.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(pickupView)
        
        imgPickup.contentMode = .scaleAspectFit
        imgPickup.image = UIImage(named: "pickpin")
        layoutDict["imgPickup"] = imgPickup
        imgPickup.translatesAutoresizingMaskIntoConstraints = false
        pickupView.addSubview(imgPickup)
        
        pickupLabel.text = "txt_pickup_from".localize()
        pickupLabel.textColor = .gray
        pickupLabel.textAlignment = .left
        pickupLabel.font = UIFont.systemFont(ofSize: 14)
        layoutDict["pickupLabel"] = pickupLabel
        pickupLabel.translatesAutoresizingMaskIntoConstraints = false
        pickupView.addSubview(pickupLabel)
        
        txtPickup.isUserInteractionEnabled = false
        txtPickup.placeholder = "txt_pickup_from".localize()
        txtPickup.textAlignment = APIHelper.appTextAlignment
        txtPickup.textColor = .regTxtColor
        txtPickup.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["txtPickup"] = txtPickup
        txtPickup.translatesAutoresizingMaskIntoConstraints = false
        pickupView.addSubview(txtPickup)
        
        dropView.isUserInteractionEnabled = true
        dropView.layer.cornerRadius = 5
        dropView.backgroundColor = .secondaryColor
        layoutDict["dropView"] = dropView
        dropView.translatesAutoresizingMaskIntoConstraints = false
        viewAddress.addSubview(dropView)
        
        imgDrop.contentMode = .scaleAspectFit
        imgDrop.image = UIImage(named: "droppin")
        layoutDict["imgDrop"] = imgDrop
        imgDrop.translatesAutoresizingMaskIntoConstraints = false
        dropView.addSubview(imgDrop)
        
        dropLabel.text = "txt_drop_at_optional".localize()
        dropLabel.textColor = .gray
        dropLabel.textAlignment = .left
        dropLabel.font = UIFont.systemFont(ofSize: 14)
        layoutDict["dropLabel"] = dropLabel
        dropLabel.translatesAutoresizingMaskIntoConstraints = false
        dropView.addSubview(dropLabel)
        
        txtDrop.isUserInteractionEnabled = false
        txtDrop.placeholder = "txt_where_like_go".localize()
        txtDrop.textAlignment = APIHelper.appTextAlignment
        txtDrop.textColor = .regTxtColor
        txtDrop.font = UIFont.appRegularFont(ofSize: 16)
        layoutDict["txtDrop"] = txtDrop
        txtDrop.translatesAutoresizingMaskIntoConstraints = false
        dropView.addSubview(txtDrop)
        
        markerImageView.image = UIImage(named: "droppin")
        markerImageView.contentMode = .scaleAspectFit
        layoutDict["markerImageView"] = markerImageView
        markerImageView.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(markerImageView)
        
        btnSateliteMapType.tintColor = .themeColor
        btnSateliteMapType.setImage(UIImage(named: "ic_trip_satellite")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnSateliteMapType.imageView?.contentMode = .scaleAspectFit
        btnSateliteMapType.translatesAutoresizingMaskIntoConstraints = false
        btnSateliteMapType.backgroundColor = .secondaryColor
        btnSateliteMapType.layer.cornerRadius = 25
        btnSateliteMapType.addShadow()
        layoutDict["btnSateliteMapType"] = btnSateliteMapType
        baseView.addSubview(btnSateliteMapType)
        
        btnNormalMapType.tintColor = .themeColor
        btnNormalMapType.setImage(UIImage(named: "mapNormal")?.withRenderingMode(.alwaysTemplate), for: .normal)
        btnNormalMapType.translatesAutoresizingMaskIntoConstraints = false
        btnNormalMapType.imageView?.contentMode = .scaleAspectFit
        btnNormalMapType.backgroundColor = .secondaryColor
        btnNormalMapType.layer.cornerRadius = 25
        btnNormalMapType.addShadow()
        layoutDict["btnNormalMapType"] = btnNormalMapType
        baseView.addSubview(btnNormalMapType)
        
        currentLocationBtn.tintColor = .themeColor
        currentLocationBtn.setImage(UIImage(named: "currentLocation")?.withRenderingMode(.alwaysTemplate), for: .normal)
        currentLocationBtn.translatesAutoresizingMaskIntoConstraints = false
        currentLocationBtn.imageView?.contentMode = .scaleAspectFit
        currentLocationBtn.backgroundColor = .secondaryColor
        currentLocationBtn.layer.cornerRadius = 25
        currentLocationBtn.addShadow()
        layoutDict["currentLocationBtn"] = currentLocationBtn
        baseView.addSubview(currentLocationBtn)
        
        btnStartTrip.setTitle("txt_confirm".localize(), for: .normal)
        btnStartTrip.setTitleColor(.secondaryColor, for: .normal)
        btnStartTrip.backgroundColor = .themeColor
        btnStartTrip.layer.cornerRadius = 10
        layoutDict["btnStartTrip"] = btnStartTrip
        btnStartTrip.translatesAutoresizingMaskIntoConstraints = false
        baseView.addSubview(btnStartTrip)
        
        activityView.color = .txtColor
        activityView.translatesAutoresizingMaskIntoConstraints = false
        layoutDict["activityView"] = activityView
        baseView.addSubview(activityView)
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[mapview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[mapview]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[btnBack(40)]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[btnBack(40)]-15-[viewAddress]", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-16-[viewAddress]-16-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        // -----------address
        
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-12-[pickupView]-5-[dropView]-12-|", options: [.alignAllLeading,.alignAllTrailing], metrics: nil, views: layoutDict))
        viewAddress.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-10-[pickupView]-10-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        
        pickupView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[imgPickup(30)]-10-[txtPickup]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        pickupView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[imgPickup(30)]-10-[pickupLabel]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        pickupView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[pickupLabel(20)]-5-[txtPickup(20)]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        imgPickup.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imgPickup.centerYAnchor.constraint(equalTo: txtPickup.centerYAnchor, constant: -17).isActive = true
        
        dropView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[imgDrop(30)]-10-[txtDrop]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        dropView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[imgDrop(30)]-10-[dropLabel]|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        dropView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-8-[dropLabel(20)]-5-[txtDrop(20)]-8-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        imgDrop.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imgDrop.centerYAnchor.constraint(equalTo: txtDrop.centerYAnchor, constant: -17).isActive = true
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[btnSateliteMapType(50)]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[btnNormalMapType(50)]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-8-[btnNormalMapType(50)]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:[currentLocationBtn(50)]-8-|", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnNormalMapType(50)]-10-[btnStartTrip(50)]", options: [], metrics: nil, views: layoutDict))
         baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnSateliteMapType(50)]-10-[btnStartTrip(50)]", options: [], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[currentLocationBtn(50)]-10-[btnStartTrip(50)]", options: [], metrics: nil, views: layoutDict))
        
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-15-[btnStartTrip]-15-|", options: [APIHelper.appLanguageDirection], metrics: nil, views: layoutDict))
        baseView.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[btnStartTrip(50)]-10-|", options: [], metrics: nil, views: layoutDict))
        
        self.markerImageView.widthAnchor.constraint(equalToConstant: 40).isActive = true
        self.markerImageView.centerXAnchor.constraint(equalTo: baseView.centerXAnchor, constant: 0).isActive = true
        self.markerImageView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        self.markerImageView.centerYAnchor.constraint(equalTo: baseView.centerYAnchor, constant: 0).isActive = true
        
        self.activityView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        self.activityView.heightAnchor.constraint(equalToConstant: 20).isActive = true
        self.activityView.centerXAnchor.constraint(equalTo: mapview.centerXAnchor, constant: 0).isActive = true
        self.activityView.bottomAnchor.constraint(equalTo: markerImageView.topAnchor, constant: 0).isActive = true
    }
}
