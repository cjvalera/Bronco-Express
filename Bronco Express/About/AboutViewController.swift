//
//  AboutViewController.swift
//  Bronco Express
//
//  Created by Brandon Choi on 12/14/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import UIKit

class AboutViewController: UIViewController {
    
    let aboutText = "\nChristian Valera\nhttps://christianvalera.com\n\nBrandon Choi\nhttps://github.com/bmcpc"
    
    private lazy var textView: UITextView = {
        let view = UITextView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.dataDetectorTypes = .link
        view.textAlignment = .center
        view.font = .systemFont(ofSize: 18)
        view.isEditable = false
        view.isSelectable = true
        view.text = aboutText
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "About Us"
        view.addSubview(textView)
        textView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        textView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        textView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        textView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
    }
}
