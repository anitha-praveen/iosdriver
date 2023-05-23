//
//  SideMenuModel.swift
//  Taxiappz Driver
//
//  Created by spextrum on 23/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import Foundation
import Kingfisher
import UIKit

enum MenuType: CaseIterable {
    case profile
    case dashboard
   // case subscription
    case history
    case wallet
    //case privateKey
    case manageDocuments
    case notification
    case appStatus
    case support
    case refferal
    case share
    case logout
    
    var title:String {
        switch self {
        case .profile:
            return "text_profile".localize()
        case .dashboard:
            return "txt_dashboard".localize()
//        case .subscription:
//            return "txt_subscription".localize()
        case .history:
            return "txt_my_rides".localize()
        case .wallet:
            return "txt_wallet".localize()
        case .manageDocuments:
            return "text_manage_documents".localize()
        case .notification:
            return "txt_noitification".localize()
        case .appStatus:
            return "txt_app_status".localize()
        case .support:
            return "txt_support".localize()
        case .refferal:
            return "text_refferal".localize()
        case .share:
            return "text_share".localize()
        case .logout:
            return "txt_logout".localize()
            
        }
    }
    var icon: UIImage? {
        switch self {
        case .profile:
            return UIImage(named:"sidemenuprofile")?.withRenderingMode(.alwaysTemplate)
        case .dashboard:
            return UIImage(named:"sidemenudashboard")?.withRenderingMode(.alwaysTemplate)
//        case .subscription:
//            return UIImage(named:"sidemenudashboard")?.withRenderingMode(.alwaysTemplate)
        case .history:
            return UIImage(named:"sidemenuhistory")?.withRenderingMode(.alwaysTemplate)
        case .wallet:
            return UIImage(named:"sidemenuwallet")?.withRenderingMode(.alwaysTemplate)
        case .manageDocuments:
            return UIImage(named:"sideMenuManageDocs")?.withRenderingMode(.alwaysTemplate)
        case .notification:
            return UIImage(named: "sidemenuNotification")?.withRenderingMode(.alwaysTemplate)
        case .appStatus:
            return UIImage(named: "sidemenuappstatus")?.withRenderingMode(.alwaysTemplate)
        case .support:
            return UIImage(named:"sidemenuSupport")?.withRenderingMode(.alwaysTemplate)
        case .refferal:
            return UIImage(named:"sidemenureferral")?.withRenderingMode(.alwaysTemplate)
        case .share:
            return UIImage(named:"sidemenushare")?.withRenderingMode(.alwaysTemplate)
        case .logout:
            return UIImage(named:"sidemenulogout")?.withRenderingMode(.alwaysTemplate)
        }
    }
}
