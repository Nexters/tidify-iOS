//
//  SignInRepository.swift
//  TidifyDomain
//
//  Created by Ian on 2022/08/08.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public enum SocialLoginType {
  case kakao
  case apple(token: String)
  case google

  var type: String {
    switch self {
    case .kakao: return "kakao"
    case .apple: return "apple"
    case .google: return "google"
    }
  }
}

public protocol SignInRepository {
  /// 소셜로그인 타입에 따른 회원가입을 시도합니다.
  func trySocialLogin(type: SocialLoginType) -> Single<UserToken>
}
