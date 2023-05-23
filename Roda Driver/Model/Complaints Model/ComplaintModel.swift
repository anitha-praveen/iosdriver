//
//  ComplaintModel.swift
//  Taxiappz Driver
//
//  Created by NPlus Technologies on 06/01/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import Foundation

struct Complaint {
    var id: String?
    var slug: String?
    var title: String?
    
    init(_ dict:[String:AnyObject]) {
        if let id = dict["id"] {
            self.id = "\(id)"
        }
        if let slug = dict["slug"] {
            self.slug = "\(slug)"
        }
        if let title = dict["title"] as? String {
            self.title = title
        }
    }
}
