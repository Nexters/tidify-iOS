//
//  FolderDetailRepository.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/04/26.
//  Copyright © 2023 Tidify. All rights reserved.
//

public protocol FolderDetailRepository: AnyObject {

  /// 특정 폴더 ID에 포함된 북마크 리스트를 반환합니다.
  func fetchBookmarkListInFolder(id: Int) async throws -> FetchBookmarkResponse

  /// 특정 폴더를 구독합니다.
  func subscribeFolder(id: Int) async throws

  /// 특정 폴더의 구독을 취소합니다.
  func stopSubscription(id: Int) async throws

  /// 공유하고 있는 폴더의 공유를 중단합니다.
  func stopSharingFolder(id: Int) async throws
}
