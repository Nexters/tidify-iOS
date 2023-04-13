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

  func tryAppleSignIn(token: String) -> Observable<UserToken>
  func tryKakaoSignIn() -> Observable<UserToken>
}

public final class DefaultSignInUseCase: SignInUseCase {

  // MARK: - Properties
  public var signInRepository: SignInRepository

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
