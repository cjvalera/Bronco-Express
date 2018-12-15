//
//  AboutUsDetailViewController.swift
//  Bronco Express
//
//  Created by Brandon Choi on 12/14/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import UIKit

class AboutUsDetailViewController: UIViewController, UITextViewDelegate{
    
    var textView: UITextView!
    
    
    override func loadView() {
        textView = UITextView()
        textView.delegate = self
        setupTextView()
        view = textView
    }
    
    private func setupTextView() {
        textView.font = .systemFont(ofSize: 18)
        textView.isEditable = false
        textView.isSelectable = true
        textView.dataDetectorTypes = .all
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.text = "Christian Valera && Brandon Choi"
    }
    
}
