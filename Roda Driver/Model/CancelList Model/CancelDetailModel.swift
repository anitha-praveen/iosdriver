//
//  CancelDetailModel.swift
//  Taxiappz Driver
//
//  Created by spextrum on 23/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import Foundation

protocol CancelDetailsViewDelegate {
    func tripCancelled(_ msg: String)
}

struct CancellationList {
    var id: Int?
    var reason: String?
    
    init?(_ dict: [String:AnyObject]) {
        if let id = dict["id"] as? Int {
            self.id = id
        }
        if let reason = dict["reason"] as? String {
            self.reason = reason
        }
    }
}
