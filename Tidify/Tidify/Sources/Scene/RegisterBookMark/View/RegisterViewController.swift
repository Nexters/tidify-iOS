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
    private weak var linkTitleLabel: UILabel!
    private weak var linkTextField: UITextField!
    private weak var tagTitleLabel: UILabel!
    private weak var tagTextField: UITextField!
    private weak var registerButton: UIButton!

    private let viewModel: RegisterViewModel!
    private let disposeBag = DisposeBag()

    private var registerButtonEnabled: Bool = false {
        didSet {
            self.registerButton.backgroundColor = registerButtonEnabled ? UIColor.t_tidiBlue() : .white
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

        let bookMarkContentInput = Driver.combineLatest(linkTextField.rx.text.asDriver().t_unwrap(),
                                                        tagTextField.rx.text.asDriver().startWith(""))

        let input = RegisterViewModel.Input(bookMarkContent: bookMarkContentInput,
                                            registerButtonTap: registerButton.rx.tap.asDriver())
        let output = viewModel.transform(input)

        output.didRegisterButtonTap
            .drive(onNext: { [weak self] _ in
                self?.registerButton.isEnabled = false
            })
            .disposed(by: disposeBag)

        linkTextField.rx.text
            .asDriver()
            .map { ($0?.count ?? 0) > 0 }
            .drive(onNext: { [weak self] isGreaterThanZero in
                self?.registerButtonEnabled = isGreaterThanZero
            })
            .disposed(by: disposeBag)
    }

    static let ghostColor = UIColor(60, 60, 67, 0.3)
}

private extension RegisterViewController {
    static let textFieldWidth: CGFloat = 335
    static let textFieldHeight: CGFloat = 56
    static let labelToTextFieldVerticalSpacing: CGFloat = 15
    static let sidePadding: CGFloat = 17

    func setupViews() {
        view.backgroundColor = .white

        let titleLabel = UILabel().then {
            $0.text = R.string.localizable.registerTitle()
            $0.font = .t_B(32)
            view.addSubview($0)
        }
        self.titleLabel = titleLabel

        let linkTitleLabel = UILabel().then {
            $0.text = R.string.localizable.registerLinkTextFieldLabelTitle()
            $0.font = .t_B(18)
            $0.textColor = .black
            view.addSubview($0)
        }
        self.linkTitleLabel = linkTitleLabel

        let linkTextField = UITextField().then {
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            $0.leftViewMode = .always
            $0.placeholder = R.string.localizable.registerLinkTextFieldPlaceHolder()
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.cornerRadius = 16
            $0.font = .t_R(16)
            $0.backgroundColor = .white
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.3
            $0.layer.shadowOffset = CGSize(w: 0, h: 3)
            $0.layer.shadowRadius = 10
            $0.layer.masksToBounds = false
            view.addSubview($0)
        }
        self.linkTextField = linkTextField

        let tagTitleLabel = UILabel().then {
            $0.text = R.string.localizable.registerTagTextFieldLabelTitle()
            $0.font = .t_B(18)
            $0.textColor = .black
            view.addSubview($0)
        }
        self.tagTitleLabel = tagTitleLabel

        let tagTextField = UITextField().then {
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            $0.leftViewMode = .always
            $0.placeholder = R.string.localizable.registerTagTextFieldPlaceHolder()
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.cornerRadius = 16
            $0.font = .t_R(16)
            $0.backgroundColor = .white
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.3
            $0.layer.shadowOffset = CGSize(w: 0, h: 3)
            $0.layer.shadowRadius = 10
            $0.layer.masksToBounds = false
            view.addSubview($0)
        }
        self.tagTextField = tagTextField

        let registerButton = UIButton().then {
            $0.setTitle(R.string.localizable.registerButtonTitle(), for: .normal)
            $0.titleLabel?.font = .t_B(20)
            $0.setTitleColor(Self.ghostColor, for: .normal)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.cornerRadius = 16
            $0.backgroundColor = .white
            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.3
            $0.layer.shadowOffset = CGSize(w: 0, h: 3)
            $0.layer.shadowRadius = 10
            $0.layer.masksToBounds = false
            view.addSubview($0)
        }
        self.registerButton = registerButton
    }

    func setupLayoutConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(20)
            $0.leading.equalToSuperview().offset(Self.sidePadding)
        }

        linkTitleLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(40)
            $0.leading.equalTo(titleLabel)
        }

        linkTextField.snp.makeConstraints {
            $0.top.equalTo(linkTitleLabel.snp.bottom).offset(Self.labelToTextFieldVerticalSpacing)
            $0.leading.equalTo(titleLabel)
            $0.size.equalTo(CGSize(w: Self.textFieldWidth, h: Self.textFieldHeight))
        }

        tagTitleLabel.snp.makeConstraints {
            $0.top.equalTo(linkTextField.snp.bottom).offset(30)
            $0.leading.equalTo(titleLabel)
        }

        tagTextField.snp.makeConstraints {
            $0.top.equalTo(tagTitleLabel.snp.bottom).offset(Self.labelToTextFieldVerticalSpacing)
            $0.leading.equalTo(titleLabel)
            $0.size.equalTo(CGSize(w: Self.textFieldWidth, h: Self.textFieldHeight))
        }

        registerButton.snp.makeConstraints {
            $0.top.equalTo(tagTextField.snp.bottom).offset(80)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(CGSize(w: Self.textFieldWidth, h: Self.textFieldHeight))
        }
    }
}
