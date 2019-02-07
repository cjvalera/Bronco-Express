//
//  MapViewController.swift
//  Bronco Express
//
//  Created by Christian Valera on 2/3/19.
//  Copyright © 2019 cjvalera. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    @IBOutlet var mapView: MKMapView!
    
    let regionRadius: CLLocationDistance = 200
    var vehicles = [Vehicle]()
    
    var allStops: [Stop]!
    var selectedStop: Stop!
    var route: Route!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        addStopsAnnotations()
        centerMapOnLocation(location: selectedStop.location)
        getVehicles()
    }
    
    // MARK: - API call
    @objc private func getVehicles() {
        DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
            if let url = API.getVehicles(route: self.route.id) {
                if let data = try? Data(contentsOf: url) {
//                if let data = self.getFakeVehicle() {
                    let decoder = JSONDecoder()
                    if let results = try? decoder.decode([Vehicle].self, from: data) {
                        self.vehicles = results
                        DispatchQueue.main.async { [unowned self] in
                            self.mapView.addAnnotations(results)
                        }
                    }
                }
            }
        }
    }
    
//    private func getFakeVehicle() -> Data? {
//        if let jsonPath = Bundle.main.path(forResource: "vehicle", ofType: "json") {
//            return try! Data(contentsOf: URL(fileURLWithPath: jsonPath))
//        }
//        return nil
//    }
    
    func addStopsAnnotations() {
        for stop in allStops {
            stop.subtitle = route.name
            mapView.addAnnotation(stop)
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func didSelectNewVehicle(_ arrival: Arrival) {
        
    }
}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let stopAnnotation = annotation as? Stop {
            let identifier = "Stop"
            let stopAnnotationView = annotationView(identifier, viewFor: stopAnnotation) as? MKMarkerAnnotationView
            stopAnnotationView?.glyphImage = UIImage(named: "bus-stop")
            return stopAnnotationView
        } else if let vehicleAnnotation = annotation as? Vehicle {
            let identifier = "Vehicle"
            let vehicleAnnotationView = annotationView(identifier, viewFor: vehicleAnnotation) as? MKMarkerAnnotationView
            vehicleAnnotationView?.glyphImage = UIImage(named: "bus-glyph")
            vehicleAnnotationView?.markerTintColor = UIColor.init(hexString: "#00843DFF")
            return vehicleAnnotationView
        }
        return nil
    }
    
    
    func annotationView(_ identifier: String, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        guard let stop = view.annotation as? Stop else { return }
        
        guard let detailViewController = pulleyViewController?.drawerContentViewController as? DetailViewController else {
            return
        }
        pulleyViewController?.title = stop.name
        detailViewController.stop = stop
        detailViewController.getArrivals()
    }
}
