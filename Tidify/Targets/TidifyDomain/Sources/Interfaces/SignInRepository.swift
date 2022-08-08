//
//  SignInRepository.swift
//  TidifyDomain
//
//  Created by Ian on 2022/08/08.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public enum SocialLoginType: String {
  case kakao
  case apple
  case google
}

public protocol SignInRepository {
  func trySocialLogin(type: SocialLoginType) -> Observable<Void>
}
