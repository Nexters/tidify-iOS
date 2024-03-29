//
//  DataAssembly.swift
//  Tidify
//
//  Created by Ian on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain

public struct DataAssembly: Assemblable {

  // MARK: - Initializer
  public init() {}

  // MARK: - Methods
  public func assemble(container: DIContainer) {
    container.register(type: UserRepository.self) { _ in DefaultUserRepository() }
    
    container.register(type: FolderRepository.self) { _ in DefaultFolderRepository() }

    container.register(type: BookmarkRepository.self) { _ in DefaultBookmarkRepository() }

    container.register(type: SearchRepository.self) { _ in DefaultSearchRepository() }

    container.register(type: FolderDetailRepository.self) { _ in DefaultFolderDetailRepository() }
  }
}
