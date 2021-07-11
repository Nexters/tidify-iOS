//
//  BookMark.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import RxSwift

struct BookMark: Codable {
    let urlString: String?        // 북마크 URL
    let title: String             // 북마크 title
    let thumbnail: URL?        // OG 썸네일 이미지 URL
//    let dir
//    let hashTags: [String]

    var url: URL {
        return URL(string: urlString ?? "")!
    }

    enum CodingKeys: String, CodingKey {
        case urlString = "url"
        case title
        case thumbnail
    }
}
