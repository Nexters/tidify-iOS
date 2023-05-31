//
//  MockFolderRepository.swift
//  TidifyDomainTests
//
//  Created by 여정수 on 2023/05/31.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Foundation
import RxSwift
@testable import TidifyDomain

final class MockFolderRepository: FolderRepository {

  private(set) var folders: [Folder] = Folder.stubList()

  func createFolder(requestDTO: FolderRequestDTO) -> Single<Folder> {
    return .create { [weak self] observer in
      if requestDTO.title.isEmpty {
        observer(.failure(FolderError.emptyFolderTitle))
      }

      if requestDTO.color.isEmpty {
        observer(.failure(FolderError.emptyColorValue))
      }

      let folder = Folder(id: 2, title: requestDTO.title, color: requestDTO.color)
      self?.folders.append(folder)
      observer(.success(folder))

      return Disposables.create()
    }
  }

  func fetchFolders(start: Int, count: Int) -> Single<FetchFoldersResponse> {
    return .create { [weak self] observer in
      observer(.success((folders: self?.folders ?? [], isLast: true)))

      return Disposables.create()
    }
  }

  func updateFolder(id: Int, requestDTO: FolderRequestDTO) -> Single<Void> {
    return .create { [weak self] observer in
      if var folder = self?.folders.first(where: { $0.id == id }) {
        folder.title = requestDTO.title
        folder.color = requestDTO.color
      } else {
        observer(.failure(FolderError.emptyMatchedFolder))
      }

      observer(.success(()))

      return Disposables.create()
    }
  }

  func deleteFolder(id: Int) -> Single<Void> {
    return .create { [weak self] observer in
      if let index = self?.folders.firstIndex(where: { $0.id == id }) {
        self?.folders.remove(at: index)
        observer(.success(()))
      } else {
        observer(.failure(FolderError.failFetchDeleteFolder))
      }

      return Disposables.create()
    }
  }
}
