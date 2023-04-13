//
//  DefaultSignInRepository.swift
//  TidifyData
//
//  Created by Ian on 2022/08/08.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import RxSwift
import RxKakaoSDKUser
import KakaoSDKUser
import Moya

final class DefaultSignInRepository: SignInRepository {
  // MARK: - Properties
  private let authService: MoyaProvider<AuthService>
  
  // MARK: - Initializer
  public init() {
    self.authService = .init(plugins: [NetworkPlugin()])
  }
  
  // MARK: - Methods
  public func tryAppleLogin(token: String) -> Single<UserToken> {
    return authService.rx.request(.apple(token: token))
      .map(UserTokenDTO.self)
      .flatMap { tokenDTO in
        return .create { observer in
          observer(.success(tokenDTO.toDomain()))
          return Disposables.create()
        }
      }
  }

  public func tryKakaoLogin() -> Observable<UserToken> {
    if UserApi.isKakaoTalkLoginAvailable() {
      return UserApi.shared.rx.loginWithKakaoTalk()
        .withUnretained(self)
        .flatMapLatest { owner, oAuthToken in
          return owner.requestKakaoSignIn(accessToken: oAuthToken.accessToken)
        }
    } else {
      return UserApi.shared.rx.loginWithKakaoAccount()
        .withUnretained(self)
        .flatMapLatest { owner, oAuthToken in
          return owner.requestKakaoSignIn(accessToken: oAuthToken.accessToken)
        }
    }
  }
}

private extension DefaultSignInRepository {
  func requestKakaoSignIn(accessToken: String) -> Single<UserToken> {
    authService.rx.request(.tryKakaoSignIn(accessToken: accessToken))
      .map(UserTokenDTO.self)
      .map { response in
        print("response: \(response)")
        return response.toDomain()
      }
  }
}
