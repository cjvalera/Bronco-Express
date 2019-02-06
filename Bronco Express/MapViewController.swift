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
                    let decoder = JSONDecoder()
                    if let results = try? decoder.decode([Vehicle].self, from: data) {
                        self.vehicles = results
                        DispatchQueue.main.async { [unowned self] in
//                            guard let firstVehicle = results.first else { return }
//                            let initialLocation = CLLocation(latitude: firstVehicle.latitude, longitude: firstVehicle.longitude)
//                            self.centerMapOnLocation(location: initialLocation)
                        }
                    }
                }
            }
        }
    }
    
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
        guard let annotation = annotation as? Stop else { return nil }
        
        let identifier = "Stop"
        var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
        
        if annotationView == nil {
            annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
        } else {
            annotationView!.annotation = annotation
        }
        
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        let stop = view.annotation as! Stop
        
        guard let detailViewController = pulleyViewController?.drawerContentViewController as? DetailViewController else {
            return
        }
        pulleyViewController?.title = stop.name
        detailViewController.stop = stop
        detailViewController.getArrivals()
    }
}
