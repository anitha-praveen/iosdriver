//
//  OnlineOfflineModel.swift
//  Taxiappz Driver
//
//  Created by spextrum on 22/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import Foundation

// MARK: Group of Document Upload Status

enum DocumentUploadStatus: Int {
    case notUploaded = 2
    case uploadedWaitingForApproval = 4
    case modifiedWaitingForApproval = 3
    case approved = 1
    case expired = 5
    case other = 0
}
