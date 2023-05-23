//
//  LocalDB.swift
//  Taxiappz Driver
//
//  Created by Apple on 05/01/22.
//  Copyright © 2022 nPlus. All rights reserved.
//

import UIKit
import CoreData
import GoogleMaps

protocol LogoutDelegate {
    func logedOut()
}

class LocalDB: NSObject {

    static let shared = LocalDB()
    
    var driverDetails: DriverDetails?
    var currentTripDetail: TripDetail?
    
    var isSubscriptionEnabled = false
    
    var profilePictureData: Data?
    
    var delegate: LogoutDelegate?
    
    // MARK: - Core Data Saving support
    var context: NSManagedObjectContext {
        return self.persistentContainer.viewContext
    }
    lazy var persistentContainer: NSPersistentContainer = {
      
        let container = NSPersistentContainer(name: "DriverDetails")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
        
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    static var arrivalPath: String {
        get {
            return UserDefaults.standard.string(forKey: "arrivalPath") ?? ""
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "arrivalPath")
            UserDefaults.standard.synchronize()
        }
    }
}

extension LocalDB {
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
              
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func fetchUsers() {
        let fetchRequest: NSFetchRequest<DriverDetail> = DriverDetail.fetchRequest()
        do {
            let users = try persistentContainer.viewContext.fetch(fetchRequest)
            if let user = users.first {
                self.driverDetails = DriverDetails(user)
                
            } else {
                print("0 or more than one object found")
            }
        } catch {
            print("Error with request: \(error)")
        }
        
    }
    
    func deleteUser() {
        do {
            let context = LocalDB.shared.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "DriverDetail")
            do {
                let objects  = try context.fetch(fetchRequest) as? [NSManagedObject]
                _ = objects.map{$0.map{context.delete($0)}}
                try context.save()
                self.driverDetails = nil
                MySocketManager.shared.stopEmitTimer()
                MySocketManager.shared.stopSingleTripEmitTimer()
                MySocketManager.shared.socket.disconnect()
                AppLocationManager.shared.stopTracking()
                delegate?.logedOut()
                print("Deleted!")
                UserDefaults.standard.removeObject(forKey: "currentLanguage")
                RJKLocalize.shared.details = [:]
            }
            catch let error {
                print("ERROR DELETING : \(error)")
            }
        }
    }
    
    func updateUserDetails(_ userDetails:[String:AnyObject]) {
        let fetchRequest: NSFetchRequest<DriverDetail> = DriverDetail.fetchRequest()
        do {
            let users = try self.persistentContainer.viewContext.fetch(fetchRequest)
            if let user = users.first {
                self.storeUserDetails(userDetails, currentUser: user)
            } else {
                print("No users found or multiple user details found")
            }
        }
        catch let error {
            print("ERROR  : \(error)")
        }
    }
    
    func storeUserDetails(_ userDetailsDic: [String:AnyObject], currentUser:DriverDetail?) {
        
        let context = LocalDB.shared.persistentContainer.viewContext
        let userObj = currentUser ?? DriverDetail(context: context)
        
        
        
        if let profilePictureUrl = userDetailsDic["profile_pic"] as? String {
            userObj.profilePicture = profilePictureUrl
        }
        if let firstName = userDetailsDic["firstname"] as? String {
            userObj.firstName = firstName
        }
        if let id = userDetailsDic["slug"] as? String {
            userObj.id = id
        }
        if let lastName = userDetailsDic["lastname"] as? String {
            userObj.lastName = lastName
        }
        if let firstName = userDetailsDic["firstname"] as? String,let lastName = userDetailsDic["lastname"] as? String  {
            userObj.name = firstName + " " + lastName
        }
        if let email = userDetailsDic["email"] as? String {
            userObj.email = email
        }
        if let phone = userDetailsDic["phone_number"] as? String {
            userObj.phoneNumber = phone
        }
        if let accessToken = userDetailsDic["access_token"] as? String {
            userObj.accessToken = accessToken
        }

        do {
            try context.save()
            self.fetchUsers()
        } catch let error as NSError {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
            
        }
    }
    
}

struct DriverDetails {
    
    var name: String?
    var email: String?
    var firstName: String?
    var id: String?
    var lastName: String?
    var phone: String?
    var profilePictureUrl: String?
    var accessToken: String?
    
    init(_ object: DriverDetail) {
        self.name = object.value(forKey: "name") as? String
        self.email = object.value(forKey: "email") as? String
        self.firstName = object.value(forKey: "firstName") as? String
        self.id = object.value(forKey: "id") as? String
        self.lastName = object.value(forKey: "lastName") as? String
        self.phone = object.value(forKey: "phoneNumber") as? String
        self.profilePictureUrl = object.value(forKey: "profilePicture") as? String
        self.accessToken = object.value(forKey: "accessToken") as? String
    }
}


// MARK: Trip Details
struct TripDetail {
    struct Customer {
        var email: String?
        var firstName: String?
        var id: String?
        var lastName: String?
        var phoneNumber: String?
        var profilePicture: String?
        var review: String?
    }
    struct Bill {
        var baseDistance: String?
        var basePrice: String?
        var currency: String?
        var distanceCost: String?
        var driverCommision: String?
        var pricePerDistance: String?
        var pricePerTime: String?
        var promoBonus: String?
        var timeCost: String?
        var totalAmount: String?
        var waitingCost: String?
        var adminCommission: String?
        var cancellationFee: String?
        var conversion: String?
        
    }
    var customerDetails = Customer()
    var billDetails = Bill()
    
    var acceptedRequestId: String?
    var requestNumber: String?
    var isDriverStarted: Bool?
    var requestIsDriverArrived: Bool?
    var requestIsTripAccepted: Bool?
    var requestIsTripCancelled: Bool?
    var requestIsTripCompleted: Bool?
    var requestIsTripStarted: Bool?
    var tripDistance: String?
    var unit: String?
    var tripTime: String?
    var driverNotes: String?

    var choosenServiceCatagory: String?
    var dropLatitude: Double?
    var dropLongitude: Double?
    var dropLocation: String?
    var paymentOpt: String?
    var isPaid: Bool?
    var pickLatitude: Double?
    var pickLongitude: Double?
    var pickLocation: String?
    var tripStartTime: String?
    var isInstantTrip: Bool?
    var userRating: Double?
    var minimumSpeed:Double?
    var waitingGraceTime: Double?
    
    var needLocationApprove: Bool?
    
    var pathToDestination: String?
    
    var reqestStopAddress: String?
    var reqestStopLat: Double?
    var reqestStopLong: Double?
    
    var instantPhoneNumber: String?
    var ifDipatch: Bool?
    var otherPersonPhoneNumber: String?
    
    var nytTimeDriverPhotoUploaded: Bool?
    var nytTimeUserPhotoUploaded: Bool?
    var isNytTimePhotoSkipped: Bool?
    var nytTimeUserPhotoUrl: String?
    var nytStartTime: String?
    var nytEndTime: String?

    init(tripDetails: [String: Any]) {
        
        self.tripTime = tripDetails.getInAmountFormat(str: "total_time")
        self.tripDistance = tripDetails.getInAmountFormat(str: "total_distance")
        
        self.choosenServiceCatagory = tripDetails["service_category"] as? String
        if let picklat = tripDetails["pick_lat"] {
            self.pickLatitude = Double("\(picklat)")
        }
        if let pickLong = tripDetails["pick_lng"] {
            self.pickLongitude = Double("\(pickLong)")
        }
        self.pickLocation = tripDetails["pick_address"] as? String
        self.dropLatitude = tripDetails["drop_lat"] as? Double
        self.dropLongitude = tripDetails["drop_lng"] as? Double
        self.dropLocation = tripDetails["drop_address"] as? String
        
        self.isDriverStarted = tripDetails["is_driver_started"] as? Bool
        self.requestIsDriverArrived = tripDetails["is_driver_arrived"] as? Bool
        self.requestIsTripStarted = tripDetails["is_trip_start"] as? Bool
        self.requestIsTripCompleted = tripDetails["is_completed"] as? Bool
        
        self.instantPhoneNumber = tripDetails["instant_phone_number"] as? String
        self.ifDipatch = tripDetails["if_dispatch"] as? Bool
        
        if let notes = tripDetails["driver_notes"] as? String {
            self.driverNotes = notes
        }
        
        if let requestID = tripDetails["id"] {
            self.acceptedRequestId = "\(requestID)"
        }
        self.requestNumber = tripDetails["request_number"] as? String
        self.paymentOpt = tripDetails["payment_opt"] as? String
        if let ispaid = tripDetails["is_paid"] as? Bool {
            self.isPaid = ispaid
        }
        self.tripStartTime = tripDetails["trip_start_time"] as? String
        self.unit = tripDetails["unit"] as? String
        if let rating = tripDetails["user_overall_rating"] {
            self.userRating = Double("\(rating)")
        }
        if let waitingGraceTime = tripDetails["grace_waiting_time"] {
            self.waitingGraceTime = Double("\(waitingGraceTime)")
        }
        if let reqestStopList = tripDetails["stops"] as? [String: AnyObject] {
            if let reqestStopAddress = reqestStopList["address"] as? String {
                self.reqestStopAddress = reqestStopAddress
            }
            if let reqestStopLat = reqestStopList["latitude"] as? Double {
                self.reqestStopLat = reqestStopLat
            }
            if let reqestStopLong = reqestStopList["longitude"] as? Double {
                self.reqestStopLong = reqestStopLong
            }
        }
        
        if let minSpeed = tripDetails["minimum_speed_limit"] as? Double {
            self.minimumSpeed = minSpeed
        }
        if let locApprove = tripDetails["location_approve"] as? Bool {
            self.needLocationApprove = locApprove
        }
        if let polyString = tripDetails["poly_string"] as? String {
            self.pathToDestination = polyString
        }
        
        self.isInstantTrip = tripDetails["is_instant_trip"] as? Bool
        
        if let others = tripDetails["others"] as? [String: AnyObject] {
            if let number = others["phone_number"] as? String {
                self.otherPersonPhoneNumber = number
            }
        }
        
        if let driverPhotoUploaded = tripDetails["driver_upload_image"] as? Bool {
            self.nytTimeDriverPhotoUploaded = driverPhotoUploaded
        }
        if let userPhotoUploaded = tripDetails["user_upload_image"] as? Bool {
            self.nytTimeUserPhotoUploaded = userPhotoUploaded
        }
        if let skipped = tripDetails["skip_night_photo"] as? Bool {
            self.isNytTimePhotoSkipped = skipped
        }
        if let userPhoto = tripDetails["night_photo_user"] as? String {
            self.nytTimeUserPhotoUrl = userPhoto
        }
        if let nytstarttime = tripDetails["start_night_time"] as? String {
            self.nytStartTime = String(nytstarttime.prefix(2))
        }
        if let nytendtime = tripDetails["end_night_time"] as? String {
            self.nytEndTime = String(nytendtime.prefix(2))
        }
        
        if let customerDetails = tripDetails["user"] as? [String: Any] {
            self.customerDetails.email = customerDetails["email"] as? String
            self.customerDetails.firstName = customerDetails["firstname"] as? String
            self.customerDetails.id = customerDetails["id"] as? String
            self.customerDetails.lastName = customerDetails["lastname"] as? String
            self.customerDetails.phoneNumber = customerDetails["phone_number"] as? String
            self.customerDetails.profilePicture = customerDetails["profile_pic"] as? String
        }
        
        
        if let billRequest = tripDetails["requestBill"] as? [String: AnyObject] {
            if let billDetails = billRequest["data"] as? [String: Any] {
                self.billDetails.adminCommission = billDetails.getInAmountFormat(str: "admin_commision")
                self.billDetails.baseDistance = billDetails.getInAmountFormat(str: "base_distance")
                self.billDetails.basePrice = billDetails.getInAmountFormat(str: "base_price")
                self.billDetails.cancellationFee = billDetails.getInAmountFormat(str: "cancellation_fee")
                self.billDetails.distanceCost = billDetails.getInAmountFormat(str: "distance_price")
                self.billDetails.driverCommision = billDetails.getInAmountFormat(str: "driver_commision")
                self.billDetails.pricePerDistance = billDetails.getInAmountFormat(str: "price_per_distance")
                self.billDetails.pricePerTime = billDetails.getInAmountFormat(str: "price_per_time")
                self.billDetails.promoBonus = billDetails.getInAmountFormat(str: "promo_discount")
                self.billDetails.currency = billDetails["requested_currency_symbol"] as? String
                self.billDetails.timeCost = billDetails.getInAmountFormat(str: "time_price")
                self.billDetails.totalAmount = billDetails.getInAmountFormat(str: "total_amount")
                self.billDetails.waitingCost = billDetails.getInAmountFormat(str: "waiting_charge")
                self.billDetails.conversion = billDetails["conversion"] as? String
            }
        }
    }
}
struct RequestStops {
    
    var id: String?
    var latitude: Double?
    var longitude: Double?
    var address: String?
    var coordinate: CLLocationCoordinate2D?

    init(_ dict:[String:AnyObject]) {

        if let id = dict["id"] {
            self.id = "\(id)"
        }
        if let latitude = dict["latitude"] as? Double {
            self.latitude = latitude
        }
        if let longitude = dict["longitude"] as? Double {
            self.longitude = longitude
        }
        if let address = dict["address"] as? String {
            self.address = address
        }
        if let lat = self.latitude, let long = self.longitude {
            self.coordinate = CLLocationCoordinate2D(latitude: lat, longitude: long)
        }
    }
}
