//
//  RegisterModel.swift
//  Taxiappz Driver
//
//  Created by spextrum on 22/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import Foundation



struct ServiceLocationList {
    var name:String
    var slug:String
    
    init?(_ dict:[String:AnyObject]) {
        if let adminName = dict["zone_name"] as? String,
            let slug = dict["slug"] as? String{
            self.name = adminName
            self.slug = slug
            
        } else {
            return nil
        }
    }
}

struct UserDetails {
    var firstname = ""
    var lastname = ""
    var email = ""
    var phone = ""
    var country = ""
    var countryCode = ""
    var nationalId = ""
    var deviceToken: String?
    var loginBy: String?
    var type = ""
    var carNumber = ""
    var carModel = ""
    var carManufacturer = ""
    var carYear = ""
    var carColor = ""
    var loginMethod: String?
    var adminId = ""
    var referralCode = ""
    var companyName = ""
    var companyPhone = ""
    var companyTotalVehicles = ""
    
}

// -----------Vehicle Type List
struct VehicleType {
    var id: String?
    var name: String?
    var imgUrlStr: String?
    var slug: String?
    var serviceTypes: [String]?

    init(_ dict:[String:AnyObject]) {
        if let name = dict["vehicle_name"] as? String {
            self.name = name
        }
        if let image = dict["image"] as? String {
            self.imgUrlStr = image
        }
        if let id = dict["id"] {
            self.id = "\(id)"
        }
        if let slug = dict["slug"] {
            self.slug = "\(slug)"
        }
        if let services = dict["service_types"] as? [String] {
            self.serviceTypes = services
        }
    }
}

// ------------Vehicle Model List

struct VehicleModelList {
    var name: String?
    var id: String?
    
    init(_ dict: [String: Any]) {
        if let id = dict["slug"] as? String {
            self.id = id
        }
        if let name = dict["model_name"] as? String {
            self.name = name
        }
    }
}

// ----------Company Details
struct CompanyList {
    var id: String?
    var name: String?
    var phoneNumber: String?
    init(_ dict: [String: Any]) {
        if let id = dict["slug"] as? String {
            self.id = id
        }
        if let name = dict["firstname"] as? String {
            if let lName = dict["lastname"] as? String {
                self.name = name + " " + lName
            } else {
                self.name = name
            }
        }
        if let phone = dict["phone_number"] as? String {
            self.phoneNumber = phone
        }
    }
}

enum RegistrationMethod {
    case individual
    case company
}

protocol CompanyListDelegate: AnyObject {
    func selectedCompany(company selectedCompany: CompanyList)
}
