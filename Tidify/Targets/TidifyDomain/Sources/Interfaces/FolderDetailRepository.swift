//
//  FolderDetailRepository.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/04/26.
//  Copyright © 2023 Tidify. All rights reserved.
//

public protocol FolderDetailRepository: AnyObject {

  /// 특정 폴더 ID에 포함된 북마크 리스트를 반환합니다.
  func fetchBookmarkListInFolder(id: Int) async throws -> FetchBookmarkListResponse
}
