//
//  DetailTableViewController.swift
//  Bronco Express
//
//  Created by Christian Valera on 12/9/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import UIKit

class DetailTableViewController: UITableViewController {
    
    var arrivals = [Arrival]()
    
    var arrivalTableViewCell = "arrivalTableViewCell"
    
    var routeID: Int!
    var stop: Stop!
    
    let userNotificationManager = UserNotificationManager()
    
    lazy var rc: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.backgroundColor = UIColor(hexString: "#00843DFF")
        refreshControl.tintColor = UIColor.white
        refreshControl.addTarget(self, action: #selector(getArrivals), for: .valueChanged)
        return refreshControl
    }()
    
    lazy var formatter: DateFormatter = {
        let dt = DateFormatter()
        dt.dateFormat = "MMM d, h:mm a"
        return dt
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = stop.name
        navigationItem.largeTitleDisplayMode = .never
        
        tableView.tableFooterView = UIView()
        tableView.rowHeight = 55
        tableView.refreshControl = rc
        
        getArrivals()
    }
    
    // MARK: - API call
    @objc private func getArrivals() {
        DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
            if let url = API.getDirectionURL(route: self.routeID, stop: self.stop.id) {
                if let data = try? Data(contentsOf: url) {
                    let decoder = JSONDecoder()
                    if let results = try? decoder.decode([Arrival].self, from: data) {
                        self.arrivals = results
                        DispatchQueue.main.async { [unowned self] in
                            self.tableView.refreshControl?.endRefreshing()
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }

    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if !arrivals.isEmpty {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return 1
        } else {
            let messageLabel = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
            messageLabel.text = "No buses currently on route. Please pull down to refresh."
            messageLabel.textColor = UIColor.lightGray
            messageLabel.numberOfLines = 0
            messageLabel.textAlignment = .center
            messageLabel.font = .systemFont(ofSize: 18)
            messageLabel.sizeToFit()
            
            tableView.backgroundView = messageLabel
            tableView.separatorStyle = .none
            return 0
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrivals.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: arrivalTableViewCell) else {
                return UITableViewCell(style: .subtitle, reuseIdentifier: arrivalTableViewCell)
            }
            return cell
        }()
        
        cell.selectionStyle = .none

        let arrival = arrivals[indexPath.row]
        cell.textLabel?.text = "Bus \(arrival.busName)"
        cell.detailTextLabel?.text = arrival.arriveTime
        
        let label = UILabel.init(frame: CGRect(x:0,y:0,width:100,height:20))
        if let time = Int(arrival.time), time <= 1 {
            label.text = "Arriving"
        } else {
            label.text = "\(arrival.time) minutes"
        }

        cell.accessoryView = label
        return cell
    }

    // MARK: - Table view delegate
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let alarm = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            self.setReminder(self.arrivals[indexPath.row])
            completionHandler(true)
        }
        alarm.image = #imageLiteral(resourceName: "bell.pdf")
        alarm.backgroundColor = UIColor(hexString: "#01426AFF")
        
        let config = UISwipeActionsConfiguration(actions: [alarm])
        return config
    }
    
    // MARK: - Set notification reminder
    private func setReminder(_ arrival: Arrival) {
        let ac = UIAlertController(title: "Remind me in...", message: nil, preferredStyle: .actionSheet)
        let options = [3, 5, 8, 12]
        for option in options {
            ac.addAction(UIAlertAction(title: "\(option) minutes", style: .default, handler: { [unowned self] _ in
                let arrivalTime = (Int(arrival.arriveTime) ?? 0) - option
                var body = "Bus will arrive in \(arrivalTime) minutes."
                if arrivalTime <= 1 {
                    body = "Bus has arrived."
                }
                self.userNotificationManager.sendNotification(title: "\(self.stop.name)",
                                                            subtitle: "\(arrival.routeName) - Bus \(arrival.busName)",
                                                            body: body,
                                                            badge: 1,
                                                            delayInterval: option * 60)
            }))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        present(ac, animated: true)
    }
}
