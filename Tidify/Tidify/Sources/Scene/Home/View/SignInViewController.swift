//
//  SignInViewController.swift
//  Tidify
//
//  Created by Manjong Han on 2021/07/10.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class SignInViewController: BaseViewController {

    // MARK: - Properties

    weak var coordinator: MainCoordinator?

    private weak var signInWithKakaoButton: UIButton!
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

        let input = SignInViewModel.Input(clickSignInWithKakaoButton: signInWithKakaoButton.rx.tap)
        let output = viewModel.transform(input)

        output.userSession
            .map { userSession in
                if userSession != nil {
                    self.coordinator?.start()
                    return "로그인 성공"
                }
                return "로그인 실패"
            }
            .drive(resultLabel.rx.text)
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

    override func setupViews() {
        view.backgroundColor = .white

        let signInWithKakaoButton = UIButton().then {
            $0.setTitle("카카오로 로그인", for: .normal)
            $0.setTitleColor(.black, for: .normal)
            $0.backgroundColor = .yellow

            view.addSubview($0)
        }

        let resultLabel = UILabel().then {
            $0.textColor = .black

            view.addSubview($0)
        }

        self.signInWithKakaoButton = signInWithKakaoButton
        self.resultLabel = resultLabel
    }

    override func setupLayoutConstraints() {
        signInWithKakaoButton.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        resultLabel.snp.makeConstraints {
            $0.top.equalTo(signInWithKakaoButton.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
        }
    }
}
