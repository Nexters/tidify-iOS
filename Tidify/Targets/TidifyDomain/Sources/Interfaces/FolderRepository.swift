//
//  FolderRepository.swift
//  TidifyDomain
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public protocol FolderRepository {
  
  //MARK: - CRUD
  func createFolder(requestDTO: FolderRequestDTO) -> Single<Void>
  func fetchFolders(start: Int, count: Int) -> Single<[Folder]>
  func updateFolder(id: Int, requestDTO: FolderRequestDTO) -> Single<Void>
  func deleteFolder(id: Int) -> Single<Void>
}
