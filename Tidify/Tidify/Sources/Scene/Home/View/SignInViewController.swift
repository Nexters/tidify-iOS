//
//  SignInViewController.swift
//  Tidify
//
//  Created by Manjong Han on 2021/07/10.
//

import AuthenticationServices
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class SignInViewController: BaseViewController {

    // MARK: - Properties

    weak var coordinator: MainCoordinator?

    private weak var logoImageView: UIImageView!
    private weak var titleLabel: UILabel!
    private weak var subTitleLabel: UILabel!
    private weak var tooltipImageView: UIImageView!

    private weak var loginMethodStackView: UIStackView!
    // TODO: 추후 모든 SNS 로그인 연동을 완료하면 버튼들을 StackView에 담아 관리한다.
    private weak var kakaoSignInButton: UIButton!
    private weak var appleSignInButton: ASAuthorizationAppleIDButton!
    private weak var withoutLoginButton: UIButton!
    private weak var resultLabel: UILabel!

    private let viewModel: SignInViewModel!
    private let disposeBag = DisposeBag()

    // MARK: - Initialize

    init(viewModel: SignInViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let input = SignInViewModel.Input(signInWithKakaoButtonTap: kakaoSignInButton.rx.tap,
                                          withoutLoginButtonTap: withoutLoginButton.rx.tap)
        let output = viewModel.transform(input)

        output.userSession
            .map { [weak self] userSession in
                if userSession != nil {
                    self?.coordinator?.start()
                    return "로그인 성공"
                }
                return "로그인 실패"
            }
            .drive(resultLabel.rx.text)
            .disposed(by: disposeBag)

        output.didTapWithoutLoginButton
            .drive(onNext: { [weak self] _ in
                self?.coordinator?.start()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

    override func setupViews() {
        view.backgroundColor = .white

        self.logoImageView = UIImageView().then {
            $0.image = R.image.tidify_logo()
            $0.contentMode = .scaleAspectFill
            view.addSubview($0)
        }

        self.titleLabel = UILabel().then {
            $0.text = R.string.localizable.loginTitle()
            $0.font = .t_R(24)
            $0.textColor = .black
            view.addSubview($0)
        }

        self.subTitleLabel = UILabel().then {
            $0.text = R.string.localizable.loginSubTitle()
            $0.font = .t_B(32)
            $0.textColor = .t_tidiBlue()
            view.addSubview($0)
        }

        self.tooltipImageView = UIImageView().then {
            $0.image = R.image.login_tooltip()
            $0.contentMode = .scaleAspectFill
            view.addSubview($0)
        }

        self.loginMethodStackView = UIStackView().then {
            $0.axis = .vertical
            $0.spacing = 20
            $0.alignment = .fill
            view.addSubview($0)
        }

        self.kakaoSignInButton = UIButton().then {
            $0.setTitle(R.string.localizable.loginKakaoTitle(), for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.setImage(R.image.login_kakao_symbol(), for: .normal)
            $0.imageEdgeInsets = .init(top: 0, left: -15, bottom: 0, right: 0)
            $0.titleLabel?.font = .t_B(16)
            $0.backgroundColor = .init(255, 197, 0)
            $0.t_cornerRadius(radius: 14)
            loginMethodStackView.addArrangedSubview($0)
        }

        self.appleSignInButton = ASAuthorizationAppleIDButton(
            authorizationButtonType: .signIn,
            authorizationButtonStyle: .black).then {
            $0.addTarget(self, action: #selector(appleSignInButtonTap), for: .touchUpInside)
            $0.cornerRadius = 14
            loginMethodStackView.addArrangedSubview($0)
        }

        self.withoutLoginButton = UIButton().then {
            let attributedString = NSAttributedString(
                string: R.string.localizable.loginWithoutLoginTitle(),
                attributes:
                    [.font: UIFont.t_R(14),
                     .foregroundColor: UIColor.systemGray,
                     .underlineStyle: NSUnderlineStyle.single.rawValue
                    ])
            $0.setAttributedTitle(attributedString, for: .normal)
            $0.setTitleColor(.black, for: .normal)
            loginMethodStackView.addArrangedSubview($0)
        }

        self.resultLabel = UILabel().then {
            $0.textColor = .black
            view.addSubview($0)
        }
    }

    override func setupLayoutConstraints() {
        let loginMethodButtonHeight: CGFloat = 46

        logoImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(200)
            $0.size.equalTo(CGSize(w: 76, h: 43))
            $0.centerX.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.top.equalTo(logoImageView.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
        }

        subTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(10)
            $0.centerX.equalToSuperview()
        }

        tooltipImageView.snp.makeConstraints {
            $0.top.equalTo(subTitleLabel.snp.bottom).offset(60)
            $0.centerX.equalToSuperview()
        }

        loginMethodStackView.snp.makeConstraints {
            $0.top.equalTo(tooltipImageView.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }

        kakaoSignInButton.snp.makeConstraints {
            $0.height.equalTo(loginMethodButtonHeight)
        }

        appleSignInButton.snp.makeConstraints {
            $0.height.equalTo(loginMethodButtonHeight)
        }

        resultLabel.snp.makeConstraints {
            $0.top.equalTo(kakaoSignInButton.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
    }
}

private extension SignInViewController {
    @objc
    func appleSignInButtonTap() {
        let appleIdProvider = ASAuthorizationAppleIDProvider()
        let request = appleIdProvider.createRequest()
        request.requestedScopes = [.fullName, .email]

        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}
// MARK: - Apple Login Delegate
extension SignInViewController: ASAuthorizationControllerDelegate,
                                ASAuthorizationControllerPresentationContextProviding {
    // Apple Login Modal Sheet 띄우기.
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        if let window = view.window {
            return window
        } else {
            return UIApplication.shared.t_keyWindow!
        }
    }

    // Apple Id 연동 성공시 실행되는 함수
    func authorizationController(controller: ASAuthorizationController,
                                 didCompleteWithAuthorization authorization: ASAuthorization) {
        switch authorization.credential {
        case let credential as ASAuthorizationAppleIDCredential:
            let userIdentifier = credential.user
            let fullName = credential.fullName
            let email = credential.email
            print("\(userIdentifier), fullName: \(fullName), email: \(email)")
        default:
            break
        }
    }
}
