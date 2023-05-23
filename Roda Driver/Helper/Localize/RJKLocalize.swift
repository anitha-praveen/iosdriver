//
//  RJKLocalize.swift
//  Taxiappz
//
//  Created by Admin on 20/07/18.
//  Copyright © 2018 Mohammed Arshad. All rights reserved.
//

import Foundation
import Alamofire
import IQKeyboardManagerSwift

class RJKLocalize:NSObject {

    var availableLanguages = [String]()
    var details = [String:String]()

    static let shared = RJKLocalize()
    private override init() {
        super.init()
    }

}

