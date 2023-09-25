//
//  LoginViewController.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/07.
//  Copyright © 2022 Tidify. All rights reserved.
//

import AuthenticationServices

import SnapKit

final class LoginViewController: BaseViewController, Alertable {

  // MARK: - Properties
  private let viewModel: LoginViewModel
  private let coordinator: LoginCoordinator

  private let indicatorView: UIActivityIndicatorView = {
    let indicatorView: UIActivityIndicatorView = .init()
    indicatorView.color = .t_tidiBlue00()
    return indicatorView
  }()

  private let logoImageView: UIImageView = {
    let imageView: UIImageView = .init()
    imageView.image = .init(named: "icon_symbolColor")!
    imageView.contentMode = .scaleAspectFill
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.text = "Tidify"
    label.font = .t_B(32)
    label.textColor = .t_tidiBlue00()
    return label
  }()

  private let subTitleLabel: UILabel = {
    let label: UILabel = .init()
    label.text = "쉽고 깔끔한 북마크"
    label.font = .t_B(18)
    label.textColor = .t_tidiBlue00()
    return label
  }()

  private let loginMethodStackView: UIStackView = {
    let stackView: UIStackView = .init()
    stackView.axis = .vertical
    stackView.spacing = 20
    stackView.alignment = .fill
    return stackView
  }()

  private lazy var kakaoSignInButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("  카카오 로그인", for: .normal)
    button.setTitleColor(.black, for: .normal)
    button.setImage(.init(named: "login_kakao_symbol")!, for: .normal)
    button.titleLabel?.font = .t_EB(16)
    button.backgroundColor = .init(254, 229, 0)
    button.cornerRadius(radius: 16)
    button.addTarget(self, action: #selector(didTapkakaoLoginButton), for: .touchUpInside)
    return button
  }()

  private lazy var appleSignInButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("  Apple 로그인", for: .normal)
    button.setTitleColor(.white, for: .normal)
    button.setImage(.init(named: "login_apple_symbol")!, for: .normal)
    button.titleLabel?.font = .t_EB(16)
    button.backgroundColor = .black
    button.cornerRadius(radius: 16)
    button.addTarget(self, action: #selector(didTapAppleLoginButton), for: .touchUpInside)
    return button
  }()

  // MARK: Initializer
  init(viewModel: LoginViewModel, coordinator: LoginCoordinator) {
    self.viewModel = viewModel
    self.coordinator = coordinator
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func setupViews() {
    view.addSubview(indicatorView)
    view.addSubview(logoImageView)
    view.addSubview(titleLabel)
    view.addSubview(subTitleLabel)
    view.addSubview(loginMethodStackView)
    loginMethodStackView.addArrangedSubview(kakaoSignInButton)
    loginMethodStackView.addArrangedSubview(appleSignInButton)
  }

  override func setupLayoutConstraints() {
    indicatorView.snp.makeConstraints {
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

  override func bindState() {
    viewModel.$state
      .map { $0.isLoading }
      .receive(on: DispatchQueue.main)
      .removeDuplicates()
      .sink(receiveValue: { [weak self] isLoading in
        if isLoading {
          self?.indicatorView.startAnimating()
        } else {
          self?.indicatorView.isHidden = true
        }
      })
      .store(in: &cancellable)

    viewModel.$state
      .map { $0.isEntered }
      .filter { $0 }
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] _ in
        self?.coordinator.didSuccessLogin()
      })
      .store(in: &cancellable)

    viewModel.$state
      .map { $0.errorType }
      .compactMap { $0 }
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] error in
        self?.presentAlert(type: .loginError)
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
}
