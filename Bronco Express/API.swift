//
//  API.swift
//  Bronco Express
//
//  Created by Christian Valera on 12/8/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import Foundation

struct API {
    
    init() {}
    
    static func getRoutesURL() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "broncoshuttle.com"
        components.path = "/Region/0/Routes"
        return components.url
    }
    
    static func getStopsURL(route: Int) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "broncoshuttle.com"
        components.path = "/Route/\(route)/Direction/0/Stops"
        return components.url
    }
    
    static func getDirectionURL(route: Int, stop: Int) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "broncoshuttle.com"
        components.path = "/Route/\(route)/Stop/\(stop)/Arrivals"
        return components.url
    }
    
    static func getAnnouncements() -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "broncoshuttle.com"
        components.path = "/Home/GetPortalEntries"
        return components.url
    }
    
    static func getVehicles(route: Int) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "broncoshuttle.com"
        components.path = "/Route/\(route)/Vehicles"
        return components.url
    }
    static func getWaypoints(route: Int) -> URL? {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "broncoshuttle.com"
        components.path = "/Route/\(route)/Waypoints"
        return components.url
    }
}
