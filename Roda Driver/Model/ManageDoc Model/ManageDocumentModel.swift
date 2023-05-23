//
//  ManageDocumentModel.swift
//  Taxiappz Driver
//
//  Created by spextrum on 22/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import Foundation
import Kingfisher

struct DocumentList {
    
    var id: String?
    var documentName: String?
    var slug: String?
    var documentCount: Int?
    var uploadStatus: Bool?
    var subDocument: [SubDocumentList]?
        
    init(_ dict: [String: AnyObject]) {
        if let id = dict["id"] {
            self.id = "\(id)"
        }
        if let name = dict["name"] as? String {
            self.documentName = name
        }
        if let slug = dict["slug"] as? String {
            self.slug = slug
        }
       
        if let docCount = dict["document_count"] as? Int {
            self.documentCount = docCount
        }
       
        if let status = dict["upload_status"] as? Bool {
            self.uploadStatus = status
        }
        if let subDoc = dict["get_document"] as? [[String: AnyObject]] {
            self.subDocument = subDoc.compactMap({SubDocumentList($0)})
        }
    }
}


struct SubDocumentList {
    
    var id: String?
    var documentName: String?
    var documentImg: String?
    var exDate: String?
    var issuseDate: String?
    var slug: String?
    var requried: Bool?
    var expired: Bool?
    var dateRequried: String?
    var isUpload: Bool?
    var isIdentifierNeeded: Bool?
    var identifierValue: String?
    var pickerImage: UIImage?
    init(_ dict: [String: AnyObject]) {
        if let id = dict["id"] {
            self.id = "\(id)"
        }
        if let name = dict["document_name"] as? String {
            self.documentName = name
        }
        if let img = dict["document_image"] as? String {
            self.documentImg = img
        }
        if let number = dict["expiry_dated"] as? String {
            self.exDate = number
        }
        if let issuseDate = dict["issue_date"] as? String {
            self.issuseDate = issuseDate
        }
        if let slug = dict["slug"] as? String {
            self.slug = slug
        }
        if let dateRequried = dict["expiry_date"] {
            self.dateRequried = "\(dateRequried)"
        }
        if let isUpload = dict["is_uploaded"] as? Bool {
            self.isUpload = isUpload
        }
        if let requried = dict["requried"] as? Bool {
            self.requried = requried
        }
        if let expiredDoc = dict["exprience_status"] as? Bool {
            self.expired = expiredDoc
        }
        if let needIdentifier = dict["identifier"] as? Bool {
            self.isIdentifierNeeded = needIdentifier
        }
        if let identifierValue = dict["identifier_document"] as? String {
            self.identifierValue = identifierValue
        }
    }
}

/*
struct DocumentList {
    
    var id: String?
    var documentName: String?
    var documentImg: String?
    var exDate: String?
    var issuseDate: String?
    var slug: String?
    var requried: Bool?
    var expired: Bool?
    var dateRequried: String?
    var isUpload: Bool?
    var isIdentifierNeeded: Bool?
    var identifierValue: String?
        
    init(_ dict: [String: AnyObject]) {
        if let id = dict["id"] {
            self.id = "\(id)"
        }
        if let name = dict["document_name"] as? String {
            self.documentName = name
        }
        if let img = dict["document_image"] as? String {
            self.documentImg = img
        }
        if let number = dict["expiry_date"] as? String {
            self.exDate = number
        }
        if let issuseDate = dict["issue_date"] as? String {
            self.issuseDate = issuseDate
        }
        if let slug = dict["slug"] as? String {
            self.slug = slug
        }
        if let dateRequried = dict["date_required"] {
            self.dateRequried = "\(dateRequried)"
        }
        if let isUpload = dict["is_uploaded"] as? Bool {
            self.isUpload = isUpload
        }
        if let requried = dict["requried"] as? Bool {
            self.requried = requried
        }
        if let expiredDoc = dict["document_expiry"] as? Bool {
            self.expired = expiredDoc
        }
        if let needIdentifier = dict["identifier"] as? Bool {
            self.isIdentifierNeeded = needIdentifier
        }
        if let identifierValue = dict["identifier_value"] as? String {
            self.identifierValue = identifierValue
        }
    }
}
*/


