//
//  AppDelegate.swift
//  Roda Driver
//
//  Created by Apple on 24/03/22.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift
import Firebase
import GoogleMaps
import GooglePlaces
import SWRevealViewController
import AWSS3
import SwiftUI
@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var response:[String:Any]?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let notification =  launchOptions?[UIApplication.LaunchOptionsKey.remoteNotification] as? [String:Any] {
             self.response = notification
        }
        
        FirebaseApp.configure()
        GMSServices.provideAPIKey(APIHelper.shared.gmsServiceKey)
        GMSPlacesClient.provideAPIKey(APIHelper.shared.gmsPlacesKey)
        
        AppLocationManager.shared.locationManager.requestAlwaysAuthorization()
        
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        
        UNUserNotificationCenter.current().requestAuthorization(options:[.badge, .alert, .sound]){ (granted, _) in
            print("granted:\(granted)")
        }
        application.registerForRemoteNotifications()
        
        
        if APIHelper.appLanguageDirection == .directionLeftToRight {
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            UINavigationBar.appearance().semanticContentAttribute = .forceLeftToRight
        } else {
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            UINavigationBar.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        application.isIdleTimerDisabled  = true
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.keyboardDistanceFromTextField = 50
        IQKeyboardManager.shared.shouldResignOnTouchOutside = true
        IQKeyboardManager.shared.toolbarDoneBarButtonItemText = "Done"

        LocalDB.shared.delegate = self
        LocalDB.shared.fetchUsers()
        
        initializeS3()

        self.window = UIWindow(frame: UIScreen.main.bounds)
        let launch = UINavigationController(rootViewController: LaunchVC())
        launch.interactivePopGestureRecognizer?.isEnabled = false
        launch.navigationBar.isHidden = true
        self.window?.rootViewController = launch
        self.window?.makeKeyAndVisible()
 
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        
        
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
       
    }

    func applicationWillTerminate(_ application: UIApplication) {
        LocalDB.shared.saveContext()
    }
    
    func initializeS3() {
        let poolId = "us-east-2:d39598d4-bbec-4b7a-864c-21cad8c4a468"
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.USEast2, identityPoolId:poolId)
        let configuration = AWSServiceConfiguration(region:.USEast2, credentialsProvider:credentialsProvider)
        AWSServiceManager.default().defaultServiceConfiguration = configuration
    }


}


extension AppDelegate: UNUserNotificationCenterDelegate, MessagingDelegate {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {

        Messaging.messaging().apnsToken = deviceToken
        print("APNs device token: \(deviceToken)")

    }
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
    }

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        APIHelper.shared.deviceToken = fcmToken ?? ""
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
       
        print("recieved push resp: ", userInfo)
        self.performActions(userInfo)
    }
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        self.performActions(userInfo)
        print("Notification resp: ", userInfo)
        
        completionHandler(UIBackgroundFetchResult.newData)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userdict = notification.request.content.userInfo
        print(userdict)
        self.performActions(userdict)
        if UIApplication.shared.applicationState != .active {
            completionHandler([.alert,.sound,.badge])
        } else {
            completionHandler([.alert,.badge,.sound])
        }
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        if let body = userInfo["body"] as? [String: AnyObject] {
            
            if let notificationEnum = body["notification_enum"] as? String {
                
                self.checkPurpose(notificationEnum: notificationEnum)
            }
        } else if let str = userInfo["body"] as? String, let data = str.data(using: .utf8),
                  let bodyDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
            
            if let notificationEnum = bodyDict["notification_enum"] as? String {
                self.checkPurpose(notificationEnum: notificationEnum)
            }
        }
        
        
        UIApplication.shared.applicationIconBadgeNumber = 0
        completionHandler()
    }
    
    
    func checkPurpose(notificationEnum: String) {
        
        if notificationEnum == "request_created" {
             self.checkLogin()

        }
    }
    
    func performActions(_ userdict: [AnyHashable:Any]) {
        
        func performActionForMsg(_ msg: String, details: [String: AnyObject]) {
            switch msg {
            case "request_created":
                NotificationCenter.default.post(name: .newRideRequest, object: nil, userInfo: details)
            case "trip_location_changed":
                NotificationCenter.default.post(name: .tripLocationChanged, object: nil, userInfo: details)
            case "local_to_rental":
                NotificationCenter.default.post(name: .localToRental, object: nil, userInfo: details)
            case "driver_approved":
                NotificationCenter.default.post(name: .driverApproved, object: nil, userInfo: details)
            case "driver_blocked":
                NotificationCenter.default.post(name: .driverDeclined, object: nil, userInfo: details)
            case "payment_change":
                NotificationCenter.default.post(name: .paymentModeChanged, object: nil, userInfo: details)
            case "payment_done":
                NotificationCenter.default.post(name: .paymentCompleted, object: nil, userInfo: details)
            case "cancelled":
                if let iscancelled = details["is_cancelled"] as? Bool, iscancelled {
                    NotificationCenter.default.post(name: Notification.Name("TripCancelledNotification"), object: nil, userInfo: details)
                }
            case "another_user_loggedin":
                LocalDB.shared.deleteUser()
            default:
                break
            }
        }
        
        if let body = userdict["body"] as? [String: AnyObject] {
            
            if let notificationEnum = body["notification_enum"] as? String {
                performActionForMsg(notificationEnum, details: body)
            }
        } else if let str = userdict["body"] as? String, let data = str.data(using: .utf8),
                  let bodyDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject] {
            
            if let notificationEnum = bodyDict["notification_enum"] as? String {
                performActionForMsg(notificationEnum, details: bodyDict)
            }
        }
    }
}

// MARK:Logout Delegates
extension AppDelegate: LogoutDelegate {
    func logedOut() {
        MySocketManager.shared.socket.disconnect()
        self.checkLogin()
    }
    
    // MARK:Check Login
    
    func checkLogin() {
        
        self.window = UIWindow(frame: UIScreen.main.bounds)
   
        if LocalDB.shared.driverDetails != nil {
            
            MySocketManager.shared.establishConnection()
            let mainViewController = SWRevealViewController()
           
            mainViewController.panGestureRecognizer().isEnabled = false
            if APIHelper.appLanguageDirection == .directionLeftToRight {
                mainViewController.rearViewController = SideMenuVC()
                mainViewController.rightViewController = nil
            } else {
                mainViewController.rearViewController = nil
                mainViewController.rightViewController = SideMenuVC()
            }

            let homeVC = OnlineOfflineVC()
            mainViewController.frontViewController = UINavigationController(rootViewController:homeVC)
            self.window?.rootViewController = mainViewController
        }  else {
            let mainViewController = InitialViewController()
            mainViewController.modalPresentationStyle = .fullScreen
            mainViewController.navigationController?.navigationBar.isHidden = true
            self.window?.rootViewController = UINavigationController(rootViewController: mainViewController)
        }
        self.window?.makeKeyAndVisible()
    }
    
}
