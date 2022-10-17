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
  func tryWebViewSignIn(type: SocialLoginType) -> Observable<String>
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
  
  public func tryWebViewSignIn(type: SocialLoginType) -> Observable<String> {
    switch type {
    case .kakao: return Observable.just(AppProperties.baseURL + "/auth/kakao")
    case .google: return Observable.just(AppProperties.baseURL + "/auth/google")
    default: return .empty()
    }
  }
}
