//
//  Stop.swift
//  Bronco Express
//
//  Created by Christian Valera on 12/9/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import Foundation

struct Stop: Codable {
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
}
