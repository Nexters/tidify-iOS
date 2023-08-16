//
//  SettingUseCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/05/05.
//  Copyright © 2023 Tidify. All rights reserved.
//

public enum SettingError: Error {
  case failSignOut
}

public protocol SettingUseCase {
  func signOut() async throws
}

final class DefaultSettingUseCase: SettingUseCase {

  // MARK: Properties
  private let settingRepository: SettingRepository

  // MARK: Initializer
  public init(settingRepository: SettingRepository) {
    self.settingRepository = settingRepository
  }

  // MARK: Methods
  func signOut() async throws {
    try await settingRepository.signOut()
  }
}
