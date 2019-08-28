//
//  WebViewController.swift
//  Bronco Express
//
//  Created by Christian Valera on 12/9/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import UIKit

class AnnouncementDetailViewController: UIViewController, UITextViewDelegate{
  
  var textView: UITextView!
  var announcement: Announcement!
  
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
    
    textView.text = announcement.message.htmlToString
  }
  
}
