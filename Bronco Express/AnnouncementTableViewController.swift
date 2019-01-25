//
//  AnnouncementTableViewController.swift
//  Bronco Express
//
//  Created by Christian Valera on 12/9/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import UIKit

class AnnouncementTableViewController: UITableViewController {
    
    var announcements = [Announcement]()
    
    var announcementTableViewCell = "announcementTableViewCell"
    
    lazy var messageLabel: UILabel = {
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.bounds.size.width, height: view.bounds.size.height))
        label.text = "No announcement"
        label.textColor = UIColor.lightGray
        label.numberOfLines = 0
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18)
        label.sizeToFit()
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: announcementTableViewCell)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 55
        
        title = "Announcements"
        navigationItem.largeTitleDisplayMode = .never
        getAnnouncements()
    }
    // MARK: - API call
    private func getAnnouncements() {
        DispatchQueue.global(qos: .userInteractive).async { [unowned self] in
            if let url = API.getAnnouncements() {
                if let data = try? Data(contentsOf: url){
                    let decoder = JSONDecoder()
                    if let results = try? decoder.decode([Announcement].self, from: data) {
                        self.announcements = results
                        DispatchQueue.main.async { [unowned self] in
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        if !announcements.isEmpty {
            tableView.separatorStyle = .singleLine
            tableView.backgroundView = nil
            return 1
        } else {
            tableView.backgroundView = messageLabel
            tableView.separatorStyle = .none
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return announcements.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: announcementTableViewCell, for: indexPath)
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.text = announcements[indexPath.row].title
        
        return cell
    }
    
    // MARK: - Table view delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = AnnouncementDetailViewController()
        vc.announcement = announcements[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }
}
