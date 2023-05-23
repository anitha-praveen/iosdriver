//
//  AppStatusVC.swift
//  Roda Driver
//
//  Created by NPlus Technologies on 09/06/22.
//

import UIKit
import CoreLocation
import FirebaseDatabase

class AppStatusVC: UIViewController {

    var appstatusView = AppStatusView()
    var isConnected = Bool()
    var isGpsEnabled = Bool()
    
    private var ref: DatabaseReference!

    
    var isUpdated: Bool? = false {
        didSet {
            if isUpdated ?? false {
                if isConnected {
                    if isGpsEnabled {
                        appstatusView.appStatusDiscriptLbl.backgroundColor = .darkGreen
                        appstatusView.appStatusDiscriptLbl.text = "txt_working_fine".localize()
                    } else {
                        appstatusView.appStatusDiscriptLbl.backgroundColor = .red
                        appstatusView.appStatusDiscriptLbl.text = "txt_not_fine".localize()
                    }
                } else {
                    appstatusView.appStatusDiscriptLbl.backgroundColor = .red
                    appstatusView.appStatusDiscriptLbl.text = "txt_not_fine".localize()
                }
            } else {
                appstatusView.appStatusDiscriptLbl.backgroundColor = .red
                appstatusView.appStatusDiscriptLbl.text = "txt_not_fine".localize()
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        #if DEBUG
           // ref = Database.database(url: "https://development-db-a8581.firebaseio.com/").reference().child("drivers")
            ref = Database.database().reference().child("drivers")
        
        #else
            ref = Database.database().reference().child("drivers")
        #endif
        
        setupViews()
        setupTarget()
        setupData()
        
        self.navigationController?.navigationBar.isHidden = true
        
        guard let authId = LocalDB.shared.driverDetails?.id else {
            return
        }
        addObserverFor(authId)
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(gpsCheck), name: UIApplication.willEnterForegroundNotification, object: nil)
    }

    func setupViews() {
        appstatusView.setupViews(Base: self.view)
    }

    func setupTarget() {
        appstatusView.backBtn.addTarget(self, action: #selector(backBtnPressed(_:)), for: .touchUpInside)
    }
    
    func setupData() {
        networkStatus()
        gpsStatus()
    }
    
    func networkStatus() {
        if ConnectionCheck.isConnectedToNetwork() {
            appstatusView.networkCheckLbl.text = "txt_network_status".localize() + ":" + " " + "text_ok".localize()
            appstatusView.nonetworklbl.isHidden = true
            appstatusView.networkImgView.image = UIImage(named: "yes")
            isConnected = true
        } else {
            appstatusView.networkCheckLbl.text = "txt_network_status".localize() + ":"
            appstatusView.nonetworklbl.isHidden = false
            appstatusView.networkImgView.image = UIImage(named: "no")
            isConnected = false
        }
    }
    
    func gpsStatus() {
        if CLLocationManager.locationServicesEnabled() {
            switch CLLocationManager.authorizationStatus() {
            
            case .authorizedAlways, .authorizedWhenInUse:
                appstatusView.gpsCheckLbl.text = "txt_network_gps".localize() + ":" + " " + "text_ok".localize()
                appstatusView.enableGpsLbl.isHidden = true
                appstatusView.gpsImgView.image = UIImage(named: "yes")
                isGpsEnabled = true
                break
            case .restricted, .denied, .notDetermined:
                appstatusView.gpsCheckLbl.text = "txt_network_gps".localize()
                appstatusView.enableGpsLbl.isHidden = false
                appstatusView.gpsImgView.image = UIImage(named: "no")
                isGpsEnabled = false
                break
            @unknown default:
                break
            }
        }
    }
    
    func addObserverFor(_ driverID: String) {
        let driverRef = self.ref.child(driverID)
        driverRef.observe(.value, with: { (snapshot) in
            let value = snapshot.value as? [String: Any]
            if let updatedAt = value!["updated_at"] as? Double {
                let date = Date(timeIntervalSince1970: (updatedAt / 1000.0))
                let string = "\(date)"
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
                if let dateVal = dateFormatter.date(from: string) {
                    dateFormatter.dateFormat = "dd-MM-yyyy HH:mm:ss"
                    let dateString = dateFormatter.string(from: dateVal)
                    print("EXACT_DATE : \(dateString)")
                    self.appstatusView.datelbl.text = dateString
                }
                self.appstatusView.updatDiscriptLbl.isHidden = true
                self.appstatusView.updatedImgView.image = UIImage(named: "yes")
                self.isUpdated = true
            } else {
                self.appstatusView.datelbl.text = ""
                self.appstatusView.updatDiscriptLbl.isHidden = false
                self.appstatusView.updatedImgView.image = UIImage(named: "no")
                self.isUpdated = false
            }
        })
    }

}

extension AppStatusVC {
    
    @objc func backBtnPressed(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func gpsCheck() {
        gpsStatus()
    }

}
