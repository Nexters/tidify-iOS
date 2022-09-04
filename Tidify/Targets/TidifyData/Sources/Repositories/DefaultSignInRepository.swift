//
//  DefaultSignInRepository.swift
//  TidifyData
//
//  Created by Ian on 2022/08/08.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain

import KakaoSDKAuth
import KakaoSDKUser
import RxSwift
import RxKakaoSDKAuth
import RxKakaoSDKUser
import Moya

public struct DefaultSignInRepository: SignInRepository {

  // MARK: - Properties
  private let authService: MoyaProvider<AuthService>

  // MARK: - Initializer
  public init() {
    self.authService = .init(plugins: [NetworkPlugin()])
  }

  // MARK: - Methods
  public func trySocialLogin(type: SocialLoginType) -> Single<UserToken> {
    switch type {
    case .kakao:
      // TODO: Implementation
//      return .just(.init(accessToken: "asdf", refreshToken: "asdf"))
      return tryKakaoLogin()
    case .apple(let token):
      return tryAppleLogin(token: token)
    case .google:
      // TODO: Implementation
      return .just(.init(accessToken: "asdf", refreshToken: "asdf"))
    }
  }
}

private extension DefaultSignInRepository {
  func tryAppleLogin(token: String) -> Single<UserToken> {
    return authService.rx.request(.apple(token: token))
      .map(UserTokenDTO.self)
      .map { $0.toDomain() }
  }

  func tryKakaoLogin() -> Single<UserToken> {
    return authService.rx.request(.kakao)
      .do(onSuccess: { response in
        print(response)
      }) { error in
        print(error)
      }
      .map(UserTokenDTO.self)
      .map { $0.toDomain() }


    // TODO: 동작 이상으로 추후 수정
//    if UserApi.isKakaoTalkLoginAvailable() {
//      // 카카오톡이 설치되어 있는 경우
//      return UserApi.shared.rx.loginWithKakaoTalk()
//        .flatMapLatest { oAuthToken -> Observable<Void> in
//          return requestAuthentication(type: .kakao, oAuthToken: oAuthToken)
//        }
//    } else {
//      // 카카오톡 미설치 경우
//      return UserApi.shared.rx.loginWithKakaoAccount()
//        .flatMapLatest { oAuthToken -> Observable<Void> in
//          return requestAuthentication(type: .kakao, oAuthToken: oAuthToken)
//        }
//    }
  }

  func requestAuthentication(type: SocialLoginType, oAuthToken: OAuthToken) -> Observable<Void> {
    return .just(())
  }
}
