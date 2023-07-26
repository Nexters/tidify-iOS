//
//  DefaultSettingRepository.swift
//  TidifyData
//
//  Created by 한상진 on 2023/05/05.
//  Copyright © 2023 Tidify. All rights reserved.
//

import TidifyDomain

final class DefaultSettingRepository: SettingRepository {

  // MARK: Properties
  private let networkProvider: NetworkProviderType

  // MARK: Initializer
  init(networkProvider: NetworkProviderType) {
    self.networkProvider = networkProvider
  }

  // MARK: Methods
  func signOut() async throws {
    let response = try await networkProvider.request(endpoint: SettingEndpoint.signOut, type: APIResponse.self)

    guard response.isSuccess else {
      throw SettingError.failSignOut
    }
  }
}
