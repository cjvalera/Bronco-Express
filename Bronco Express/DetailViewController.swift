//
//  DetailViewController.swift
//  Bronco Express
//
//  Created by Christian Valera on 12/9/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import UIKit
import MapKit
import Pulley

class DetailViewController: UIViewController {
    
    @IBOutlet var tableView: UITableView!
    @IBOutlet var gripView: UIView!
    var arrivalTableViewCell = "arrivalTableViewCell"

    var arrivals = [Arrival]()
    var routeID: Int!
    var stop: Stop!
    
    let userNotificationManager = UserNotificationManager()
    
    lazy var formatter: DateFormatter = {
        let dt = DateFormatter()
        dt.dateFormat = "MMM d, h:mm a"
        return dt
    }()
    
    private let messageLabel: UILabel = {
        let label = UILabel()
        label.text = "No buses currently on route."
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.sizeToFit()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
        
        gripView.layer.cornerRadius = 2.5
        getArrivals()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(bounceDrawer), userInfo: nil, repeats: false)
    }
    
    @objc fileprivate func bounceDrawer() {
        pulleyViewController?.bounceDrawer()
    }
    
    // MARK: - API call
    func getArrivals() {
        DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
            if let url = API.getDirectionURL(route: self.routeID, stop: self.stop.id) {
                if let data = try? Data(contentsOf: url) {
                    let decoder = JSONDecoder()
                    if let results = try? decoder.decode([Arrival].self, from: data) {
                        self.arrivals = results
                        DispatchQueue.main.async { [unowned self] in
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Set notification reminder
    private func setReminder(_ arrival: Arrival) {
        let ac = UIAlertController(title: "Remind me in...", message: nil, preferredStyle: .actionSheet)
        let options = [3, 5, 8, 12]
        for option in options {
            ac.addAction(UIAlertAction(title: "\(option) minutes", style: .default, handler: { [unowned self] _ in
                let arrivalTime = arrival.minutes - option
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

//MARK: UITableViewDataSource
extension DetailViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if !arrivals.isEmpty {
            tableView.separatorStyle = .singleLine
            tableView.tableHeaderView = nil

            return 1
        } else {
            tableView.tableHeaderView = messageLabel
            tableView.separatorStyle = .none
            return 0
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrivals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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
    
}

//MARK: UITableViewDelegate
extension DetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let alarm = UIContextualAction(style: .normal, title: nil) { action, view, completionHandler in
            self.setReminder(self.arrivals[indexPath.row])
            completionHandler(true)
        }
        alarm.image = #imageLiteral(resourceName: "bell.pdf")
        alarm.backgroundColor = UIColor(hexString: "#01426AFF")
        
        let config = UISwipeActionsConfiguration(actions: [alarm])
        return config
    }
}

extension DetailViewController: PulleyDrawerViewControllerDelegate {
    func collapsedDrawerHeight(bottomSafeArea: CGFloat) -> CGFloat {
        return 200
    }
}
