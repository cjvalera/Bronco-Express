//
//  AboutUsTableViewController.swift
//  Bronco Express
//
//  Created by Brandon Choi on 12/14/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import UIKit

class AboutUsViewController: UITableViewController, UITextViewDelegate {
    let writerIdentifier = "WritersCell"
    let websiteIdentifier = "WebsiteCell"
    let aboutUsTitle = "About Us"
    let writers = [("Christian Valera", "https://google.com"), ("Brandon Choi", "https://google.com")]
    
    var textView: UITextView!
    
    override func loadView() {
        textView = UITextView()
        textView.delegate = self
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
        textView.text = getAboutUsText()
    }
    //prob could just hardcode this so we don't generate on the fly... but i wanted to play around with swift xd
    private func getAboutUsText() -> String {
        var aboutUsText = String()
        writers.forEach { writer in
            aboutUsText.append("\r\n\r\n\(writer.0)\r\n\(writer.1)")
        }
        return aboutUsText
    }
}
