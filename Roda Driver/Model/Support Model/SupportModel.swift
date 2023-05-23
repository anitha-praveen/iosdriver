//
//  SupportModel.swift
//  Taxiappz Driver
//
//  Created by spextrum on 23/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import Kingfisher
import Foundation

enum SupportMenuType: CaseIterable {
    
    case complaint
    case sos
    case faq
    
    var title:String {
        switch self {
        
        case .complaint:
            return "txt_complaints".localize()
        case .sos:
            return "txt_sos".localize()
        case .faq:
            return "text_faq".localize()
        }
    }
    var icon: UIImage? {
        switch self {
        
        case .complaint:
            return UIImage(named: "sidemenucomplaints")?.withRenderingMode(.alwaysTemplate)
        case .sos:
            return UIImage(named: "sidemenusos")?.withRenderingMode(.alwaysTemplate)
        case .faq:
            return UIImage(named: "sidemenufaq")?.withRenderingMode(.alwaysTemplate)
        }
    }
}
