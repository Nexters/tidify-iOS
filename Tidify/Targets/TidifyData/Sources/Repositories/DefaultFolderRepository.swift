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
  
  public func fetchFolders(start: Int, count: Int) -> Single<[Folder]> {
    return folderService.request(.fetchFolders(start: start, count: count))
      .map(FolderListDTO.self)
      .map { $0.toDomain() }
  }
  
  public func updateFolder(id: Int, requestDTO: FolderRequestDTO) -> Single<Void> {
    return folderService.request(.updateFolder(
      id: id,
      requestDTO: requestDTO)
    )
    .map { _ in }
  }
  
  public func deleteFolder(id: Int) -> Single<Void> {
    return folderService.request(.deleteFolder(id: id))
      .map { _ in }
  }
}
