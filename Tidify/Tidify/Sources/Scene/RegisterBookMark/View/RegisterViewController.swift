//
//  RegisterViewController.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/11.
//

import RxCocoa
import RxSwift
import Then
import UIKit

class RegisterViewController: UIViewController {
    weak var coordinator: Coordinator?

    private weak var titleLabel: UILabel!
    private weak var descriptionLabel: UILabel!
    private weak var inputTextField: UITextField!
    private weak var registerButton: UIButton!

    private let viewModel: RegisterViewModel!
    private let disposeBag = DisposeBag()

    private var registerButtonEnabled: Bool = false {
        didSet {
            self.registerButton.backgroundColor = registerButtonEnabled ? UIColor.t_tidiBlue() : Self.ghostColor
            self.registerButton.setTitleColor(registerButtonEnabled ? UIColor.white : Self.ghostColor, for: .normal)
        }
    }

    init(viewModel: RegisterViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayoutConstraints()

        let input = RegisterViewModel.Input(registerButtonTap: registerButton.rx.tap.asObservable())
        let output = viewModel.transform(input)

        output.didRegisterButtonTap
            .drive(onNext: { [weak self] _ in
                self?.registerButton.isEnabled = false
            })
            .disposed(by: disposeBag)

        inputTextField.rx.text
            .asDriver()
            .map { $0?.count }
            .drive(onNext: { [weak self] count in
                guard let count = count else { return }
                self?.registerButtonEnabled = count > 0 ? true : false
            })
            .disposed(by: disposeBag)
    }

    static let ghostColor = UIColor(60, 60, 67, 0.3)
}

private extension RegisterViewController {
    static let textFiledWidth: CGFloat = 335

    func setupViews() {
        view.backgroundColor = .white

        let titleLabel = UILabel().then {
            $0.text = R.string.localizable.registerTitle()
            $0.font = .t_B(32)
            view.addSubview($0)
        }
        self.titleLabel = titleLabel

        let descriptionLabel = UILabel().then {
            $0.text = R.string.localizable.registerDesc()
            $0.font = .t_R(16)
            view.addSubview($0)
        }
        self.descriptionLabel = descriptionLabel

        let inputTextField = UITextField().then {
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            $0.leftViewMode = .always
            $0.placeholder = R.string.localizable.registerInputTextFieldPlaceHolder()
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.cornerRadius = 16
            $0.font = .t_R(16)
            $0.backgroundColor = .white
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.7
            $0.layer.shadowOffset = CGSize(w: 0, h: 3)
            $0.layer.shadowRadius = 10
            $0.layer.masksToBounds = false
            view.addSubview($0)
        }
        self.inputTextField = inputTextField

        let registerButton = UIButton().then {
            $0.setTitle(R.string.localizable.registerButtonTitle(), for: .normal)
            $0.titleLabel?.font = .t_B(20)
            $0.setTitleColor(UIColor(60, 60, 67, 0.3), for: .normal)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .white
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.7
            $0.layer.shadowOffset = CGSize(w: 0, h: 3)
            $0.layer.shadowRadius = 10
            $0.layer.masksToBounds = false
            view.addSubview($0)
        }
        self.registerButton = registerButton
    }

    func setupLayoutConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(196)
            $0.centerX.equalToSuperview()
        }

        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(20)
            $0.centerX.equalToSuperview()
        }

        inputTextField.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(73)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(w: Self.textFiledWidth, h: 48))
        }

        registerButton.snp.makeConstraints {
            $0.top.equalTo(inputTextField.snp.bottom).offset(48)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(w: Self.textFiledWidth, h: 56))
        }
    }
}
