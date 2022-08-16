//
//  FolderRepository.swift
//  TidifyDomain
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public protocol FolderRepository {
  //TODO: 추후 실서버 연동 후 변경 예정
  func createFolder(name: String, color: String) -> Observable<Folder>
  func updateFolder(name: String, color: String) -> Observable<Folder>
  func deleteFolder(folderID: Int) -> Observable<Void>
  func fetchFolders() -> Observable<[Folder]?>
}
