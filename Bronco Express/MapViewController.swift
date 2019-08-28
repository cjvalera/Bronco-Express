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
  
  var vehicles = [Vehicle]()
  var allStops: [Stop]!
  var selectedStop: Stop!
  var route: Route!
  
  let timeInterval: TimeInterval = 15
  var reloadTimer: Timer!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    mapView.delegate = self
    
    parent?.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: pulleyViewController?.primaryContentViewController, action: #selector(updateMapDetail))
    
    addStopsAnnotations()
    centerMapOnLocation(location: selectedStop.location)
    getVehicles()
    
    reloadTimer = Timer.scheduledTimer(timeInterval: timeInterval, target: self, selector: #selector(updateMapDetail), userInfo: nil, repeats: true)
    
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    reloadTimer.invalidate()
    // This fixed the crash happening when selecting a cluster then pop/dismissing the view controller
    mapView.removeAnnotations(mapView.annotations)
  }
  
  deinit {
    mapView.removeAnnotations(mapView.annotations)
  }
  
  // MARK: - API call
  @objc private func getVehicles() {
    guard let url = API.getVehicles(route: self.route.id) else { return }
    DispatchQueue.global(qos: .userInteractive).async {
      do {
        let data = try Data(contentsOf: url)
        let decoder = JSONDecoder()
        let results = try decoder.decode([Vehicle].self, from: data)
        self.vehicles = results
        DispatchQueue.main.async { [unowned self] in
          self.mapView.addAnnotations(results)
        }
      } catch {
        print(error.localizedDescription)
      }
    }
  }
  
  @objc private func updateMapDetail() {
    guard let detailViewController = pulleyViewController?.drawerContentViewController as? DetailViewController else {
      return
    }
    mapView.removeAnnotations(vehicles)
    detailViewController.getArrivals()
    getVehicles()
  }
  
  func addStopsAnnotations() {
    for stop in allStops {
      stop.subtitle = route.name
      mapView.addAnnotation(stop)
    }
  }
  
  func centerMapOnLocation(location: CLLocation, with regionRadius: CLLocationDistance = 150 ) {
    let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
    
    mapView.setRegion(coordinateRegion, animated: true)
  }
  
  func didSelectNewVehicle(_ arrival: Arrival) {
    guard let vehicle = vehicles.filter({ $0.id == arrival.vehicleID }).first else { return }
    centerMapOnLocation(location: vehicle.location, with: 100)
  }
}

extension MapViewController: MKMapViewDelegate {
  func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    if let stopAnnotation = annotation as? Stop {
      let identifier = "Stop"
      let stopAnnotationView = annotationView(identifier, viewFor: stopAnnotation) as? MKMarkerAnnotationView
      stopAnnotationView?.glyphImage = UIImage(named: "bus-stop")
      stopAnnotationView?.displayPriority = .defaultLow
      stopAnnotationView?.clusteringIdentifier = "Stops"
      return stopAnnotationView
    } else if let vehicleAnnotation = annotation as? Vehicle {
      let identifier = "Vehicle"
      let vehicleAnnotationView = annotationView(identifier, viewFor: vehicleAnnotation) as? MKMarkerAnnotationView
      vehicleAnnotationView?.glyphImage = UIImage(named: "bus-glyph")
      vehicleAnnotationView?.markerTintColor = UIColor.init(hexString: "#00843DFF")
      vehicleAnnotationView?.displayPriority = .defaultHigh
      vehicleAnnotationView?.clusteringIdentifier = "Vehicles"
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
    selectedStop = stop
    detailViewController.stop = stop
    detailViewController.getArrivals()
  }
}
