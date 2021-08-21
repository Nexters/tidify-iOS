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

class SignInViewModel: ViewModelType {

    // MARK: - Properties

    struct Input {
        let clickSignInWithKakaoButton: ControlEvent<Void>
    }

    struct Output {
        let userSession: Driver<UserSession?>
    }

    // MARK: - Methods

    func transform(_ input: Input) -> Output {
        let userSession = input.clickSignInWithKakaoButton.flatMap {
             UserApi.shared.rx.loginWithKakaoAccount()
        }
        .flatMap { snsToken in
            return ApiProvider.request(AuthAPI.auth(socialLoginType: .kakao,
                                                    accessToken: snsToken.accessToken,
                                                    refreshToken: snsToken.refreshToken))
                .map(UserSessionDTO.self)
        }
        .map { response -> UserSession? in
            if let authorization = response.authorization {
                self.rememberAccessToken(authorization)
                return UserSession(accessToken: authorization)
            }
            return nil
        }
        .asDriver(onErrorJustReturn: nil)

        return Output(userSession: userSession)
    }

    private func rememberAccessToken(_ accessToken: String) {
        UserDefaults.standard.setValue(accessToken, forKey: "access_token")
    }
}
