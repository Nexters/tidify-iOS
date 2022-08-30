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
    container.register(type: SignInUseCase.self) { container in
      return DefaultSignInUseCase(repository: container.resolve(type: SignInRepository.self)!)
    }
    
    container.register(type: FolderUseCase.self) { container in
      return DefaultFolderUseCase(repository: container.resolve(type: FolderRepository.self)!)
    }
    
    container.register(type: BookmarkUseCase.self) { container in
      return DefaultBookmarkUseCase(repository: container.resolve(type: BookmarkRepository.self)!)
    }
  }
}
