//
//  DefaultFolderRepository.swift
//  TidifyData
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import RxSwift

public struct DefaultFolderRepository: FolderRepository {
  public init() {}
  
  //MARK: - 추후 실서버 연동 후 변경 예정
  public func createFolder(name: String, color: String) -> Single<Void> {
    let folder = Folder(name: name, color: color)
    return Single.just(folder).map { _ in }
  }
  
  public func updateFolder(name: String, color: String) {}
  
  public func deleteFolder(folderID: Int) {}
  
  public func fetchFolders() -> Single<[Folder]?> {
    let folders = [
      Folder(name: "테스트폴더0", color: "#ff9500"),
      Folder(name: "테스트폴더1", color: "#ff2d54"),
      Folder(name: "테스트폴더2", color: "#ff9500"),
      Folder(name: "테스트폴더3", color: "#ff2d54"),
      Folder(name: "테스트폴더4", color: "#ff9500"),
      Folder(name: "테스트폴더5", color: "#ff2d54"),
      Folder(name: "테스트폴더6", color: "#ff9500"),
      Folder(name: "테스트폴더7", color: "#ff2d54"),
      Folder(name: "테스트폴더8", color: "#ff9500"),
      Folder(name: "테스트폴더9", color: "#ff2d54"),
      Folder(name: "테스트폴더10", color: "#ff9500")
    ]
    
    return Single.just(folders)
  }
}
