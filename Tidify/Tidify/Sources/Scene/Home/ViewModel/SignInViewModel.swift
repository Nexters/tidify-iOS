//
//  SignInViewModel.swift
//  Tidify
//
//  Created by Manjong Han on 2021/07/10.
//

import Foundation
import KakaoSDKAuth
import KakaoSDKUser
import RxCocoa
import RxKakaoSDKUser
import RxSwift

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
        .map { oauthToken -> UserSession in
            self.rememberAccessToken(oauthToken.accessToken)
            return UserSession(accessToken: oauthToken.accessToken)
        }
        .asDriver(onErrorJustReturn: nil)

        return Output(userSession: userSession)
    }

    private func rememberAccessToken(_ accessToken: String) {
        UserDefaults.standard.setValue(accessToken, forKey: "access_token")
    }
}
