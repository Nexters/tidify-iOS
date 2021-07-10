//
//  SignInViewModel.swift
//  Tidify
//
//  Created by Manjong Han on 2021/07/10.
//

import Foundation
import RxCocoa
import RxSwift
import KakaoSDKAuth
import KakaoSDKUser
import RxKakaoSDKUser

class SignInViewModel {
    struct Input {
        let clickSignInWithKakaoButton: ControlEvent<Void>
    }

    struct Output {
        let userSession: Driver<UserSession?>
    }

    func transfrom(_ input: Input) -> Output {
        let userSession = input.clickSignInWithKakaoButton.flatMap {
             UserApi.shared.rx.loginWithKakaoAccount()
        }
        .map { oauthToken in
            return UserSession(accessToken: oauthToken.accessToken)
        }
        .asDriver(onErrorJustReturn: nil)

        return Output(userSession: userSession)
    }
}
