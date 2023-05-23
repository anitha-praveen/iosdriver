//
//  SubscriptionList.swift
//  Taxiappz Driver
//
//  Created by Apple on 07/03/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import Foundation

struct SubscriptionList {
    var id: String?
    var name: String?
    var description: String?
    var amount: String?
    var validity: String?
    var slug: String?
    
    init(_ dict: [String: AnyObject]) {
        if let id = dict["id"] {
            self.id = "\(id)"
        }
        if let slug = dict["slug"] as? String {
            self.slug = slug
        }
        if let name = dict["name"] as? String {
            self.name = name
        }
        if let desc = dict["description"] as? String {
            self.description = desc
        }
        if let amt = dict["amount"] {
            self.amount = "\(amt)"
        }
        if let validity = dict["validity"] {
            self.validity = "\(validity)" + " " +  "txt_days".localize()
        }
    }
}
