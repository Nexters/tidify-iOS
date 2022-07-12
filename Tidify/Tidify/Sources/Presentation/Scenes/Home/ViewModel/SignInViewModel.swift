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

protocol SignInViewModelDelegate: AnyObject {
  func didSuccessSignInWithKakao()
  func didSuccessSingInWithApple()
}

final class SignInViewModel {

  struct Dependencies {
    let coordinator: SignInCoordinator
  }

  private let dependencies: Dependencies

  init(dependencies: Dependencies) {
    self.dependencies = dependencies
  }
}

extension SignInViewModel: ViewModelType {
  struct Input {
    let signInWithKakaoButtonTap: ControlEvent<Void>
    let signInWithAppleButtonTap: ControlEvent<Void>
    let withoutLoginButtonTap: ControlEvent<Void>
  }

  struct Output {
    let userSession: Driver<UserSession?>
    let didTapWithoutLoginButton: Driver<Void>
  }

  // MARK: - Methods

  func transform(_ input: Input) -> Output {
    let userSession = input.signInWithKakaoButtonTap
      .flatMap { UserApi.shared.rx.loginWithKakaoAccount() }
      .flatMapLatest { oAuthToken in
        return APIProvider.request(
          AuthAPI.auth(
            socialLoginType: .kakao,
            accessToken: oAuthToken.accessToken,
            refreshToken: oAuthToken.refreshToken
          )
        )
          .map(UserSessionDTO.self)
      }
      .map { [weak self] response -> UserSession? in
        if let authorization = response.authorization {
          self?.rememberAccessToken(authorization)
          return UserSession(accessToken: authorization)
        }

        return nil
      }
      .do(onNext: { [weak self] userSession in
        if userSession.t_isNotNil {
          self?.dependencies.coordinator.didSuccessSignInWithKakao()
        }
      })
        .asDriver(onErrorJustReturn: nil)

        let didTapWithoutLoginButton = input.withoutLoginButtonTap
        .asDriver()
        .do(onNext: { [weak self] in
          self?.dependencies.coordinator.didSuccessSingInWithApple()
        })
          .map { _ in }

    return Output(
      userSession: userSession,
      didTapWithoutLoginButton: didTapWithoutLoginButton
    )
  }
}

private extension SignInViewModel {
  func rememberAccessToken(_ accessToken: String) {
    UserDefaults.standard.setValue(accessToken, forKey: "access_token")
  }
}
