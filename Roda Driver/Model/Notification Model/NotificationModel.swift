//
//  NotificationModel.swift
//  Taxiappz Driver
//
//  Created by Apple on 11/03/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import Foundation

extension Notification.Name {
    static let newRideRequest = NSNotification.Name("request_created")
    static let tripLocationChanged = NSNotification.Name("trip_location_changed")
    static let localToRental = NSNotification.Name("localToRental")
    static let driverApproved = NSNotification.Name("Driver approved")
    static let driverDeclined = NSNotification.Name("Driver declined")
    static let paymentModeChanged = NSNotification.Name("paymentModeChanged")
    static let paymentCompleted = NSNotification.Name("paymentCompleted")
    
}
