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
  static let sidePadding: CGFloat = 20
  
  // MARK: - Properties
  
  weak var coordinator: RegisterCoordinator?
  
  private weak var urlTitleLabel: UILabel!
  private weak var urlTextField: UITextField!
  private weak var bookMarkTitleLabel: UILabel!
  private weak var bookMarkTextField: UITextField!
  private weak var tagTitleLabel: UILabel!
  private weak var tagTextField: UITextField!
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
      self.registerButton.setTitleColor(registerButtonEnabled ? .white : .systemGray2,
                                        for: .normal)
    }
  }
  
  lazy var navigationBar = TidifyNavigationBar(.default,
                                               title: navTitle,
                                               leftButton: leftButton,
                                               rightButtons: [])
  
  let demoTagList = ["tag name / 0", "tag name / 1", "tag name / 2", "tag name / 3"]
  
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
        self?.isInvalidFormatURL = !(text.contains("http") ||
                                     text.contains("https")) && !text.isEmpty
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
    
    let urlTextField = urlTextField.rx.text.asDriver()
      .filter { $0.t_isNotNil }
      .map { $0.t_unwrap }
    
    let input = RegisterViewModel.Input(
      urlInputText: urlTextField,
      bookMarkNameInputText: bookMarkTextField.rx.text.asDriver(),
      tagInputText: selectedTagSubject.t_asDriverSkipError(),
      registerButtonTap: registerButton.rx.tap.asDriver()
    )
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
    
    self.urlTitleLabel = makeTitleLabel(title: R.string.localizable.registerAddressTitle())
    
    let urlTextFieldPlaceholder = NSAttributedString(
      string: R.string.localizable.registerAddressPlaceHolder(),
      attributes: [.foregroundColor: UIColor.gray])
    self.urlTextField = makeTextField(placeholder: urlTextFieldPlaceholder)
    
    self.bookMarkTitleLabel = makeTitleLabel(
      title: R.string.localizable.registerBookMarkTitle()
    )
    
    let bookMarkTextFieldPlaceholder = NSAttributedString(
      string: R.string.localizable.registerBookMarkPlaceHolder(),
      attributes: [.foregroundColor: UIColor.gray])
    self.bookMarkTextField = makeTextField(placeholder: bookMarkTextFieldPlaceholder)
    
    self.tagTitleLabel = makeTitleLabel(title: R.string.localizable.registerFolderTitle())
    
    let tagTextFieldPlaceholder = NSAttributedString(
      string: R.string.localizable.registerFolderPlaceHolder(),
      attributes: [.foregroundColor: UIColor.gray])
    self.tagTextField = makeTextField(placeholder: tagTextFieldPlaceholder)
    
    self.registerButton = UIButton().then {
      $0.setTitle(R.string.localizable.registerButtonTitle(), for: .normal)
      $0.titleLabel?.font = .t_B(20)
      $0.setTitleColor(.systemGray2, for: .normal)
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor.lightGray.cgColor
      $0.t_cornerRadius(radius: Self.textFieldHeight / 3)
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
      $0.leading.equalToSuperview().offset(Self.sidePadding)
    }
    
    urlTextField.snp.makeConstraints {
      $0.top.equalTo(urlTitleLabel.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(Self.sidePadding)
      $0.size.equalTo(CGSize(w: Self.textFieldWidth, h: Self.textFieldHeight))
    }
    
    bookMarkTitleLabel.snp.makeConstraints {
      $0.top.equalTo(urlTextField.snp.bottom).offset(40)
      $0.leading.equalToSuperview().offset(Self.sidePadding)
    }
    
    bookMarkTextField.snp.makeConstraints {
      $0.top.equalTo(bookMarkTitleLabel.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(Self.sidePadding)
      $0.size.equalTo(CGSize(w: Self.textFieldWidth, h: Self.textFieldHeight))
    }
    
    tagTitleLabel.snp.makeConstraints {
      $0.top.equalTo(bookMarkTextField.snp.bottom).offset(40)
      $0.left.equalToSuperview().offset(Self.sidePadding)
    }
    
    tagTextField.snp.makeConstraints {
      $0.top.equalTo(tagTitleLabel.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(Self.sidePadding)
      $0.size.equalTo(CGSize(w: Self.textFieldWidth, h: Self.textFieldHeight))
    }
    
    registerButton.snp.makeConstraints {
      $0.leading.trailing.equalTo(tagTextField)
      $0.height.equalTo(56)
      $0.bottom.equalToSuperview().offset(-40)
    }
    
    notifyInvalidFormatUrlLabel.snp.makeConstraints {
      $0.centerY.equalTo(urlTitleLabel)
      $0.trailing.equalToSuperview().inset(Self.sidePadding)
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
  
  func showBottomSheet(_ tagList: [String]) {
    let bottomSheet = BottomSheetViewController(
      .chooseFolder,
      dataSource: demoTagList,
      selectedEventObserver: selectedTagIndexSubject.asObserver()
    )
    bottomSheet.modalPresentationStyle = .overFullScreen
    
    self.present(bottomSheet, animated: false, completion: nil)
  }
  
  func makeTitleLabel(title: String) -> UILabel {
    return UILabel().then {
      $0.text = title
      $0.font = .t_B(16)
      $0.textColor = .black
      view.addSubview($0)
    }
  }
  
  func makeTextField(placeholder: NSAttributedString) -> UITextField {
    return UITextField().then {
      $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
      $0.leftViewMode = .always
      $0.attributedPlaceholder = placeholder
      $0.backgroundColor = .white
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor.gray.cgColor
      $0.t_cornerRadius(radius: Self.textFieldHeight / 3)
      $0.font = .t_R(16)
      $0.textColor = .black
      view.addSubview($0)
    }
  }
}
