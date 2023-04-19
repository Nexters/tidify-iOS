//
//  SignInRepository.swift
//  TidifyDomain
//
//  Created by Ian on 2022/08/08.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxSwift

public protocol SignInRepository: AnyObject {
  func tryAppleLogin(token: String) -> Single<UserToken>
  func tryKakaoLogin() -> Observable<UserToken>
}
