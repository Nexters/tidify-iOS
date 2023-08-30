//
//  LoginViewController.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/07.
//  Copyright © 2022 Tidify. All rights reserved.
//

import AuthenticationServices

import SnapKit
import Then

final class LoginViewController: BaseViewController<LoginViewModel> {

  // MARK: - Properties
  private let indicatorview: UIActivityIndicatorView = .init().then {
    $0.color = .t_indigo00()
  }

  private let logoImageView: UIImageView = .init().then {
    $0.image = .init(named: "icon_symbolColor")!
    $0.contentMode = .scaleAspectFill
  }

  private let titleLabel: UILabel = .init().then {
    $0.text = "Tidify"
    $0.font = .t_B(32)
    $0.textColor = .t_tidiBlue00()
  }

  private let subTitleLabel: UILabel = .init().then {
    $0.text = "쉽고 깔끔한 북마크"
    $0.font = .t_B(18)
    $0.textColor = .t_tidiBlue00()
  }

  private let loginMethodStackView: UIStackView = .init().then {
    $0.axis = .vertical
    $0.spacing = 20
    $0.alignment = .fill
  }

  private let kakaoSignInButton: UIButton = .init().then {
    $0.setTitle("  카카오 로그인", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.setImage(.init(named: "login_kakao_symbol")!, for: .normal)
    $0.titleLabel?.font = .t_EB(16)
    $0.backgroundColor = .init(254, 229, 0)
    $0.cornerRadius(radius: 16)
    $0.addTarget(self, action: #selector(didTapkakaoLoginButton), for: .touchUpInside)
  }

  private let appleSignInButton: UIButton = .init().then {
    $0.setTitle("  Apple 로그인", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.setImage(.init(named: "login_apple_symbol")!, for: .normal)
    $0.titleLabel?.font = .t_EB(16)
    $0.backgroundColor = .black
    $0.cornerRadius(radius: 16)
    $0.addTarget(self, action: #selector(didTapAppleLoginButton), for: .touchUpInside)
  }

  override func viewDidLoad() {
    setupUI()
    super.viewDidLoad()
  }

  override func bindState() {
    viewModel.$state
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink(receiveValue: { [weak self] state in
        switch state {
        case .isLoading(let isLoading):
          if isLoading {
            self?.indicatorview.startAnimating()
          } else {
            self?.indicatorview.isHidden = true
          }
        }
      })
      .store(in: &cancellable)
  }
}

// MARK: - Extension
extension LoginViewController: ASAuthorizationControllerDelegate {
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    // Apple ID 연동 성공시
    switch authorization.credential {
    case let appleIDCredential as ASAuthorizationAppleIDCredential:
      let token: String = String(data: appleIDCredential.identityToken!, encoding: .utf8)!
      viewModel.action(.tryAppleLogin(token: token))

    default: break
    }
  }

  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithError error: Error
  ) {
    // Apple ID 연동 실패시
  }
}

extension LoginViewController: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}

// MARK: - Private
private extension LoginViewController {
  @objc func didTapkakaoLoginButton() {
    viewModel.action(.tryKakaoLogin)
  }

  @objc func didTapAppleLoginButton() {
    let appleIDProvider: ASAuthorizationAppleIDProvider = .init()
    let request: ASAuthorizationAppleIDRequest = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]

    let authorizationController: ASAuthorizationController = .init(authorizationRequests: [request])
    authorizationController.delegate = self
    authorizationController.presentationContextProvider = self
    authorizationController.performRequests()
  }

  func setupUI() {
    view.backgroundColor = .white

    view.addSubview(indicatorview)
    view.addSubview(logoImageView)
    view.addSubview(titleLabel)
    view.addSubview(subTitleLabel)
    view.addSubview(loginMethodStackView)
    loginMethodStackView.addArrangedSubview(kakaoSignInButton)
    loginMethodStackView.addArrangedSubview(appleSignInButton)

    indicatorview.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    logoImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(180)
      $0.centerX.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(logoImageView.snp.bottom).offset(48)
      $0.centerX.equalToSuperview()
    }

    subTitleLabel.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
      $0.centerX.equalToSuperview()
    }

    loginMethodStackView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.equalToSuperview().offset(-40)
    }

    [kakaoSignInButton, appleSignInButton].forEach {
      $0.snp.makeConstraints {
        $0.height.equalTo(56)
      }
    }
  }
}
