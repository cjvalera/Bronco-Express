//
//  Stop.swift
//  Bronco Express
//
//  Created by Christian Valera on 12/9/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import Foundation
import MapKit

class Stop: NSObject, Codable, MKAnnotation {

    let id: Int
    let latitude: Double
    let longitude: Double
    let name: String
    let rtpiNumber: Int
    let showLabel: Bool
    let showStopRtpiNumberLabel: Bool
    let showVehicleName: Bool
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case name = "Name"
        case rtpiNumber = "RtpiNumber"
        case showLabel = "ShowLabel"
        case showStopRtpiNumberLabel = "ShowStopRtpiNumberLabel"
        case showVehicleName = "ShowVehicleName"
    }
    
    var coordinate : CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    var title: String? {
        return name
    }
    
    var location : CLLocation {
        return CLLocation(latitude: latitude, longitude: longitude)
    }
    
    var subtitle: String?
    
}

struct Waypoint: Codable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
}
