//
//  DefaultSignInRepository.swift
//  TidifyData
//
//  Created by Ian on 2022/08/08.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import RxSwift
import Moya

public struct DefaultSignInRepository: SignInRepository {
  // MARK: - Properties
  private let authService: MoyaProvider<AuthService>
  
  // MARK: - Initializer
  public init() {
    self.authService = .init(plugins: [NetworkPlugin()])
  }
  
  // MARK: - Methods
  public func tryAppleLogin(token: String) -> Single<UserToken> {
    return authService.request(.apple(token: token))
      .map(UserTokenDTO.self)
      .flatMap { tokenDTO in
        return .create { observer in
          if tokenDTO.response.isSuccess {
            observer(.success(tokenDTO.toDomain()))
          }
          
          return Disposables.create()
        }
      }
  }
}
