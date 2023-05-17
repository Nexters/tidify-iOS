//
//  DefaultSettingRepository.swift
//  TidifyData
//
//  Created by 한상진 on 2023/05/05.
//  Copyright © 2023 Tidify. All rights reserved.
//

import TidifyDomain

import RxSwift
import Moya

final class DefaultSettingRepository: SettingRepository {

  // MARK: Properties
  private let settingService: MoyaProvider<SettingService>

  // MARK: Initializer
  public init() {
    self.settingService = .init(plugins: [NetworkPlugin()])
  }

  // MARK: Methods
  public func trySignOut() -> Single<Void> {
    return settingService.rx.request(.trySignOut)
      .map { _ in }
  }
}
