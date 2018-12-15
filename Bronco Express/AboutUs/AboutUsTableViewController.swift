//
//  AboutUsTableViewController.swift
//  Bronco Express
//
//  Created by Brandon Choi on 12/14/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import UIKit

class AboutUsTableViewController: UITableViewController {
    let url = "https://google.com"
    let writerIdentifier = "WritersCell"
    let websiteIdentifier = "WebsiteCell"
    
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
        case 0, 1:
            return 1
        default:
            fatalError("Unknown sections number")
        }
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        switch indexPath.section{
        case 0:
            switch indexPath.row {
            case 0:
                let writerCell = UITableViewCell(style: .value1, reuseIdentifier: writerIdentifier)
                writerCell.textLabel?.text = "Writers"
                writerCell.accessoryType = .disclosureIndicator
                return writerCell
            default: fatalError("Unknown row in section 0")
            }
        case 1:
            switch indexPath.row {
            case 0:
                let websiteCell = UITableViewCell(style: .value1, reuseIdentifier: websiteIdentifier)
                websiteCell.textLabel?.text = "Website"
                websiteCell.accessoryType = .disclosureIndicator
                return websiteCell
            default: fatalError("Unknown row in section 0")
            }
        default: fatalError("Unknown section")
        }
    }
    
    // MARK: - Table view delegates

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath){
        tableView.deselectRow(at: indexPath, animated: true)
        switch indexPath.section {
        case 0:
            switch indexPath.row {
            case 0: goToWriterDetail()
            default: fatalError("Unknown select row in section 0")
            }
        case 1:
            switch indexPath.row {
            case 0: goToWebsite()
            default: fatalError("Unknown select row in section 1")
            }
        default: fatalError("Unknown section")
        }
    }
    
    private func goToWriterDetail(){
        let vc = AboutUsDetailViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    private func goToWebsite(){
        Browser.open(url)
    }
}
