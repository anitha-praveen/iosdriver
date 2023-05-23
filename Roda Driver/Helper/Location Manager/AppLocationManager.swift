//
//  AppLocationManager.swift
//  TapNGo Driver
//
//  Created by Admin on 12/04/18.
//  Copyright © 2018 nPlus. All rights reserved.
//

import Foundation
import CoreLocation
import UIKit
import Alamofire

@objc protocol AppLocationManagerDelegate {
    func appLocationManager(didUpdateLocations locations: [CLLocation])
    @objc optional func applocationManager(didChangeAuthorization status: CLAuthorizationStatus)
    @objc optional func appLocationManager(didUpdateHeading newHeading: CLHeading)

}

class AppLocationManager: NSObject, CLLocationManagerDelegate {
    
    static let shared = AppLocationManager()
    
    var delegate = MulticastDelegate<AppLocationManagerDelegate>()
    
    var locationManager:CLLocationManager = CLLocationManager()
    var currentHeading: CLHeading?

    typealias locArray = ((key: String, value: Any),(key: String, value: Any))
    var locationArray = [locArray]()
    
    private override init() {
        super.init()
        locationManager.delegate = self
        locationManager.distanceFilter = 10
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.pausesLocationUpdatesAutomatically = false
        locationManager.showsBackgroundLocationIndicator = false
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
    }
    
    func startTracking() {
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    func stopTracking() {
        locationManager.stopUpdatingHeading()
        locationManager.stopUpdatingLocation()
    }
    func locationManagerDidPauseLocationUpdates(_ manager: CLLocationManager) {
        print("locationManagerDidPauseLocationUpdates")
    }
    func locationManagerDidResumeLocationUpdates(_ manager: CLLocationManager) {
        print("locationManagerDidResumeLocationUpdates")
    }
    func locationManager(_ manager: CLLocationManager, didVisit visit: CLVisit) {
        print("locationManager didVisit")
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("locationManager didFailWithError")
    }
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        print("locationManager didExitRegion")
    }
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        print("locationManager didEnterRegion")
    }
    func locationManagerShouldDisplayHeadingCalibration(_ manager: CLLocationManager) -> Bool {
        print("locationManagerShouldDisplayHeadingCalibration")
        return false
    }
    func locationManager(_ manager: CLLocationManager, didStartMonitoringFor region: CLRegion) {
        print("locationManager didStartMonitoringFor")
    }
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {        
        self.currentHeading = newHeading
        delegate.invoke(invocation: { $0.appLocationManager?(didUpdateHeading: newHeading) })
    }
    
    // MARK:Update Location 
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print("didUpdateLocations")
        delegate.invoke(invocation: { $0.appLocationManager(didUpdateLocations: locations) })
        guard let location = locations.last else {
            return
        }
         if LocalDB.shared.currentTripDetail?.requestIsTripStarted ?? false {
            locationArray.append(((key: "lat", value: location.coordinate.latitude),(key: "lng", value: location.coordinate.longitude)))
        }
    }
    func locationManager(_ manager: CLLocationManager, didFinishDeferredUpdatesWithError error: Error?) {
        print("locationManager didFinishDeferredUpdatesWithError")
    }
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        delegate.invoke(invocation: { $0.applocationManager?(didChangeAuthorization: status)})
        print("locationManager didChangeAuthorization")
    }
    func locationManager(_ manager: CLLocationManager, didDetermineState state: CLRegionState, for region: CLRegion) {
        print("locationManager didDetermineState")
    }
    func locationManager(_ manager: CLLocationManager, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        print("locationManager didRangeBeacons")
    }
    func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
        print("locationManager monitoringDidFailFor")
    }
    func locationManager(_ manager: CLLocationManager, rangingBeaconsDidFailFor region: CLBeaconRegion, withError error: Error) {
        print("locationManager rangingBeaconsDidFailFor")
    }

}


extension UIViewController {
    
    func getaddress(_ position:CLLocationCoordinate2D,completion:@escaping (String)->()) {
        let userLocation = CLLocation(latitude: position.latitude, longitude: position.longitude)
        CLGeocoder().reverseGeocodeLocation(userLocation, completionHandler: { placemarks, _ in
            if let placeArray = placemarks, !placeArray.isEmpty {
                if let placemark = placemarks?.first {
                    let outputString = [placemark.subThoroughfare,
                                        placemark.thoroughfare,
                                        placemark.subLocality,
                                        placemark.locality,
                                        placemark.postalCode,
                                        placemark.country].compactMap { $0 }.joined(separator: ", ")
                    completion(outputString)
                }
            } else {
                self.getaddressFromGoogle(position, completion: { address in
                    completion(address)
                })
            }
        })
    }
    func getaddressFromGoogle(_ position:CLLocationCoordinate2D,completion:@escaping (String)->()) {
        if ConnectionCheck.isConnectedToNetwork() {
           
            let queryItems = [URLQueryItem(name: "latlng", value: "\(position.latitude),\(position.longitude)"),URLQueryItem(name: "key", value: APIHelper.shared.gmsServiceKey)]
           
            let url = APIHelper.googleApiComponents.googleURLComponents("/maps/api/geocode/json", queryItem: queryItems)
        
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.header)
                .responseJSON { response in
                  
                    print(response.result.value as AnyObject)
                   
                    if let result = response.result.value as? [String:AnyObject] {
                        if let status = result["status"] as? String, status == "OK" {
                            if let results = result["results"] as? [[String:AnyObject]] {
                                print(results)
                                if let result = results.first {
                                    print(result)
                                    if let address = result["formatted_address"] as? String {
                                        completion(address)
                                    }
                                }
                            }
                        }
                    }
            }
        }
    }
    
    func getCoordinates(_ address:String,placeId: String,completion:@escaping (CLLocationCoordinate2D)->()) {
        let gCoder = CLGeocoder()
        gCoder.geocodeAddressString(address) { (placeMarks, error) in
            if error != nil {
                self.getCoordFromGoogle(placeId) { (location) in
                    completion(location)
                }
            } else {
                if let placeMarks = placeMarks, !placeMarks.isEmpty {
                    if let coord = placeMarks.first?.location?.coordinate {
                        completion(coord)
                    }
                } else {
                    self.getCoordFromGoogle(placeId) { (location) in
                        completion(location)
                    }
                }
            }
        }
    }
    
    func getCoordFromGoogle(_ placeId:String,completion:@escaping (CLLocationCoordinate2D)->()) {
        if ConnectionCheck.isConnectedToNetwork() {
            
            let queryItem = [URLQueryItem(name: "place_id", value: "\(placeId)"),
                             URLQueryItem(name: "key", value: APIHelper.shared.gmsServiceKey)]
            let url = APIHelper.googleApiComponents.googleURLComponents("/maps/api/geocode/json", queryItem: queryItem)
            print(url)
            Alamofire.request(url, method: .get, parameters: nil, headers: APIHelper.shared.header)
                .responseJSON { response in
                    print(response.result.value as AnyObject)   // result of response serialization
                    if let result = response.result.value as? [String:AnyObject] {
                        if let status = result["status"] as? String, status == "OK" {
                            if let results = result["results"] as? [[String:AnyObject]] {
                                print(results)
                                if let result = results.first {
                                    print(result)
                                    if let geo = result["geometry"] as? [String:AnyObject],let loc = geo["location"]as? [String:AnyObject] {
                                        if let lat = loc["lat"] as? Double,let long = loc["lng"] as? Double {
                                            let coord = CLLocationCoordinate2D(latitude: lat, longitude: long)
                                                completion(coord)
                                        }
                                    }
                                }
                            }
                        }
                    }
            }
        } else {
            print("disConnected")
        }
    }
}
