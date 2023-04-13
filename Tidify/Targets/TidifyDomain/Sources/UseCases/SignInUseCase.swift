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
  func tryAppleSignIn(token: String) -> Observable<UserToken>
  func tryKakaoSignIn() -> Observable<UserToken>
}

final class DefaultSignInUseCase: SignInUseCase {

  private let signInRepository: SignInRepository

  // MARK: - Initializer
  public init(repository: SignInRepository) {
    signInRepository = repository
  }

  // MARK: - Methods
  public func tryAppleSignIn(token: String) -> Observable<UserToken> {
    signInRepository.tryAppleLogin(token: token).asObservable()
  }
  
  public func tryKakaoSignIn() -> Observable<UserToken> {
    signInRepository.tryKakaoLogin()
  }
}
