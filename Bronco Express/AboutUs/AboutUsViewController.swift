//
//  AboutUsTableViewController.swift
//  Bronco Express
//
//  Created by Brandon Choi on 12/14/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {
    let aboutUsTitle = "About Us"
    let writerText = "\n\nChristian Valera\nhttps://google.com\n\nBrandon Choi\nhttps://google.com"
    
    var textView: UITextView!
    
    override func viewDidLoad() {
        textView = UITextView()
        setupTextView()
        view = textView
        title = aboutUsTitle
    }
    
    private func setupTextView(){
        textView.font = .systemFont(ofSize: 18)
        textView.isEditable = false
        textView.isSelectable = true
        textView.backgroundColor = UIColor(hexString: "#F3F3F3FF")
        textView.textAlignment = NSTextAlignment.center
        textView.dataDetectorTypes = .all
        textView.text = writerText
    }
}
