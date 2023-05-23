//
//  EnableLocationScreen.swift
//  Taxiappz
//
//  Created by Apple on 06/01/22.
//  Copyright © 2022 Mohammed Arshad. All rights reserved.
//

import UIKit
import CoreLocation
class EnableLocationScreen: UIViewController {
    
    private let locationView = EnableLocationView()
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(changeAuthorization), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    func setupViews() {
        locationView.setupViews(Base: self.view)
        locationView.btnConfirm.addTarget(self, action: #selector(btnConfirmPressed(_ :)), for: .touchUpInside)
        
    }

    @objc func btnConfirmPressed(_ sender: UIButton) {
        guard let bundleId = Bundle.main.bundleIdentifier,let settingsUrl = URL(string:"\(UIApplication.openSettingsURLString)&path=LOCATION/\(bundleId)") else {
            return
        }

        if UIApplication.shared.canOpenURL(settingsUrl) {
            UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                print("Settings opened: \(success)")
            })
        }
    }
    
    @objc func changeAuthorization() {
        
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            
            case .authorizedAlways, .authorizedWhenInUse:
                self.navigationController?.popViewController(animated: true)
                break
            case .restricted, .denied, .notDetermined:
                break
            @unknown default:
                break
            }
        }
    }

}
