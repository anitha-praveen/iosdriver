//
//  AppSocketManager.swift
//  TapNGo Driver
//
//  Created by Admin on 13/04/18.
//  Copyright © 2018 nPlus. All rights reserved.
//

import Foundation
import UIKit
import GeoFire
import SocketIO
import CoreLocation
import FirebaseAuth
import FirebaseDatabase
import CoreData
import GoogleMaps
// MARK: Adding Protocol in Socket Manager
@objc protocol MySocketManagerDelegate {
    @objc optional func driverRequestResponseReceived(_ response:[String:AnyObject])
    @objc optional func rideLocationChanged(_ response:[String:AnyObject])
    @objc optional func updateTripDistance(_ distance: String)
    @objc optional func serviceTypeChanged(_ distance: [String: AnyObject])
    @objc optional func passengerPhotoUploaded(_ response: [String: AnyObject])
    @objc optional func paymentCompleted(_ response: [String: AnyObject])
    @objc optional func paymentModeChanged(_ response: [String: AnyObject])
}

class MySocketManager: NSObject {
    
    static let shared = MySocketManager()
    
    var timer: Timer?
    var singleTripLocationTimer: Timer?

   
    #if DEBUG
//        var ref = Database.database(url: "https://development-db-a8581.firebaseio.com/").reference().child("drivers")
//        var requestRef = Database.database(url: "https://development-db-a8581.firebaseio.com/").reference().child("requests")
    
    var ref = Database.database().reference().child("drivers")
    var requestRef = Database.database().reference().child("requests")
    #else
        var ref = Database.database().reference().child("drivers")
        var requestRef = Database.database().reference().child("requests")
    #endif
    
   
    enum EmitType {
        case setLocation
        case singleTripLocation
        case shareTripLocation
        case none
    }

    weak var socketDelegate:MySocketManagerDelegate?

    var currentEmitType = EmitType.setLocation
    
    let manager = SocketManager(socketURL: APIHelper.shared.socketUrl, config: [.reconnects(true), .reconnectAttempts(-1)])
    var socket: SocketIOClient!
 
    private override init() {
        super.init()
        socket = manager.defaultSocket
     //   self.updateStatus()
    
    }
    
    func updateStatus() {
        if socket != nil {
            socket.on(clientEvent: .statusChange) { (dataArr, _) in
                guard let status = dataArr.first as? SocketIOStatus else {
                    return
                }
                
                switch status {
                case .connected:
                    print("socket connected")
                case .notConnected:
                    print("socket not connected")
                   // self.manager.reconnect()
                case .connecting:
                    print("socket connecting")
                case .disconnected:
                    print("socket disconnected")
                }
            }
        }
    }
    
    // MARK: connection updated
    func establishConnection() {
        print("trying to connect socket")
        
        self.socket.on("connect") { data, _ in
            print("socket connected")
            MySocketManager.shared.addObservers()

        }
        self.socket.connect()
    }
    
    // MARK: StartTimer
    func startTimer() {
        
        timer = Timer.scheduledTimer(withTimeInterval: 6, repeats: true) { timer in
            if MySocketManager.shared.currentEmitType == .setLocation {
                self.emitSetLocation()
            }
        }
    }
    
    func stopEmitTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    // MARK:  Call to Start Single Trip Location
    func startSingleTripLocation() {
        singleTripLocationTimer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true, block: { (timer) in
            if MySocketManager.shared.currentEmitType == .singleTripLocation {
                self.emitSingleTripLocation()
               
            }
        })
    }
    
    func stopSingleTripEmitTimer() {
        singleTripLocationTimer?.invalidate()
        singleTripLocationTimer = nil
    }
    
// MARK: Emit location Updated
    private func emitSetLocation() {
        
        guard let currentLocation = AppLocationManager.shared.locationManager.location else {
            return
        }
       
        guard let authId = LocalDB.shared.driverDetails?.id else {
            return
        }
       
        let heading = AppLocationManager.shared.currentHeading?.trueHeading ?? currentLocation.course

        let timeInMillis = Date().millisecondsSince1970
        let geoRef = GeoFire.init(firebaseRef: self.ref)
        
        //Random Numbers set (1 to 8)
        let randomNumString = "\(Int.random(in: 1...8))"
        
        //Current Location Round Up Set
        let currentLatSetLimit = currentLocation.coordinate.latitude.roundTo(places: 6)
        let currentLongSetLimit = currentLocation.coordinate.longitude.roundTo(places: 6)
        
        //Current Location RoundUp Lat & Long + Random Number
        let currLat = "\(currentLatSetLimit)" + randomNumString
        let currLong = "\(currentLongSetLimit)" + randomNumString
        
        guard let currLatitude = Double(currLat), let currLongitude = Double(currLong) else {
            return
        }
        
        geoRef.setLocation(CLLocation(latitude: currLatitude, longitude: currLongitude), forKey: authId) { (error) in
            if (error != nil) {
                print("An error occured: \(String(describing: error))")
            } else {
                var additionalData = [String: Any]()
                additionalData["bearing"] = heading
                additionalData["updated_at"] = timeInMillis
                additionalData["is_available"] = true
                self.ref.child(authId).updateChildValues(additionalData)
               // print("SOCKET UPDATE")
                
            }
            
        }
        
    }
    
    // MARK:Emit Single Trip Location
    private func emitSingleTripLocation() {
       
        guard let currentLocation = AppLocationManager.shared.locationManager.location, let id = LocalDB.shared.driverDetails?.id else {
            return
        }
        guard let authId = LocalDB.shared.driverDetails?.id else {
            return
        }
        let heading = AppLocationManager.shared.currentHeading?.trueHeading ?? currentLocation.course
        var jsonObject = [String:Any]()
        jsonObject["lat"] = currentLocation.coordinate.latitude
        jsonObject["lng"] = currentLocation.coordinate.longitude
        jsonObject["bearing"] = heading
        jsonObject["id"] = id
        jsonObject["request_id"] = LocalDB.shared.currentTripDetail?.acceptedRequestId
        jsonObject["user_id"] = LocalDB.shared.currentTripDetail?.customerDetails.id
        jsonObject["trip_start"] = (LocalDB.shared.currentTripDetail?.requestIsTripStarted ?? false) ? 1 : 0

        if LocalDB.shared.currentTripDetail?.choosenServiceCatagory == "RENTAL" {
            if LocalDB.shared.currentTripDetail?.requestIsTripStarted == true {
                jsonObject["rental_trip_time"] = RentalTripTimeHandler.shared.rentalTripTimeLabelFormat
            }
        } else {
            if LocalDB.shared.currentTripDetail?.requestIsDriverArrived == true {
                jsonObject["waiting_time"] = WaitingTimeHandler.shared.waitingTimeServerFormat
            }
        }

        if LocalDB.shared.currentTripDetail?.requestIsTripCompleted == true {
            jsonObject["driver_trip_status"] = 3
        } else if LocalDB.shared.currentTripDetail?.requestIsTripStarted == true {
            jsonObject["driver_trip_status"] = 2
        } else if LocalDB.shared.currentTripDetail?.requestIsDriverArrived == true {
            jsonObject["driver_trip_status"] = 1
        } else if LocalDB.shared.currentTripDetail?.isDriverStarted == true {
            jsonObject["driver_trip_status"] = 0
        }

        let latLngArray = AppLocationManager.shared.locationArray.map({ (lat,lng) in
            [lat.key:lat.value,lng.key:lng.value]
        })
        let requestId = LocalDB.shared.currentTripDetail?.acceptedRequestId ?? ""
        let tripRef = self.requestRef.child("\(requestId)")
        if ConnectionCheck.isConnectedToNetwork() {
           
            tripRef.observeSingleEvent(of: .value, with: { (snapshot) in
                let value = snapshot.value as? [String: Any]
                var distArr = [[String: Any]]()
                if value != nil {
                    if let firebaseLatLngArray = value!["lat_lng_array"] {
                        var remoteLatLngArray = firebaseLatLngArray as? [[String: Any]]
                        
                        let localArray = self.fetchDataFromCoreData((LocalDB.shared.currentTripDetail?.acceptedRequestId ?? ""))
                        if localArray.count > 0 {
                            localArray.forEach({
                                let lat = $0["lat"] as? Double
                                let lng = $0["lng"] as? Double
                                if !self.isValueExists(remoteLatLngArray!, key: "lat", val: lat!) && !self.isValueExists(remoteLatLngArray!, key: "lng", val: lng!) {
                                    remoteLatLngArray?.append($0)
                                }
                            })
                        }
                        
                        if latLngArray.count > 0 {
                            let latLngLast = latLngArray[latLngArray.count - 1]
                            let lat = latLngLast["lat"] as? Double
                            let lng = latLngLast["lng"] as? Double
                            
                            if !self.isValueExists(remoteLatLngArray!, key: "lat", val: lat!) && !self.isValueExists(remoteLatLngArray!, key: "lng", val: lng!) {
                                remoteLatLngArray?.append(latLngLast)
                            }
                        }
                        jsonObject["lat_lng_array"] = remoteLatLngArray
                        distArr = remoteLatLngArray!
                    } else {
                        jsonObject["lat_lng_array"] = latLngArray
                        distArr = latLngArray
                    }
                } else {
                    jsonObject["lat_lng_array"] = latLngArray
                    distArr = latLngArray
                }
                
                jsonObject["success"] = true
                jsonObject["distancee"] = self.getDistanceFrom(distArr)
                
                
                if let id = LocalDB.shared.currentTripDetail?.acceptedRequestId {
                    self.requestRef.child(id).updateChildValues(jsonObject, withCompletionBlock: { error, ref in
                        if error == nil {
                            if let reqId = LocalDB.shared.currentTripDetail?.acceptedRequestId {
                                self.deleteLocalData(reqId)
                            }
                            /* Set driver status as not available */
                            var additionalData = [String: Any]()
                            additionalData["is_available"] = false
                            self.ref.child(authId).updateChildValues(additionalData)
                        }
                    })
                }
                
            })
        } else {
           
            saveToCoreData((LocalDB.shared.currentTripDetail?.acceptedRequestId)!)
        }
    }
    
    private func fetchDataFromCoreData(_ requestId: String) -> [[String: Any]] {
        var coreDataArray = [[String: Any]]()

        let managedObjectContext = LocalDB.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "OfflineData")
        let predicate = NSPredicate(format: "request_id == %@", requestId)
        fetchRequest.predicate = predicate
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            if results.count > 0 {
                coreDataArray = (results[0] as AnyObject).value(forKey: "lat_lng_array") as! [[String: Any]]
            }
        } catch {
            print(error)
        }

        return coreDataArray
    }
    private func deleteLocalData(_ requestId: String) {
        let managedObjectContext = LocalDB.shared.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "OfflineData")
        let predicate = NSPredicate(format: "request_id == %@", requestId)
        fetchRequest.predicate = predicate
        do {
            let results = try managedObjectContext.fetch(fetchRequest)
            if results.count > 0 {
                let objectToDelete = results[0] as! NSManagedObject
                managedObjectContext.delete(objectToDelete)

                do {
                    try managedObjectContext.save()
                    print("Core data deleted")
                } catch {
                    print(error.localizedDescription)
                }
            }
        } catch {
            print(error.localizedDescription)
        }
    }
    
    private func saveToCoreData(_ requestId: String) {
        let latLngArray = AppLocationManager.shared.locationArray.map({ (lat,lng) in
            [lat.key:lat.value,lng.key:lng.value]
        })
        if latLngArray.count > 0 {
            let latLngLast = latLngArray[latLngArray.count - 1]
            let lat = latLngLast["lat"] as? Double
            let lng = latLngLast["lng"] as? Double

            let managedObjectContext = LocalDB.shared.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: "OfflineData")
            let predicate = NSPredicate(format: "request_id == %@", requestId)
            fetchRequest.predicate = predicate
            do {
                let results = try managedObjectContext.fetch(fetchRequest)
                var data = [[String: Any]]()
                if results.count > 0 {
                    let objectToUpdate = results[0] as! NSManagedObject
                    data = (results[0] as AnyObject).value(forKey: "lat_lng_array") as! [[String: Any]]
                    if !self.isValueExists(data, key: "lat", val: lat!) && !self.isValueExists(data, key: "lng", val: lng!) {
                        data.append(latLngLast)
                    }

                    objectToUpdate.setValue(data, forKey: "lat_lng_array")

                    do {
                        try managedObjectContext.save()
                        print("Core data updated")
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                } else {
                    data.append(latLngLast)

                    let table = NSEntityDescription.entity(forEntityName: "OfflineData", in: managedObjectContext)
                    let newData = NSManagedObject(entity: table!, insertInto: managedObjectContext)

                    newData.setValue(requestId, forKey: "request_id")
                    newData.setValue(data, forKey: "lat_lng_array")

                    do {
                        try managedObjectContext.save()
                        print("Core data saved")
                    } catch let error as NSError {
                        print(error.localizedDescription)
                    }
                }
            } catch {
                print(error)
            }
        }
    }
    private func isValueExists(_ arr: [[String: Any]], key: String, val: Double) -> Bool {
        var isExists = false
        for e in arr {
            let valInArr = e[key] as? Double
            if valInArr == val {
                return true
            } else {
                isExists = false
            }
        }
        return isExists
    }
    
}

extension MySocketManager {
    func getDistanceFrom(_ latLngArray: [[String: Any]]) -> Double {
        let path = GMSMutablePath()
        latLngArray.forEach({
            if let lat = $0["lat"] as? Double,
                let lng = $0["lng"] as? Double {
                let location = CLLocationCoordinate2D.init(latitude: lat, longitude: lng)
                path.add(location)
            }

        })
        let distanceInKm = GMSGeometryLength(path) / 1000.0

        DispatchQueue.main.async {
            self.socketDelegate?.updateTripDistance?(String(format: "%.2f", distanceInKm))
        }

        return distanceInKm
    }
}


//MARK:-  Socket Manager (OBSERVERS)
extension MySocketManager {
    func addObservers() {
        guard let driverId = LocalDB.shared.driverDetails?.id else {
            return
        }
        print("request_\(driverId)")
        self.socket.on("request_\(driverId)") { data, _ in
            guard let response = data.first as? [String:AnyObject] else {
                return
            }
            DispatchQueue.main.async {
               
                self.socketDelegate?.driverRequestResponseReceived?(response)
            }
        }
        self.socket.on("locationchanged_\(driverId)") { data, _ in
            guard let response = data.first as? [String:AnyObject] else {
                return
            }
            DispatchQueue.main.async {
               
                self.socketDelegate?.rideLocationChanged?(response)
            }
        }
        self.socket.on("package_changed_\(driverId)") { data, _ in
            guard let response = data.first as? [String:AnyObject] else {
                return
            }
            DispatchQueue.main.async {
               
                self.socketDelegate?.serviceTypeChanged?(response)
            }
        }
        self.socket.on("photo_upload_\(driverId)") { data, _ in
            guard let response = data.first as? [String:AnyObject] else {
                return
            }
            DispatchQueue.main.async {
               
                self.socketDelegate?.passengerPhotoUploaded?(response)
            }
        }
        self.socket.on("payment_done_\(driverId)") { data, _ in
            guard let response = data.first as? [String:AnyObject] else {
                return
            }
            DispatchQueue.main.async {
               
                self.socketDelegate?.paymentCompleted?(response)
            }
        }
        self.socket.on("payment_changed_\(driverId)") { data, _ in
            guard let response = data.first as? [String:AnyObject] else {
                return
            }
            DispatchQueue.main.async {
               
                self.socketDelegate?.paymentModeChanged?(response)
            }
        }
    }
}


