//
//  UserSession.swift
//  Tidify
//
//  Created by Manjong Han on 2021/07/10.
//

import Foundation

struct UserSession: Codable {
    let accessToken: String!
    let uid: String? = nil

    enum CodingKeys: String, CodingKey {
        case uid
        case accessToken = "access_token"
    }
}

