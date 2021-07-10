//
//  BookMark.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation

struct BookMark: Codable {
    let urlString: String?        // 북마크 URL
    let title: String       // 북마크 title
//    let dir
//    let hashTags: [String]

    var url: URL {
        return URL(string: urlString ?? "")!
    }

    enum CodingKeys: String, CodingKey {
        case urlString = "url"
        case title
    }
}

