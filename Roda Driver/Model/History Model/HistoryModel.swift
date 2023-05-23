//
//  HistoryModel.swift
//  Taxiappz Driver
//
//  Created by spextrum on 23/11/21.
//  Copyright © 2021 nPlus. All rights reserved.
//

import Foundation

enum SelectedHistory {
    case completed
    case cancelled
}

struct HistroyDetail {

    var requestId: String?
    var id: String?
    var enableDispute: Bool?
    var pickLatitude: Double?
    var pickLongitude: Double?
    var dropLatitude: Double?
    var dropLongitude: Double?
    var pickLocation: String?
    var dropLocation: String?
    var tripStartTime: String?
    var totalTime: String?
    var tripEndTime: String?
    var isCompleted: Bool = false
    var isCancelled: Bool = false
    var isInstantTrip: Bool = false
    var instantPhoneNumber: String?
    var typeIconUrlStr: String?
    var typeName: String?
    var totalDistance: String?
    var unit: String?
    var review: String?
    var paymentOpt: String?
    var serviceCatagory: String?
    var tripStartkm: String?
    var tripEndkm: String?
    
    var cancelBy: String?
    var cancelReason: String?
    
    var userDetails: HistoryUser?
    var carDetails: HistoryCar?
    var requestBill: HistoryRequestBill?
    var outStationTripType: String?
    
    init(_ dict: [String: AnyObject]) {
        
        if let data = dict["data"] as? [String: AnyObject] {
            
            if let requestId = data["request_number"] as? String {
                self.requestId = requestId
            }
            if let id = data["id"] as? String {
                self.id = id
            }
            if let disputeStatus = data["dispute_status"] as? Bool {
                self.enableDispute = disputeStatus
            }
            if let pickLatitude = data["pick_lat"] {
                self.pickLatitude = Double("\(pickLatitude)")
            }
            if let pickLongitude = data["pick_lng"] {
                self.pickLongitude = Double("\(pickLongitude)")
            }
            if let dropLatitude = data["drop_lat"] {
                self.dropLatitude = Double("\(dropLatitude)")
            }
            if let dropLongitude = data["drop_lng"] {
                self.dropLongitude = Double("\(dropLongitude)")
            }
            if let pickLocation = data["pick_address"] as? String {
                self.pickLocation = pickLocation
            }
            if let dropLocation = data["drop_address"] as? String {
                self.dropLocation = dropLocation
            }
            if let tripStartTime = data["trip_start_time"] as? String {
                self.tripStartTime = tripStartTime
            }
            if let tripEndTime = data["completed_at"] as? String {
                self.tripEndTime = tripEndTime
            }
            if let isCompleted = data["is_completed"] as? Bool {
                self.isCompleted = isCompleted
            }
            if let isCancelled = data["is_cancelled"] as? Bool {
                self.isCancelled = isCancelled
            }
            if let isInstanttrip = data["is_instant_trip"] as? Bool {
                self.isInstantTrip = isInstanttrip
            }
            if let instantphonenumber = data["instant_phone_number"] as? String {
                self.instantPhoneNumber = instantphonenumber
            }
            if let typeName = data["vehicle_name"] as? String {
                self.typeName = typeName
            }
            if let totalTime = data["total_time"] {
                self.totalTime = "\(totalTime)"
            }
            if let totalDistance = data["total_distance"] as? Double {
                self.totalDistance = "\(totalDistance)"
            }
            if let unit = data["unit"] {
                self.unit = "\(unit)"
            }
            if let review = data["user_overall_rating"] {
               // self.review = Double("\(review)")
                if let rating = Double("\(review)") {
                    self.review = String(format: "%.2f", rating)
                }
            }
            if let paymentOpt = data["payment_opt"] as? String {
                self.paymentOpt = paymentOpt
            }
            if let servicecatagory = data["service_category"] as? String {
                self.serviceCatagory = servicecatagory
            }
            if let startkm = data["start_km"] as? String {
                self.tripStartkm = startkm
            }
            if let endkm = data["end_km"] as? String {
                self.tripEndkm = endkm
            }
            if let cancelby = data["cancel_method"] as? String {
                self.cancelBy = cancelby
            }
            if let cancelreason = data["custom_reason"] as? String {
                self.cancelReason = cancelreason
            } else if let reason = data["reason"] as? String {
                self.cancelReason = reason
            }
            if let userData = data["user"] as? [String: AnyObject] {
                self.userDetails = HistoryUser(userData)
            }
            if let carDetails = data["car_details"] as? [String: AnyObject] {
                self.carDetails = HistoryCar(carDetails)
            }
            if let billDetails = data["requestBill"] as? [String: AnyObject] {
                if let dataBill = billDetails["data"] as? [String: AnyObject] {
                    self.requestBill = HistoryRequestBill(dataBill)
                }
            }
            if let tripType = data["outstation_trip_type"] as? String {
                self.outStationTripType = tripType
            }
            
        }

    }
}

struct HistoryUser {
    var userProfilePicUrlStr: String?
    var userFirstName: String?
    var userLastName: String?
    
    init(_ dict: [String: AnyObject]) {
        if let userProfilePicUrlStr = dict["profile_pic"] as? String {
            self.userProfilePicUrlStr = userProfilePicUrlStr
        }
        if let userFirstName = dict["firstname"] as? String {
            self.userFirstName = userFirstName
        }
        if let userLastName = dict["lastname"] as? String {
            self.userLastName = userLastName
        }
    }
}

struct HistoryCar {
    var carModel: String?
    var carNumber: String?
    
    init(_ dict: [String: AnyObject]) {
        if let carModel = dict["car_model"] as? String {
            self.carModel = carModel
        }
        if let carNumber = dict["car_number"] as? String {
            self.carNumber = carNumber
        }
    }
}
    
struct HistoryRequestBill {
    var basePrice: String?
    var distancePrice: String?
    var timePrice: String?
    var waitingPrice: String?
    var promoPrice: String?
    var adminCommission: String?
    var serviceTax: String?
    var driverCommission: String?
    var cancellationFee: String?
    var hillFees: String?
    var outOfZoneFee: String?
    var total: String?
    var currency: String?
    var pricePerDistance: String?
    var totalDistance: String?
    var rentalRidePackageHour: String?
    var rentalRidePackageKm: String?
    var rentalRidePendingKm: String?
    
    init(_ dict: [String: AnyObject]) {
        if let currency = dict["requested_currency_symbol"] as? String {
            self.currency = currency
        }
        self.basePrice = dict.getInAmountFormat(str: "base_price")
        self.distancePrice = dict.getInAmountFormat(str: "distance_price")
        self.timePrice = dict.getInAmountFormat(str: "time_price")
        self.waitingPrice = dict.getInAmountFormat(str: "waiting_charge")
        self.promoPrice = dict.getInAmountFormat(str: "promo_discount")
        self.adminCommission = dict.getInAmountFormat(str: "admin_commision")
        self.serviceTax = dict.getInAmountFormat(str: "service_tax")
        self.driverCommission = dict.getInAmountFormat(str: "driver_commision")
        self.cancellationFee = dict.getInAmountFormat(str: "cancellation_fee")
        self.total = dict.getInAmountFormat(str: "total_amount")
        self.hillFees = dict.getInAmountFormat(str: "hill_station_price")
        self.outOfZoneFee = dict.getInAmountFormat(str: "out_of_zone_price")
        self.pricePerDistance = dict.getInAmountFormat(str: "price_per_distance")
        if let packageHrs = dict["package_hours"] {
            self.rentalRidePackageHour = "\(packageHrs)"
        }
        if let packagekm = dict["package_km"] {
            self.rentalRidePackageKm = "\(packagekm)"
        }
        if let pendingkm = dict["pending_km"] {
            self.rentalRidePendingKm = "\(pendingkm)"
        }
        if let totDist = dict["total_distance"] {
            self.totalDistance = "\(totDist)"
        }
    }
}
