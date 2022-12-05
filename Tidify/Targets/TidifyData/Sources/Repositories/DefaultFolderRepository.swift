//
//  DefaultFolderRepository.swift
//  TidifyData
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import Moya
import RxSwift

public struct DefaultFolderRepository: FolderRepository {
  
  // MARK: - Properties
  private let folderService: MoyaProvider<FolderService>

  // MARK: - Initializer
  public init() {
    self.folderService = .init(plugins: [NetworkPlugin()])
  }
  
  // MARK: - Methods
  public func createFolder(requestDTO: FolderRequestDTO) -> Single<Void> {
    return folderService.request(.createFolder(requestDTO)).map { _ in }
  }
  
  public func fetchFolders() -> Single<[Folder]> {
    return folderService.request(.fetchFolders())
      .map(FolderListDTO.self)
      .flatMap { folderListDTO in
        return .create { observer in
          if folderListDTO.apiResponse.isSuccess {
            observer(.success(folderListDTO.toDomain().reversed()))
          } else {
            observer(.failure(FolderError.failFetchFolders))
          }

          return Disposables.create()
        }
      }
  }
  
  public func updateFolder(id: Int, requestDTO: FolderRequestDTO) -> Single<Void> {
    return folderService.request(.updateFolder(
      id: id,
      requestDTO: requestDTO)
    )
    .map(APIResponse.self)
    .flatMap { response in
      return .create { observer in
        if response.isSuccess {
          observer(.success(()))
        } else {
          observer(.failure(FolderError.failFetchUpdateFolder))
        }

        return Disposables.create()
      }
    }
  }
  
  public func deleteFolder(id: Int) -> Single<Void> {
    return folderService.request(.deleteFolder(id: id))
      .map(APIResponse.self)
      .flatMap { response in
        return .create { observer in
          if response.isSuccess {
            observer(.success(()))
          } else {
            observer(.failure(FolderError.failFetchDeleteFolder))
          }

          return Disposables.create()
        }
      }
  }
}
