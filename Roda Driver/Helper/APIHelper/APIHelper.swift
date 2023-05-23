//
//  HelperClass.swift
//  TapNGo Driver
//
//  Created by Spextrum on 07/10/17.
//  Copyright © 2017 nPlus. All rights reserved.
//

import UIKit
import Foundation
import Alamofire
import NVActivityIndicatorView
import IQKeyboardManagerSwift
import CoreData
import Kingfisher

class APIHelper {
    
    static let shared = APIHelper()

    var deviceToken = "DefaultStringForSimulator"
    let appName = Bundle.main.infoDictionary?["CFBundleName"] as? String


    let activityData = ActivityData(type: .ballClipRotate, color: .themeColor)
    let activityPulseData = ActivityData(type: .ballClipRotatePulse, color: .themeColor)
    
    var showRefferal = Bool()
    
  
    static var satelitemaptype: Bool {
        get {
            return UserDefaults.standard.bool(forKey: "satelitemaptype")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "satelitemaptype")
            UserDefaults.standard.synchronize()
        }
    }

    static var firebaseVerificationCode: String {
        get {
            return UserDefaults.standard.string(forKey: "VerificationCode") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "VerificationCode")
            UserDefaults.standard.synchronize()
        }
    }
    
    var landingPage: String {
        get {
            return UserDefaults.standard.string(forKey: "LandingPage") ?? "Get Started"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LandingPage")
        }
    }
    
    var currentLangDate: Double {
        get {
            return UserDefaults.standard.double(forKey: "CurrentLangDate")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "CurrentLangDate")
        }
    }
    
#if DEBUG
    
    let BASEURL = "http://3.216.234.12/roda/public/api/"
    let socketUrl = URL(string: "http://3.216.234.12:3001")!
    let appBaseCode = "V-53f3ee0ba2223997e7a7f85601b416f7"
    
    var gmsServiceKey = "AIzaSyCahpCowqRxzDAd37KP48sbNA0sC3QXv4w"
    var gmsPlacesKey  = "AIzaSyBa6bO_40mnI3QIttrKQmKB9GErFDWDiK4"
    var gmsDirectionKey = "AIzaSyCahpCowqRxzDAd37KP48sbNA0sC3QXv4w"
#else
    
    let BASEURL = "http://3.216.234.12/roda/public/api/"
    let socketUrl = URL(string: "http://3.216.234.12:3001")!
    let appBaseCode = "V-53f3ee0ba2223997e7a7f85601b416f7"
    
    var gmsServiceKey = "AIzaSyCahpCowqRxzDAd37KP48sbNA0sC3QXv4w"
    var gmsPlacesKey  = "AIzaSyA0Iv-Af7Vu3qmiVxo_nuCKW-c2Z2t-1Dk"
    var gmsDirectionKey = "AIzaSyCahpCowqRxzDAd37KP48sbNA0sC3QXv4w"
#endif
    
 
    
    static var googleApiComponents = URLComponents()

    // Other URL Suffixes
    var header: [String: String] {
        return ["Accept": "application/json", "Content-Language": "en"]
    }
    
    var authHeader: [String: String] {
        return ["Authorization": LocalDB.shared.driverDetails?.accessToken ?? "", "Content-Language": "en"]
    }
    

    static let getLanguage                          = "V1/languages"
    static let getVehicleTypesList                  = "V1/types/list"
    static let sendOTP                              = "V1/user/sendotp"
    static let driverSignUp                         = "V1/driver/signup"
    static let driverLogin                          = "V1/driver/signin"
    static let authToken                            = "V1/auth/token"
    static let getDriverProfile                     = "V1/driver/profile"
    static let getServiceLocation                   = "V1/servicelocation/list"
    static let getVerifyDriver                      = "V1/driver/check/phonenumber"
    static let getFAQList                           = "V1/faq"
    static let getSOSList                           = "V1/sos"
    static let deleteSOS                            = "V1/sos/delete/"
    static let addSOSNumber                         = "V1/sos/store"
    static let getComplaintList                     = "V1/complaints/list"
    static let getComplaintAdd                      = "V1/complaints/add"
    static let getDocumentList                      = "V1/document/document-group"
    static let uploadDocument                       = "V1/driver/document-upload"
    static let getRequestInProgress                 = "V1/driver/request_in_progress"
    static let toggleDriverStatus                   = "V1/driver/online-update"
    static let acceptRejectAPI                      = "V1/request/respond"
    static let driverArrival                        = "V1/request/arrive"
    static let startTripApi                         = "V1/request/start"
    static let endTheRide                           = "V1/request/end"
    static let rateUser                             = "V1/request/rating"
    static let getCancellationReason                = "V1/cancellation/list"
    static let cancelTrip                           = "V1/request/cancel/driver"
    static let getHistoryList                       = "V1/request/user/trip/history"
    static let logoutUser                           = "V1/user/logout"
    static let getWalletAmount                      = "V1/wallet"
    static let addWalletAmount                      = "V1/wallet/add-amount"
    static let dashBoard                            = "V1/dashboard"
    static let getTripComplaintList                 = "V1/complaints/trip-list"
    static let getNotificationList                  = "V1/notification/list"
    static let getSubscriptionList                  = "V1/subscription/list"
    static let confirmLocationChange                = "V1/request/approve-change-location"
    static let subscribeRequest                     = "V1/subscription/add"
    static let getCompanyList                       = "V1/company/user"
    static let getVehicleModelList                  = "V1/get/model"
    static let createRequest                        = "V1/request/create"
    static let singleHistory                        = "V1/request/single-history"
    static let getReferral                          = "V1/get/referral"
    static let getAdminContact                      = "V1/customer-care"
    static let uploadNytTimePhoto                   = "V1/request/image-upload"
    static let skipNytTimePhoto                     = "V1/request/skip-upload"
    static let retakePassengerPhoto                 = "V1/request/retake-image"
    static let uploadInstantDispatchPhoto           = "V1/instant/image/upload"
    static let deleteAccount                        = "V1/userdelete/delete"

    
    static var appLanguageDirection: NSLayoutConstraint.FormatOptions {
        return currentAppLanguage == "ar" ? .directionRightToLeft : .directionLeftToRight
    }
    static var appTextAlignment: NSTextAlignment {
        return currentAppLanguage == "ar" ? .right : .left
    }
    static var appSemanticContentAttribute: UISemanticContentAttribute {
        return currentAppLanguage == "ar" ? .forceRightToLeft : .forceLeftToRight
    }
    
    static var currentAppLanguage:String {
        get {
            return UserDefaults.standard.string(forKey: "currentLanguage") ?? "en"
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "currentLanguage")
            UserDefaults.standard.synchronize()
            IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "text_Done".localize()
        }
    }
    
    static var privateKey: String {
        get {
            return UserDefaults.standard.string(forKey: "privatekey") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "privatekey")
            UserDefaults.standard.synchronize()
        }
    }
}






