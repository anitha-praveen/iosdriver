//
//  SearchLocationModel.swift
//  Roda Driver
//
//  Created by NPlus Technologies on 06/05/22.
//

import Foundation
import GoogleMaps
// MARK: - Common Model for Favourite & Google Search Location

struct SearchLocation:Equatable {
    static func == (lhs: SearchLocation, rhs: SearchLocation) -> Bool {
        return lhs.id == rhs.id && lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude && lhs.nickName == rhs.nickName && lhs.placeId == rhs.placeId && lhs.googlePlaceId == rhs.googlePlaceId
    }
    var coordinate: CLLocationCoordinate2D {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    var id: Int!
    var latitude:Double!
    var longitude:Double!
    var nickName: String!
    var placeId: String!
    var googlePlaceId: String!
    var locationType:LocationType!

    init(_ dict: [String:AnyObject]) {
        self.id = dict["id"] as? Int
        if let latitude = dict["latitude"] as? Double {
            self.latitude = latitude
        }
        if let longitude = dict["longitude"] as? Double {
            self.longitude = longitude
        }
        self.nickName = dict["nickName"] as? String
        self.placeId = dict["placeId"] as? String
        self.locationType = .favourite
    }

    init(_ googlePlaceId: String,title: String,address: String) {
        self.googlePlaceId = googlePlaceId
        self.nickName = title
        self.placeId = address
        self.locationType = .googleSearch
    }
    init(_ target:CLLocationCoordinate2D) {
        self.latitude = target.latitude
        self.longitude = target.longitude
        self.locationType = .reverseGeoCode
    }
}
enum LocationType {
    case favourite
    case googleSearch
    case reverseGeoCode
}
