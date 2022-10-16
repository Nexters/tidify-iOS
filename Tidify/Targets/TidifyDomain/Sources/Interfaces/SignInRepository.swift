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
  func tryAppleLogin(token: String) -> Single<UserToken>
}
