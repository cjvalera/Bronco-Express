//
//  Vehicle.swift
//  Bronco Express
//
//  Created by Christian Valera on 2/5/19.
//  Copyright © 2019 cjvalera. All rights reserved.
//

import Foundation

struct Vehicle: Codable {
    let id: Int
    let apcPercentage: Int
    let routeID: Int
    let patternID: Int
    let name: String
    let hasAPC: Bool
    let iconPrefix: String
    let doorStatus: Int
    let latitude: Double
    let longitude: Double
    let coordinate: Coordinate
    let speed: Int
    let heading: String
    let updated: String
    let updatedAgo: String
    
    enum CodingKeys: String, CodingKey {
        case id = "ID"
        case apcPercentage = "APCPercentage"
        case routeID = "RouteId"
        case patternID = "PatternId"
        case name = "Name"
        case hasAPC = "HasAPC"
        case iconPrefix = "IconPrefix"
        case doorStatus = "DoorStatus"
        case latitude = "Latitude"
        case longitude = "Longitude"
        case coordinate = "Coordinate"
        case speed = "Speed"
        case heading = "Heading"
        case updated = "Updated"
        case updatedAgo = "UpdatedAgo"
    }
}

struct Coordinate: Codable {
    let latitude: Double
    let longitude: Double
    
    enum CodingKeys: String, CodingKey {
        case latitude = "Latitude"
        case longitude = "Longitude"
    }
}
