//
//  DefaultSignInRepository.swift
//  TidifyData
//
//  Created by Ian on 2022/08/08.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain

import KakaoSDKAuth
import KakaoSDKUser
import RxSwift
import RxKakaoSDKAuth
import RxKakaoSDKUser
import Moya

public struct DefaultSignInRepository: SignInRepository {

  private let authService: MoyaProvider<AuthService>

  public init() {
    self.authService = .init(plugins: [NetworkPlugin()])
  }

  public func trySocialLogin(type: SocialLoginType) -> Observable<Void> {
    switch type {
    case .kakao:
      return tryKakaoLogin()
    case .apple, .google:
      // TODO: Implementation
      return .empty()
    }
  }
}

private extension DefaultSignInRepository {
  func tryKakaoLogin() -> Observable<Void> {
    if UserApi.isKakaoTalkLoginAvailable() {
      // 카카오톡이 설치되어 있는 경우
      return UserApi.shared.rx.loginWithKakaoTalk()
        .flatMapLatest { oAuthToken -> Observable<Void> in
          return requestAuthentication(type: .kakao, oAuthToken: oAuthToken)
        }
    } else {
      // 카카오톡 미설치 경우
      return UserApi.shared.rx.loginWithKakaoAccount()
        .flatMapLatest { oAuthToken -> Observable<Void> in
          return requestAuthentication(type: .kakao, oAuthToken: oAuthToken)
        }
    }
  }

  func requestAuthentication(type: SocialLoginType, oAuthToken: OAuthToken) -> Observable<Void> {
    return authService.rx.request(
      .auth(
        socialLoginType: type,
        accessToken: oAuthToken.accessToken,
        refreshToken: oAuthToken.refreshToken
      )
    )
    .asObservable()
    .map(UserSessionDTO.self)
    .do(onNext: { userSession in
      Beaver.info(userSession)
    })
    .mapToVoid()
  }
}
