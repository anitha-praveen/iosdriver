//
//  LaunchVC.swift
//  Taxiappz Driver
//
//  Created by spextrum on 20/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import UIKit
import Alamofire
import SWRevealViewController
import NVActivityIndicatorView
import SwiftyGif
import FirebaseDatabase
import IQKeyboardManagerSwift
import GoogleMaps
class LaunchVC: UIViewController , SwiftyGifDelegate {

    private let launchView = LaunchView()
    
    private var ref: DatabaseReference!
    private var availableLanguage = [AvailableLanguageModel]()

    override func viewDidLoad() {
        super.viewDidLoad()

        self.setupViews()
        self.setupTarget()
        self.getAvailLanguages()
    }
    
    func setupViews() {
        launchView.setupViews(Base: self.view)
    }

    func setupTarget() {
        launchView.logoImgView.delegate = self
    }
    
    @objc func networkCheck() {
        if availableLanguage.isEmpty {
            self.getAvailLanguages()
        }
    }
}

extension LaunchVC {
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.launchView.logoImgView.startAnimatingGif()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(networkCheck), name: UIApplication.willEnterForegroundNotification, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.launchView.logoImgView.stopAnimatingGif()
        NotificationCenter.default.removeObserver(UIApplication.willEnterForegroundNotification)
    }
}

extension LaunchVC {
    func getAvailLanguages() {
        if ConnectionCheck.isConnectedToNetwork() {
            
            var paramDict = Dictionary<String, Any>()
            paramDict["code"] = APIHelper.shared.appBaseCode
            
            let url = APIHelper.shared.BASEURL + APIHelper.getLanguage
            
            print("URL and Param For AvailLanguages",url, paramDict)
            Alamofire.request(url, method: .post, parameters: paramDict, encoding: JSONEncoding.default, headers: APIHelper.shared.header).responseJSON { (response) in
                
                print("reponse get AvailLanguages",response.result.value as Any)
                if let result = response.result.value as? [String: AnyObject] {
                    if let statusCode = response.response?.statusCode {
                        if statusCode == 200 {
                            if let data = result["data"] as? [String: AnyObject] {
                                if let placesKey = data["places_api_key"] as? String {
                                    APIHelper.shared.gmsPlacesKey = placesKey
                                }
                                if let directionKey = data["directional_api_key"] as? String {
                                    APIHelper.shared.gmsDirectionKey = directionKey
                                }
                                if let gmsServiceKey = data["geo_coder_api_key"] as? String {
                                    APIHelper.shared.gmsServiceKey = gmsServiceKey
                                }
                                if let languageAvailable = data["languages"] as? [[String: AnyObject]] {
                                    
                                    self.availableLanguage = languageAvailable.compactMap({AvailableLanguageModel($0)})
                                    
                                    RJKLocalize.shared.availableLanguages = self.availableLanguage.map({ ($0.code ?? "") })
                                    
                                    RJKLocalize.shared.availableLanguages.sort(by: <)
                                    print(RJKLocalize.shared.availableLanguages)
                                    if let currentLang = self.availableLanguage.first(where: {$0.code == APIHelper.currentAppLanguage}) {
                                        if currentLang.updateTime ?? 0.00 > APIHelper.shared.currentLangDate {
                                            APIHelper.shared.currentLangDate = currentLang.updateTime ?? 0.00
                                            self.getSelectLanguage(LangCode: APIHelper.currentAppLanguage)
                                            print("Language Update Needed")
                                        } else {
                                            self.redirect()

                                        }
                                    } else {
                                        self.redirect()

                                    }
                                }
                            }
                        } else {
                            if response.response?.statusCode == 426 {
                                self.navigationController?.pushViewController(UpdateAppVC(), animated: true)
                            } else {
                                self.view.showToast("txt_sry_try_again".localize())
                            }
                        }
                    }
                }
            }
        } else {
            self.showAlert("txt_NoInternet".localize(), message: "txt_NoInternet_title".localize())
        }
    }
    
    func getSelectLanguage(LangCode: String) {
        if ConnectionCheck.isConnectedToNetwork() {
            let url = APIHelper.shared.BASEURL + APIHelper.getLanguage + "/" + LangCode
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.header)
                .responseJSON { response in
                    print("response for languages",response.result.value as AnyObject)
                    if let result = response.result.value as? [String:AnyObject] {
                        if let statusCode = response.response?.statusCode {
                            if statusCode == 200 {
                                if let data = result["data"] as? [String: String] {
                                    print(data.count)
                                    if let json = try? JSONSerialization.data(withJSONObject: data, options: []) {
                                        guard let documentDirectoryUrl = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
                                        let fileUrl = documentDirectoryUrl.appendingPathComponent("lang-\(LangCode).json")
                                        try? json.write(to: fileUrl, options: [])
                                        print(fileUrl)
                                    }
                                    RJKLocalize.shared.details = [:]
                                    IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "text_Done".localize()
                                   

                                    self.redirect()
                                }
                            } else {
                                NVActivityIndicatorPresenter.sharedInstance.stopAnimating()
                                if let error = result["data"] as? [String:[String]] {
                                    let errMsg = error.reduce("", { $0 + "\n" + ($1.value.first ?? "") })
                                    self.showAlert("", message: errMsg)
                                } else if let error = result["error_message"] as? String {
                                    self.showAlert("", message: error)
                                } else if let errMsg = result["message"] as? String {
                                    self.showAlert("", message: errMsg)
                                }
                            }
                        }
                    }
                }
        } else {
            self.showAlert("txt_NoInternet".localize(), message: "txt_NoInternet_title".localize())
        }
    }
}


extension LaunchVC {
    
    func redirect() {
        
        let firstvc = InitialViewController()
        let mainViewController = UINavigationController(rootViewController: firstvc)
        mainViewController.interactivePopGestureRecognizer?.isEnabled = false
        mainViewController.navigationBar.isHidden = true
        
        if LocalDB.shared.driverDetails != nil {
            print(LocalDB.shared.driverDetails?.accessToken as Any)
           // AppLocationManager.shared.startTracking()
            MySocketManager.shared.establishConnection()
            
           let revealVC = SWRevealViewController()
            revealVC.panGestureRecognizer().isEnabled = false
            
            let homeVC = OnlineOfflineVC()
            let navVC = UINavigationController(rootViewController:homeVC)
            navVC.interactivePopGestureRecognizer?.isEnabled = false
            revealVC.frontViewController = navVC
            
            if APIHelper.appLanguageDirection == .directionLeftToRight {
                revealVC.rearViewController = SideMenuVC()
                revealVC.rightViewController = nil
            } else {
                revealVC.rearViewController = nil
                revealVC.rightViewController = SideMenuVC()
            }
            mainViewController.setViewControllers([firstvc, revealVC], animated: false)
            
            UIApplication.shared.windows.first?.rootViewController = mainViewController
            UIApplication.shared.windows.first?.makeKeyAndVisible()
        } else {
            if APIHelper.shared.landingPage == "login" {
                let firstvc = InitialViewController()
                firstvc.navigationController?.navigationBar.isHidden = true
                self.navigationController?.pushViewController(firstvc, animated: false)
            } else {
               
                let showCaseVC = SelectLanguageVC()
                showCaseVC.availableLanguage = self.availableLanguage
                let navVC = UINavigationController(rootViewController: showCaseVC)
                navVC.interactivePopGestureRecognizer?.isEnabled = false
                showCaseVC.navigationController?.navigationBar.isHidden = true
                self.navigationController?.pushViewController(showCaseVC, animated: false)
            }
        }
    }
}

