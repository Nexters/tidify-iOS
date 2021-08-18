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

class RegisterViewController: BaseViewController {

    // MARK: - Constants

    static let textFieldWidth: CGFloat = 335
    static let textFieldHeight: CGFloat = 48
    static let labelSidePadding: CGFloat = 32
    static let textFieldSidePadding: CGFloat = 20
    static let registerButtonHeight: CGFloat = 96

    // MARK: - Properties

    weak var coordinator: RegisterCoordinator?

    private weak var urlTitleLabel: UILabel!
    private weak var urlTextField: UITextField!
    private weak var bookMarkTitleLabel: UILabel!
    private weak var bookMarkTextField: UITextField!
    private weak var tagTitleLabel: UILabel!
    private weak var tagTextField: UITextField!
    private weak var dividerView: UIView!
    private weak var registerButton: UIButton!
    private weak var notifyInvalidFormatUrlLabel: UILabel!
    private let leftButton: UIButton!
    private let navTitle: String!

    private let selectedTagIndexSubject = PublishSubject<Int>()
    private let selectedTagSubject = PublishSubject<String>()

    private let viewModel: RegisterViewModel!
    private let disposeBag = DisposeBag()

    private var isInvalidFormatURL: Bool = true {
        didSet {
            self.notifyInvalidFormatUrlLabel.isHidden = !isInvalidFormatURL
        }
    }

    private var registerButtonEnabled: Bool = false {
        didSet {
            self.registerButton.backgroundColor = registerButtonEnabled ? .t_tidiBlue() : .white
            self.registerButton.setTitleColor(registerButtonEnabled ? .white : .systemGray2, for: .normal)
        }
    }

    lazy var navigationBar = TidifyNavigationBar(.default,
                                                 title: navTitle,
                                                 leftButton: leftButton,
                                                 rightButtons: [])

    let demoTagList = ["tag name / 0", "tag name / 1", "tag name / 2", "tag name / 3", "tag name / 4"]

    // MARK: - Initialize

    init(viewModel: RegisterViewModel, title: String, leftButton: UIButton) {
        self.viewModel = viewModel
        self.navTitle = title
        self.leftButton = leftButton

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        urlTextField.becomeFirstResponder()

        view.t_addTap().rx.event.asDriver()
            .drive(onNext: { [weak self] _ in
                self?.urlTextField.resignFirstResponder()
                self?.bookMarkTextField.resignFirstResponder()
            })
            .disposed(by: disposeBag)

        urlTextField.rx.text.asDriver()
            .filter { string in
                guard let string = string else {
                    return false
                }
                return !string.isEmpty
            }
            .drive(onNext: { [weak self] text in
                guard let text = text?.lowercased() else {
                    return
                }
                self?.isInvalidFormatURL = !(text.contains("http") || text.contains("https")) && !text.isEmpty
                self?.registerButtonEnabled = !(text.isEmpty)
            })
            .disposed(by: disposeBag)

        tagTextField.t_addTap().rx.event.asDriver()
            .drive(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }
                strongSelf.showBottomSheet(strongSelf.demoTagList)
            })
            .disposed(by: disposeBag)

        selectedTagIndexSubject.t_asDriverSkipError()
            .drive(onNext: { [weak self] index in
                guard let strongSelf = self else {
                    return
                }
                self?.tagTextField.text = self?.demoTagList[index]
                self?.selectedTagSubject.onNext(strongSelf.demoTagList[index])
            })
            .disposed(by: disposeBag)

        let input = RegisterViewModel.Input(urlInputText: urlTextField.rx.text.asDriver().filter { $0.t_isNotNil }.map { $0.t_unwrap },
                                            bookMarkNameInputText: bookMarkTextField.rx.text.asDriver(),
                                            tagInputText: selectedTagSubject.t_asDriverSkipError(),
                                            registerButtonTap: registerButton.rx.tap.asDriver())
        let output = viewModel.transform(input)

        output.didReceivePreviewResponse.drive().disposed(by: disposeBag)

        output.didSaveBookMark
            .drive(onNext: { [weak self] _ in
                self?.registerButtonEnabled = false
                self?.coordinator?.popRegisterVC()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

    override func setupViews() {
        setupNavigationBar()
        view.backgroundColor = .white

        self.urlTitleLabel = UILabel().then {
            $0.text = R.string.localizable.registerAddressTitle()
            $0.font = .t_B(16)
            self.view.addSubview($0)
        }

        self.urlTextField = UITextField().then {
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            $0.leftViewMode = .always
            $0.placeholder = R.string.localizable.registerAddressPlaceHolder()
            $0.backgroundColor = .white
            $0.font = .t_R(16)
            setupTextFieldLayer($0)
            view.addSubview($0)
        }

        self.bookMarkTitleLabel = UILabel().then {
            $0.text = R.string.localizable.registerBookMarkTitle()
            $0.font = .t_B(16)
            self.view.addSubview($0)
        }

        self.bookMarkTextField = UITextField().then {
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            $0.leftViewMode = .always
            $0.placeholder = R.string.localizable.registerBookMarkPlaceHolder()
            $0.backgroundColor = .white
            $0.font = .t_R(16)
            setupTextFieldLayer($0)
            view.addSubview($0)
        }

        self.tagTitleLabel = UILabel().then {
            $0.text = R.string.localizable.registerTagTitle()
            $0.font = .t_B(16)
            self.view.addSubview($0)
        }

        self.tagTextField = UITextField().then {
            $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
            $0.leftViewMode = .always
            $0.placeholder = R.string.localizable.registerTagPlaceHolder()
            $0.rightView = UIImageView(image: R.image.arrow_down_gray())
            $0.rightViewMode = .always
            $0.backgroundColor = .white
            $0.font = .t_R(16)
            setupTextFieldLayer($0)
            view.addSubview($0)
        }

        self.dividerView = UIView().then {
            $0.backgroundColor = .systemGray2
            view.addSubview($0)
        }

        self.registerButton = UIButton().then {
            $0.setTitle(R.string.localizable.registerButtonTitle(), for: .normal)
            $0.titleLabel?.font = .t_B(20)
            $0.setTitleColor(.systemGray2, for: .normal)
            view.addSubview($0)
        }

        self.notifyInvalidFormatUrlLabel = UILabel().then {
            $0.font = UIFont.t_SB(14)
            $0.textColor = .systemRed
            $0.text = R.string.localizable.registerNotifyInvalidUrl()
            view.addSubview($0)
            $0.isHidden = true
        }
    }

    override func setupLayoutConstraints() {
        urlTitleLabel.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).offset(30)
            $0.leading.equalToSuperview().offset(Self.labelSidePadding)
        }

        urlTextField.snp.makeConstraints {
            $0.top.equalTo(urlTitleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(Self.textFieldSidePadding)
            $0.size.equalTo(CGSize(w: Self.textFieldWidth, h: Self.textFieldHeight))
        }

        bookMarkTitleLabel.snp.makeConstraints {
            $0.top.equalTo(urlTextField.snp.bottom).offset(48)
            $0.leading.equalToSuperview().offset(Self.labelSidePadding)
        }

        bookMarkTextField.snp.makeConstraints {
            $0.top.equalTo(bookMarkTitleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(Self.textFieldSidePadding)
            $0.size.equalTo(CGSize(w: Self.textFieldWidth, h: Self.textFieldHeight))
        }

        tagTitleLabel.snp.makeConstraints {
            $0.top.equalTo(bookMarkTextField.snp.bottom).offset(48)
            $0.left.equalToSuperview().offset(Self.labelSidePadding)
        }

        tagTextField.snp.makeConstraints {
            $0.top.equalTo(tagTitleLabel.snp.bottom).offset(20)
            $0.leading.equalToSuperview().offset(Self.textFieldSidePadding)
            $0.size.equalTo(CGSize(w: Self.textFieldWidth, h: Self.textFieldHeight))
        }

        registerButton.snp.makeConstraints {
            $0.leading.trailing.bottom.equalToSuperview()
            $0.height.equalTo(Self.registerButtonHeight)
        }

        dividerView.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(1)
            $0.bottom.equalTo(registerButton.snp.top).inset(2)
        }

        notifyInvalidFormatUrlLabel.snp.makeConstraints {
            $0.centerY.equalTo(urlTitleLabel)
            $0.trailing.equalToSuperview().inset(Self.labelSidePadding)
        }
    }
}

private extension RegisterViewController {
    func setupNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }

    func setupTextFieldLayer(_ textFiled: UITextField) {
        textFiled.layer.cornerRadius = Self.textFieldHeight / 3
        textFiled.layer.shadowColor = UIColor.black.cgColor
        textFiled.layer.shadowOpacity = 0.5
        textFiled.layer.shadowOffset = CGSize(w: 0, h: 2)
        textFiled.layer.shadowRadius = Self.textFieldHeight / 3
        textFiled.layer.masksToBounds = false
    }

    func showBottomSheet(_ tagList: [String]) {
        let bottomSheet = BottomSheetViewController(tagList: demoTagList,
                                                    selectedEventObserver: selectedTagIndexSubject.asObserver())
        bottomSheet.modalPresentationStyle = .overFullScreen

        self.present(bottomSheet, animated: false, completion: nil)
    }
}
