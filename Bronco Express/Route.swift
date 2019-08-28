//
//  Route.swift
//  Bronco Express
//
//  Created by Christian Valera on 12/8/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import Foundation

struct Route: Codable {
  let id: Int
  let arrivalsEnabled: Bool
  let displayName: String
  let customerID: Int
  let color: String
  let textColor: String
  let arrivalsShowVehicleNames: Bool
  let isHeadway: Bool
  let showLine: Bool
  let name: String
  let shortName: String
  let forwardDirectionName: String
  let backwardDirectionName: String
  let numberOfVehicles: Int
  
  enum CodingKeys: String, CodingKey {
    case id = "ID"
    case arrivalsEnabled = "ArrivalsEnabled"
    case displayName = "DisplayName"
    case customerID = "CustomerID"
    case color = "Color"
    case textColor = "TextColor"
    case arrivalsShowVehicleNames = "ArrivalsShowVehicleNames"
    case isHeadway = "IsHeadway"
    case showLine = "ShowLine"
    case name = "Name"
    case shortName = "ShortName"
    case forwardDirectionName = "ForwardDirectionName"
    case backwardDirectionName = "BackwardDirectionName"
    case numberOfVehicles = "NumberOfVehicles"
  }
}
