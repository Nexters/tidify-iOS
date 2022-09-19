//
//  SignInViewController.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/07.
//  Copyright © 2022 Tidify. All rights reserved.
//

import AuthenticationServices
import TidifyDomain
import UIKit

import RxCocoa
import ReactorKit
import SnapKit
import Then

final class SignInViewController: UIViewController, View {

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

  // TODO: Implementation
  private let googleSignInButton: UIButton = .init().then {
    $0.setTitle("Google 로그인", for: .normal)
    $0.setTitleColor(.gray, for: .normal)
    $0.titleLabel?.font = .t_B(16)
    $0.cornerRadius(radius: 14)
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor.lightGray.cgColor
  }

  private let kakaoSignInButton: UIButton = .init().then {
    $0.setTitle("카카오 로그인", for: .normal)
    $0.setTitleColor(.black, for: .normal)
    $0.setImage(.init(named: "login_kakao_symbol")!, for: .normal)
    $0.imageEdgeInsets = .init(top: 0, left: -15, bottom: 0, right: 0)
    $0.titleLabel?.font = .t_B(16)
    $0.backgroundColor = .init(255, 197, 0)
    $0.cornerRadius(radius: 14)
  }

  private let appleSignInButton: ASAuthorizationAppleIDButton = .init(
    authorizationButtonType: .signIn,
    authorizationButtonStyle: .black).then {
      $0.cornerRadius = 14
    }

  private let appleSignInSubject: PublishSubject<String> = .init()
  private var signInWithAppleBinder: Binder<Void> {
    return .init(self, binding: { vc, _ in
      vc.signInWithApple()
    })
  }
  
  var disposeBag: DisposeBag = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
  }

  func bind(reactor: SignInReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
}

private extension SignInViewController {
  var indicatorBinder: Binder<Bool> {
    return .init(self, binding: { vc, isLoading in
      if isLoading {
        vc.indicatorview.startAnimating()
      } else {
        vc.indicatorview.isHidden = true
      }
    })
  }
}

extension SignInViewController: ASAuthorizationControllerDelegate {
  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    // Apple ID 연동 성공시
    switch authorization.credential {
    case let appleIDCredential as ASAuthorizationAppleIDCredential:
      let token: String = String(data: appleIDCredential.identityToken!, encoding: .utf8)!
      appleSignInSubject.onNext(token)

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

extension SignInViewController: ASAuthorizationControllerPresentationContextProviding {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    return self.view.window!
  }
}

// MARK: - Private
private extension SignInViewController {
  func signInWithApple() {
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
    loginMethodStackView.addArrangedSubview(googleSignInButton)
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

    [googleSignInButton, kakaoSignInButton, appleSignInButton].forEach {
      $0.snp.makeConstraints {
        $0.height.equalTo(56)
      }
    }
  }

  func bindAction(reactor: SignInReactor) {
    typealias Action = SignInReactor.Action
    googleSignInButton.rx.tap
      .map { Action.trySignIn(type: .google) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    kakaoSignInButton.rx.tap
      .map { Action.trySignIn(type: .kakao) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    appleSignInButton.rx.controlEvent(.touchUpInside)
      .bind(to: signInWithAppleBinder)
      .disposed(by: disposeBag)

    appleSignInSubject
      .map { Action.trySignIn(type: .apple(token: $0)) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindState(reactor: SignInReactor) {
    reactor.state
      .map { $0.isLoading }
      .distinctUntilChanged()
      .subscribe(on: MainScheduler.instance)
      .bind(to: indicatorBinder)
      .disposed(by: disposeBag)
  }
}
