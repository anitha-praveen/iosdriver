//
//  WalletModel.swift
//  Taxiappz Driver
//
//  Created by Apple on 22/02/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import Foundation

struct WalletHistory {
    
    var dateStr: String?
    var amount: String?
    var currency: String?
    var requestId: String?
    var purpose:  String?
    var type: String?
    
    init(_ dict: [String: AnyObject]) {
        if let datestr = dict["updated_at"] as? String {
            self.dateStr = datestr
        }
        if let amount = dict["amount"] {
            self.amount = "\(amount)"
        }
        if let currency = dict["currency"] as? String {
            self.currency = currency
        }
        if let id = dict["request_id"] as? String {
            self.requestId = id
        }
        if let purpose = dict["purpose"] as? String {
            self.purpose = purpose
        }
        if let type = dict["type"] as? String {
            self.type = type
        }
    }
}

struct DummyWallet {
    var name: String?
    var id: String
    var date: String?
    var dummyData:[ChildData]?
    
    init(name: String, data: [ChildData], id: String, date: String) {
        self.name = name
        self.dummyData = data
        self.id = id
        self.date = date
    }
}

struct ChildData {
    var amount: String?
    var purpose: String?
    init(amount: String,purpose: String) {
        self.amount = amount
        self.purpose = purpose
    }
    
}

