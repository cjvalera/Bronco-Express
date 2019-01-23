//
//  SettingsTableViewController.swift
//  Bronco Express
//
//  Created by Christian Valera on 12/13/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import UIKit
import StoreKit

class SettingsTableViewController: UITableViewController {
    
    var routes = [Route]()
    
    let initialRouteCellIdentifier = "initialRouteCell"
    let announcementCellIdentifier = "announcementCell"
    let rateThisAppIdentifier = "rateThisAppCell"
    let aboutUsIdentifier = "aboutUsCell"
    // TODO: Add app ID
    let appId = ""
    
    // MARK: - Initial

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Settings"
        tableView.tableFooterView = UIView()
        tableView.backgroundColor = UIColor(hexString: "#F3F3F3FF")
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return 1
        case 1:
            return 3
        default:
            fatalError("Unknown sections number")
        }
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0:
                let initialRouteCell = UITableViewCell(style: .value1, reuseIdentifier: initialRouteCellIdentifier)
                initialRouteCell.textLabel?.text = "Select Initial Route"
                initialRouteCell.detailTextLabel?.text = getInitialRoute()
                initialRouteCell.accessoryType = .disclosureIndicator
                return initialRouteCell
            default: fatalError("Unknown row in section 0")
            }
        case 1:
            switch indexPath.row {
            case 0:
                let announcementCell = UITableViewCell(style: .default, reuseIdentifier: announcementCellIdentifier)
                announcementCell.textLabel?.text = "Announcements"
                announcementCell.accessoryType = .disclosureIndicator
                return announcementCell
            case 1:
                let rateAppCell = UITableViewCell(style: .default, reuseIdentifier: rateThisAppIdentifier)
                rateAppCell.textLabel?.text = "Rate This App"
                rateAppCell.accessoryType = .disclosureIndicator
                return rateAppCell
            case 2:
                let aboutUsCell = UITableViewCell(style: .default, reuseIdentifier: aboutUsIdentifier)
                aboutUsCell.textLabel?.text = "About Us"
                aboutUsCell.accessoryType = .disclosureIndicator
                return aboutUsCell
            default: fatalError("Unknown row in section 1")
            }
        default: fatalError("Unknown section")
        }
    }
    
    // MARK: - Table view delegates
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: selectFavoriteRoute()
            default: fatalError("Unknown select row in section 0")
            }
        case 1:
            switch indexPath.row {
            case 0: goToAnnouncement()
            case 1: rateThisApp()
            case 2: goToAboutUs()
            default: fatalError("Unknown select row in section 1")
            }
        default: fatalError("Unknown section")
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 35
    }

    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return UIView()
    }
    // MARK: - Private functions
    private func getInitialRoute() -> String {
        let dict = UserDefaults.standard.object(forKey: "initialRoute") as? [String: Int] ?? ["None": -1]
        return dict.keys.first!
    }
    
    private func selectFavoriteRoute() {
        let ac = UIAlertController(title: "Select initial route...", message: nil, preferredStyle: .actionSheet)
        for route in routes {
            ac.addAction(UIAlertAction(title: route.name, style: .default, handler: { [unowned self] _ in
                UserDefaults.standard.set([route.name: route.id], forKey: "initialRoute")
                self.tableView.reloadSections(IndexSet(integer: 0), with: .automatic)
            }))
        }
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItems?.first
        present(ac, animated: true)
    }
    
    private func goToAnnouncement() {
        let vc = AnnouncementTableViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToAboutUs(){
        let vc = AboutViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func rateThisApp(){
        SKStoreReviewController.requestReview()
    }
}
