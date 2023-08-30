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
    
    container.register(type: FolderUseCase.self) { container in
      return DefaultFolderUseCase(repository: container.resolve(type: FolderRepository.self)!)
    }
    
    container.register(type: BookmarkCRUDUseCase.self) { container in
      return DefaultBookmarkCRUDUseCase(
        bookmarkRepository: container.resolve(type: BookmarkRepository.self)!,
        folderRepository: container.resolve(type: FolderRepository.self)!
      )
    }

    container.register(type: SearchUseCase.self) { container in
      return DefaultSearchUseCase(searchRepository: container.resolve(type: SearchRepository.self)!)
    }

    container.register(type: CreateBookmarkUseCase.self) { container in
      return DefaultCreateBookmarkUseCase(
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
