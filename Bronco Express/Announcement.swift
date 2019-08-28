//
//  Announcement.swift
//  Bronco Express
//
//  Created by Christian Valera on 12/9/18.
//  Copyright © 2018 cjvalera. All rights reserved.
//

import Foundation

struct Announcement: Codable {
  let id: Int
  let title: String
  let link: String
  let message: String
  
  enum CodingKeys: String, CodingKey {
    case id = "ID"
    case title = "Title"
    case link = "Link"
    case message = "Message"
  }
}
