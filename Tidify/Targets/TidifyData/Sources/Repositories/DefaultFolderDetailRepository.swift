//
//  DefaultFolderDetailRepository.swift
//  TidifyData
//
//  Created by 한상진 on 2023/04/26.
//  Copyright © 2023 Tidify. All rights reserved.
//

import TidifyDomain

import Moya
import RxSwift

final class DefaultFolderDetailRepository: FolderDetailRepository {

  // MARK: - Properties
  private let folderService: MoyaProvider<FolderService>

  // MARK: - Initializer
  public init() {
    self.folderService = .init(plugins: [NetworkPlugin()])
  }

  // MARK: - Methods
  func fetchBookmarkListInFolder(folderID: Int) -> Single<FetchBookmarkListResponse> {
    return folderService.rx.request(.fetchBookmarkListInFolder(id: folderID))
      .map(BookmarkListResponse.self)
      .flatMap { response in
        return .create { observer in
          if response.isSuccess {
            let fetchResponse: FetchBookmarkListResponse = (
              bookmarks: response.toDomain(),
              currentPage: response.bookmarkListDTO.currentPage,
              isLastPage: response.bookmarkListDTO.isLastPage
            )
            observer(.success(fetchResponse))
          } else {
            observer(.failure(BookmarkError.failFetchBookmarks))
          }

          return Disposables.create()
        }
      }
  }
}
