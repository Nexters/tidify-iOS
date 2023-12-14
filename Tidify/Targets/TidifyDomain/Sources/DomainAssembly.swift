//
//  DomainAssembly.swift
//  Tidify
//
//  Created by Ian on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore

public struct DomainAssembly: Assemblable {
  
  // MARK: - Initializer
  public init() {}
  
  // MARK: - Methods
  public func assemble(container: DIContainer) {
    container.register(type: UserUseCase.self) { container in
      return DefaultUserUseCase(userRepository: container.resolve(type: UserRepository.self)!)
    }

    container.register(type: FolderCreationUseCase.self) { container in
      return DefaultFolderCreationUseCase(repository: container.resolve(type: FolderRepository.self)!)
    }

    container.register(type: FolderListUseCase.self) { container in
      return DefaultFolderListUseCase(repository: container.resolve(type: FolderRepository.self)!)
    }

    container.register(type: BookmarkListUseCase.self) { container in
      return DefaultBookmarkListUseCase(repository: container.resolve(type: BookmarkRepository.self)!)
    }

    container.register(type: SearchListUseCase.self) { container in
      return DefaultSearchListUseCase(
        searchRepository: container.resolve(type: SearchRepository.self)!,
        bookmarkRepository: container.resolve(type: BookmarkRepository.self)!
      )
    }

    container.register(type: BookmarkCreationUseCase.self) { container in
      return DefaultBookmarkCreationUseCase(
        bookmarkRepository: container.resolve(type: BookmarkRepository.self)!,
        folderRepository: container.resolve(type: FolderRepository.self)!
      )
    }

    container.register(type: FolderDetailUseCase.self) { container in
      return DefaultFolderDetailUseCase(
        folderDetailRepository: container.resolve(type: FolderDetailRepository.self)!,
        bookmarkRepository: container.resolve(type: BookmarkRepository.self)!
      )
    }
  }
}
