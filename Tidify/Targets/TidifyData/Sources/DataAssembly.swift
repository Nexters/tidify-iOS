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

  public init() {}

  public func assemble(container: DIContainer) {
    container.register(type: SignInRepository.self) { _ in DefaultSignInRepository() }

    container.register(type: HomeRepository.self) { _ in DefaultHomeRepository() }
  }
}
