//
//  HomeTableViewController.swift
//  Bronco Express
//
//  Created by Christian Valera on 12/8/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import UIKit
import Pulley

class HomeTableViewController: UITableViewController {
  
  var routes = [Route]()
  var selectedRoute: Route!
  
  var stops = [Stop]()
  var filteredStops = [Stop]()
  var stopTableViewCell = "stopTableViewCell"
  
  let searchController = UISearchController(searchResultsController: nil)
  
  lazy var messageLabel: UILabel = {
    let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
    label.text = "Stops unavailable"
    label.textColor = UIColor.lightGray
    label.numberOfLines = 0
    label.textAlignment = .center
    label.font = .systemFont(ofSize: 18)
    label.sizeToFit()
    return label
  }()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: stopTableViewCell)
    tableView.tableFooterView = UIView()
    tableView.rowHeight = 55
    
    setupNavigationBar()
    getRoutes()
  }
  
  private func setupNavigationBar() {
    navigationController?.navigationBar.prefersLargeTitles = true
    // Add search in navbar
    searchController.searchResultsUpdater = self
    searchController.obscuresBackgroundDuringPresentation = false
    searchController.searchBar.placeholder = "Filter Stops"
    definesPresentationContext = true
    navigationItem.searchController = searchController
    
    // Add navbar buttons
    let busButton = UIButton(type: .system)
    busButton.setImage(#imageLiteral(resourceName: "bus").withRenderingMode(.alwaysOriginal), for: .normal)
    busButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
    busButton.addTarget(self, action: #selector(busTapped), for: .touchUpInside)
    
    let settingsButton = UIButton(type: .system)
    settingsButton.setImage(UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal), for: .normal)
    settingsButton.frame = CGRect(x: 0, y: 0, width: 34, height: 34)
    settingsButton.addTarget(self, action: #selector(settingsTapped), for: .touchUpInside)
    
    navigationItem.leftBarButtonItem = UIBarButtonItem(customView: settingsButton)
    navigationItem.rightBarButtonItem = UIBarButtonItem(customView: busButton)
  }
  
  // MARK: - API calls
  private func getRoutes() {
    UIApplication.shared.isNetworkActivityIndicatorVisible = true
    DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
      if let url = API.getRoutesURL() {
        if let data = try? Data(contentsOf: url) {
          let decoder = JSONDecoder()
          if let results = try? decoder.decode([Route].self, from: data) {
            self.routes = results
            self.setInitialRoute()
          }
        }
      }
    }
  }
  
  private func setInitialRoute() {
    let savedInitialRoute = getInitialRoute()
    if let route = routes.first(where: { $0.id == savedInitialRoute } ) {
      selectedRoute = route
    } else {
      selectedRoute = routes.first
    }
    getStops(routeID: selectedRoute.id)
  }
  
  private func getStops(routeID: Int) {
    DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
      if let url = API.getStopsURL(route: routeID) {
        if let data = try? Data(contentsOf: url) {
          let decoder = JSONDecoder()
          if let results = try? decoder.decode([Stop].self, from: data) {
            self.filteredStops.removeAll()
            self.stops = results
            self.reloadTableView()
          }
        }
      }
    }
  }
  
  // MARK: - Navigation bar button handlers
  
  @objc func busTapped() {
    if !routes.isEmpty {
      let ac = UIAlertController(title: "Choose route", message: nil, preferredStyle: .actionSheet)
      for route in routes {
        ac.addAction(UIAlertAction(title: route.name, style: .default, handler: { [unowned self] _ in
          UIApplication.shared.isNetworkActivityIndicatorVisible = true
          self.selectedRoute = route
          self.getStops(routeID: route.id)
        }))
      }
      ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
      ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItems?.first
      present(ac, animated: true)
    }
  }
  
  @objc func settingsTapped() {
    let vc = SettingsTableViewController()
    vc.routes = routes
    navigationController?.pushViewController(vc, animated: true)
  }
  
  // MARK: - Private helper functions
  
  private func searchBarIsEmpty() -> Bool {
    // Returns true if the text is empty or nil
    return searchController.searchBar.text?.isEmpty ?? true
  }
  
  private func filterContentForSearchText(_ searchText: String) {
    filteredStops = stops.filter({ (stop: Stop) -> Bool in
      return stop.name.lowercased().contains(searchText.lowercased())
    })
    
    tableView.reloadData()
  }
  
  private func reloadTableView() {
    DispatchQueue.main.async { [unowned self] in
      self.title = self.selectedRoute.name
      self.tableView.reloadData()
      UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
  }
  
  private func isFiltering() -> Bool {
    return searchController.isActive && !searchBarIsEmpty()
  }
  
  private func getInitialRoute() -> Int {
    let dict = UserDefaults.standard.object(forKey: "initialRoute") as? [String: Int] ?? ["None": -1]
    return dict.values.first!
  }
  
  // MARK: - Table view data source
  
  override func numberOfSections(in tableView: UITableView) -> Int {
    if !stops.isEmpty {
      tableView.separatorStyle = .singleLine
      tableView.backgroundView = nil
      return 1
    } else {
      title = "Home"
      tableView.backgroundView = messageLabel
      tableView.separatorStyle = .none
      return 0
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    if isFiltering() {
      return filteredStops.count
    }
    
    return stops.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: stopTableViewCell, for: indexPath)
    let stop: Stop
    if isFiltering() {
      stop = filteredStops[indexPath.row]
    } else {
      stop = stops[indexPath.row]
    }
    
    cell.accessoryType = .disclosureIndicator
    cell.textLabel?.text = stop.name
    return cell
  }
  
  // MARK: - Table view delegates
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let stop: Stop
    if isFiltering() {
      stop = filteredStops[indexPath.row]
    } else {
      stop = stops[indexPath.row]
    }
    goToArrival(stop)
    
  }
  
  private func goToArrival(_ stop: Stop) {
    
    let mapViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "MapViewController") as! MapViewController
    
    mapViewController.allStops = stops
    mapViewController.selectedStop = stop
    mapViewController.route  = selectedRoute
    
    let detailTableViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "DetailViewController") as! DetailViewController
    
    detailTableViewController.routeID = selectedRoute.id
    detailTableViewController.stop = stop
    
    let pulleyController = PulleyViewController(contentViewController: mapViewController, drawerViewController: detailTableViewController)
    pulleyController.title = stop.name
    
    navigationController?.navigationBar.prefersLargeTitles = false
    navigationController?.pushViewController(pulleyController, animated: true)
  }
}

extension HomeTableViewController: UISearchResultsUpdating {
  func updateSearchResults(for searchController: UISearchController) {
    filterContentForSearchText(searchController.searchBar.text!)
  }
}
