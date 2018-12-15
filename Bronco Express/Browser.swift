//
//  Url.swift
//  Bronco Express
//
//  Created by Brandon Choi on 12/14/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import Foundation
import UIKit

struct Browser {
    init() {}
    
    //copied from stack overflow: https://stackoverflow.com/questions/27755069/how-can-i-add-a-link-for-a-rate-button-with-swift
    static func open(_ urlStr: String) {
        if let checkURL = URL(string: urlStr) {
            if #available(iOS 10, *) {
                UIApplication.shared.open(checkURL, options: [:], completionHandler: { (success) in
                    print("Open \(checkURL): \(success)")
                })
            } else if UIApplication.shared.openURL(checkURL) {
                print("Open \(checkURL)")
            }
        } else {
            print("invalid url")
        }
    }
}
