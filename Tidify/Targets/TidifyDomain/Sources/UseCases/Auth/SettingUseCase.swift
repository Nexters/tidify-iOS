//
//  SettingUseCase.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/05/05.
//  Copyright © 2023 Tidify. All rights reserved.
//

import TidifyCore

import RxSwift

public protocol SettingUseCase {
  func trySignOut() -> Observable<Void>
}

final class DefaultSettingUseCase: SettingUseCase {

  // MARK: Properties
  private let settingRepository: SettingRepository

  // MARK: - Initializer
  public init(repository: SettingRepository) {
    settingRepository = repository
  }

  // MARK: - Methods
  public func trySignOut() -> Observable<Void> {
    settingRepository.trySignOut().asObservable()
  }
}
