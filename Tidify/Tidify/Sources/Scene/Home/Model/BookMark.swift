//
//  BookMark.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import RxSwift

struct BookMark {
    let createdAt: String
    let updatedAt: String
    let id: Int
    let memberId: Int
    let urlString: String?
    let title: String

    var url: URL {
        return URL(string: urlString ?? "")!
    }
}

struct BookMarkRequestDTO: Codable {
    let memberId: Int
    let title: String
    let url: String

    enum CodingKeys: String, CodingKey {
        case memberId = "member_id"
        case title
        case url
    }
}

struct BookMarkListDTO: Codable {
    let bookMarks: [BookMarkDTO]
    let bookMarksCount: Int

    enum CodingKeys: String, CodingKey {
        case bookMarks = "bookmarks"
        case bookMarksCount = "bookmarks_count"
    }
}

struct BookMarkDTO: Codable {
    let createdAt: String
    let updatedAt: String
    let id: Int
    let memberId: Int
    let urlString: String?
    let title: String

    init(createdAt: String, updatedAt: String, id: Int, memberId: Int, urlString: String, title: String) {
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.id = id
        self.memberId = memberId
        self.urlString = urlString
        self.title = title
    }

    func toEntity() -> BookMark {
        return BookMark(createdAt: self.createdAt,
                        updatedAt: self.updatedAt,
                        id: self.id,
                        memberId: self.memberId,
                        urlString: self.urlString,
                        title: self.title)
    }

    enum CodingKeys: String, CodingKey {
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case id
        case memberId = "member_id"
        case urlString = "url"
        case title
    }
}
