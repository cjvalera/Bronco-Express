//
//  Arrival.swift
//  Bronco Express
//
//  Created by Christian Valera on 12/10/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import Foundation

struct Arrival: Codable {
  let routeID: Int
  let stopID: Int
  let vehicleID: Int
  let arrivalStopID: Int
  let arrivalVehicleID: Int
  let arriveTime: String
  let arrivalRouteID: Int
  let direction: Int
  let schedulePrediction: Bool
  let isLayover: Bool
  let secondsToArrival: Double
  let isLastStop: Bool
  let onBreak: Bool
  let scheduledMinutes: Int
  let busName: String
  let vehicleName: String
  let routeName: String
  let minutes: Int
  let time: String
  
  enum CodingKeys: String, CodingKey {
    case routeID = "RouteID"
    case stopID = "StopID"
    case vehicleID = "VehicleID"
    case arrivalStopID = "StopId"
    case arrivalVehicleID = "VehicleId"
    case arriveTime = "ArriveTime"
    case arrivalRouteID = "RouteId"
    case direction = "Direction"
    case schedulePrediction = "SchedulePrediction"
    case isLayover = "IsLayover"
    case secondsToArrival = "SecondsToArrival"
    case isLastStop = "IsLastStop"
    case onBreak = "OnBreak"
    case scheduledMinutes = "ScheduledMinutes"
    case busName = "BusName"
    case vehicleName = "VehicleName"
    case routeName = "RouteName"
    case minutes = "Minutes"
    case time = "Time"
  }
}
