//
//  CountryModel.swift
//  Taxiappz Driver
//
//  Created by spextrum on 21/12/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import Foundation
import UIKit

protocol CountryPickerDelegate: AnyObject {
    func selectedCountry(_ country: CountryList)
}

struct CountryList {
    
    var dialCode: String?
    var countryName: String?
    var id: String?
    var isoCode: String?
    var flag: UIImage?
    
    init(_ dict: [String: AnyObject]) {
        if let code = dict["dial_code"] {
            self.dialCode = "\(code)"
        }
        
        if let name = dict["name"] as? String {
            self.countryName = name
        }
        
        if let id = dict["id"] as? String {
            self.id = id
        }
        
        if let iso = dict["code"] as? String {
            self.isoCode = "\(iso)"
        }
        
        if let flagStr = dict["flag_base_64"] as? String {
            if let dataDecoded : Data = Data(base64Encoded: flagStr) {
                self.flag = UIImage(data: dataDecoded)
            }
        }
    }
}
