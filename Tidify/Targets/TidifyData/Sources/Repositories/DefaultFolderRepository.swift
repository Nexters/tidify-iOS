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
  public func createFolder(requestDTO: FolderRequestDTO) -> Single<Folder> {
    return folderService.rx.request(.createFolder(requestDTO))
      .map(FolderDTO.self)
      .map { $0.toDomaion() }
  }
  
  public func fetchFolders() -> Single<[Folder]?> {
    return folderService.rx.request(.fetchFolders())
      .map(FolderListDTO.self)
      .map { $0.toDomain() }
  }
  
  public func updateFolder(id: Int, requestDTO: FolderRequestDTO) -> Single<Void> {
    return folderService.rx.request(.updateFolder(
      id: id,
      requestDTO: requestDTO)
    )
    .map { _ in }
  }
  
  public func deleteFolder(id: Int) -> Single<Void> {
    return folderService.rx.request(.deleteFolder(id: id))
      .map { _ in }
  }
}
