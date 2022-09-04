//
//  SignInUseCase.swift
//  TidifyDomain
//
//  Created by Ian on 2022/08/07.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore

import RxSwift

public protocol SignInUseCase {
  var signInRepository: SignInRepository { get set }

  func trySignIn(type: SocialLoginType) -> Observable<UserToken>
}

public final class DefaultSignInUseCase: SignInUseCase {

  // MARK: - Properties
  public var signInRepository: SignInRepository

  // MARK: - Initializer
  public init(repository: SignInRepository) {
    signInRepository = repository
  }

  // MARK: - Methods
  public func trySignIn(type: SocialLoginType) -> Observable<UserToken> {
    signInRepository.trySocialLogin(type: type)
      .asObservable()
  }
}
