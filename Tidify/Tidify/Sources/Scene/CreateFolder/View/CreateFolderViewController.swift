//
//  CreateFolderViewController.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/21.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class CreateFolderViewController: BaseViewController {

  // MARK: - Constants

  static let textFieldHeight: CGFloat = 56
  static let labelSidePadding: CGFloat = 20
  static let textFieldSidePadding: CGFloat = 20

  // MARK: - Properties

  weak var coordinator: CreateFolderCoordinator?

  private weak var folderNameLabel: UILabel!
  private weak var folderNameTextField: UITextField!
  private weak var folderNameErrorLabel: UILabel!
  private weak var folderColorLabel: UILabel!
  private weak var folderColorTextfield: UITextField!
  private weak var folderColorErrorLabel: UILabel!
  private weak var saveButton: UIButton!
  private let backButton: UIButton!

  private let viewModel: CreateFolderViewModel
  private let selectedTagIndexSubject = PublishSubject<Int>()
  private var selectedTagIndex: Int?

  private var saveButtonEnabled: Bool = false {
    didSet {
      self.saveButton.backgroundColor = saveButtonEnabled ? .t_tidiBlue00() : .white
      self.saveButton.setTitleColor(saveButtonEnabled ? .white : .systemGray2, for: .normal)
    }
  }

  private lazy var navigationBar = TidifyNavigationBar(
    .default,
    title: R.string.localizable.folderNavigationTitle(),
    leftButton: backButton
  )
  private let selectedColorHexStringSubject = PublishSubject<String>()

  // MARK: - Initialize

  init(viewModel: CreateFolderViewModel, leftButton: UIButton) {
    self.viewModel = viewModel
    self.backButton = leftButton

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Override

  override func viewDidLoad() {
    super.viewDidLoad()

    let folderNameText = folderNameTextField.rx.text.asDriver()
      .filter { $0.t_isNotNil }
      .map { ($0)! }

    let input = CreateFolderViewModel.Input(
      folderNameText: folderNameText,
      folderLabelColor: selectedColorHexStringSubject.t_asDriverSkipError(),
      saveButtonTap: saveButton.rx.tap.asDriver()
    )

    let output = viewModel.transform(input)

    output.saveButtonStatus.asDriver()
      .drive(onNext: { [weak self] in
        self?.saveButtonEnabled = $0
      })
      .disposed(by: disposeBag)

    view.t_addTap().rx.event.asDriver()
      .drive(onNext: { [weak self] _ in
        self?.folderColorTextfield.resignFirstResponder()
        self?.folderNameTextField.resignFirstResponder()
      })
      .disposed(by: disposeBag)

    folderColorTextfield.t_addTap().rx.event.asDriver()
      .drive(onNext: { [weak self] _ in
        self?.showBottomSheet()
      })
      .disposed(by: disposeBag)

    selectedTagIndexSubject.t_asDriverSkipError()
      .drive(onNext: { [weak self] index in
        guard let self = self else { return }

        let attributedString = NSAttributedString(
          string: R.string.localizable.folderLabelPlaceHolderSelected(),
          attributes: [.foregroundColor: self.viewModel.dataSource[safe: index] ?? .black]
        )
        self.folderColorTextfield.attributedPlaceholder = attributedString
        self.selectedColorHexStringSubject.onNext(
          (self.viewModel.dataSource[safe: index])?.toHexString() ?? ""
        )
        self.selectedTagIndex = index
      })
      .disposed(by: disposeBag)

    folderNameTextField.rx.text
      .orEmpty
      .asDriver()
      .drive(onNext: { [weak self] in
        guard let self = self else { return }
        self.folderNameErrorLabel.isHidden = $0.isEmpty ? false : true
      })
      .disposed(by: disposeBag)

    selectedColorHexStringSubject.bind { [weak self] in
      self?.folderColorErrorLabel.isHidden = $0.isEmpty ? false : true
    }
    .disposed(by: disposeBag)
  }

  override func setupViews() {
    view.backgroundColor = .white
    setupNavigationBar()

    folderNameLabel = UILabel().then {
      $0.font = .t_B(16)
      $0.text = R.string.localizable.folderFolderTitle()
      $0.textColor = .black
      view.addSubview($0)
    }

    folderNameTextField = UITextField().then {
      $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
      $0.leftViewMode = .always
      $0.placeholder = R.string.localizable.folderFolderPlaceHolder()
      $0.backgroundColor = .white
      $0.font = .t_SB(16)
      $0.layer.borderWidth = 1
      $0.layer.cornerRadius = 16
      $0.layer.borderColor = UIColor(hexString: "3C3C43", alpha: 0.08).cgColor
      view.addSubview($0)
    }

    folderNameErrorLabel = UILabel().then {
      $0.font = .t_SB(14)
      $0.textColor = .systemRed
      $0.text = R.string.localizable.folderTitleError()
      view.addSubview($0)
    }

    folderColorLabel = UILabel().then {
      $0.font = .t_B(16)
      $0.text = R.string.localizable.folderLabelTitle()
      $0.textColor = .black
      view.addSubview($0)
    }

    folderColorTextfield = UITextField().then {
      $0.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 0))
      $0.leftViewMode = .always
      $0.placeholder = R.string.localizable.folderLabelPlaceHolder()
      $0.rightView = UIImageView(image: R.image.arrow_down_gray())
      $0.rightViewMode = .always
      $0.backgroundColor = .white
      $0.font = .t_SB(16)
      $0.layer.borderWidth = 1
      $0.layer.cornerRadius = 16
      $0.layer.borderColor = UIColor(hexString: "3C3C43", alpha: 0.08).cgColor
      view.addSubview($0)
    }

    folderColorErrorLabel = UILabel().then {
      $0.font = .t_SB(14)
      $0.textColor = .systemRed
      $0.text = R.string.localizable.folderLabelError()
      view.addSubview($0)
    }

    saveButton = UIButton().then {
      $0.setTitle(R.string.localizable.folderSaveButtonTitle(), for: .normal)
      $0.titleLabel?.font = .t_SB(18)
      $0.layer.cornerRadius = 16
      $0.setTitleColor(.systemGray2, for: .normal)
      view.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    folderNameLabel.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom).offset(40)
      $0.leading.equalToSuperview().offset(Self.labelSidePadding)
    }

    folderNameTextField.snp.makeConstraints {
      $0.top.equalTo(folderNameLabel.snp.bottom).offset(20)
      $0.leading.equalToSuperview().offset(Self.textFieldSidePadding)
      $0.trailing.equalToSuperview().offset(-Self.textFieldSidePadding)
      $0.height.equalTo(Self.textFieldHeight)
    }

    folderNameErrorLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(20)
      $0.centerY.equalTo(folderNameLabel)
    }

    folderColorLabel.snp.makeConstraints {
      $0.top.equalTo(folderNameTextField.snp.bottom).offset(48)
      $0.leading.equalToSuperview().offset(Self.labelSidePadding)
    }

    folderColorTextfield.snp.makeConstraints {
      $0.top.equalTo(folderColorLabel.snp.bottom).offset(20)
      $0.leading.equalToSuperview().offset(Self.textFieldSidePadding)
      $0.trailing.equalToSuperview().offset(-Self.textFieldSidePadding)
      $0.height.equalTo(Self.textFieldHeight)
    }

    folderColorErrorLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(20)
      $0.centerY.equalTo(folderColorLabel)
    }

    saveButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(Self.textFieldSidePadding)
      $0.bottom.equalToSuperview().offset(-40)
      $0.height.equalTo(Self.textFieldHeight)
    }
  }
}

private extension CreateFolderViewController {
  func setupNavigationBar() {
    view.addSubview(navigationBar)
    navigationBar.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
    navigationBar.leftButton.snp.removeConstraints()
    navigationBar.titleLabel.snp.removeConstraints()

    navigationBar.leftButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(15)
      $0.centerY.equalToSuperview()
    }
    navigationBar.titleLabel.snp.makeConstraints {
      $0.center.equalToSuperview()
    }
  }

  func showBottomSheet() {
    let bottomSheet = BottomSheetViewController(
      .labelColor,
      dataSource: viewModel.dataSource,
      selectedEventObserver: selectedTagIndexSubject.asObserver(),
      previousIndex: selectedTagIndex
    )
    bottomSheet.modalPresentationStyle = .overCurrentContext

    self.present(bottomSheet, animated: false, completion: nil)
  }
}
