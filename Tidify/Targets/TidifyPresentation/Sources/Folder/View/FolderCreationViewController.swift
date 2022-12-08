//
//  FolderCreationViewController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/10/19.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain
import UIKit

import ReactorKit
import RxRelay
import SnapKit

enum CreationType {
  case create
  case edit
}

final class FolderCreationViewController: UIViewController, View {

  // MARK: - Properties
  private var titleLabel: UILabel = .init()
  private var titleTextField: UITextField = .init()
  private var colorLabel: UILabel = .init()
  private var colorTextField: TidifyRightButtonTextField = .init(
    placeholder: "라벨을 달아봐요!",
    rightButtonImage: .init(named: "icon_arrowDown_gray")
  )
  private var createFolderButton: UIButton = .init()
  private let selectedColorIndexRelay: BehaviorRelay<Int> = .init(value: -1)
  private let tapGesture: UITapGestureRecognizer = .init()
  private let creationType: CreationType
  private let originFolder: Folder?
  private var colorDataSource: [UIColor] = .init()
  private var titleErrorLabel: UILabel = .init()
  private var colorErrorLabel: UILabel = .init()
  var disposeBag: DisposeBag = .init()
  
  init(creationType: CreationType, originFolder: Folder? = nil) {
    self.creationType = creationType
    self.originFolder = originFolder
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    setupEditing()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    registerKeyboardNotification()
    bindCreateFolderButton()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeKeyboardNotification()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }
  
  func bind(reactor: FolderCreationReactor) {
    bindAction(reactor: reactor)
  }
}

// MARK: - private
private extension FolderCreationViewController {
  func setupEditing() {
    guard let originFolder = originFolder else { return }
    
    titleTextField.rx.text.onNext(originFolder.title)
    colorTextField.setText(text: "이 컬러의 라벨을 달았어요")
    colorTextField.setColor(color: UIColor(hex: originFolder.color))
    
    for (index, color) in colorDataSource.enumerated() {
      if color.toHexString() == originFolder.color {
        selectedColorIndexRelay.accept(index)
      }
    }
  }
  
  func setupUI() {
    let sidePadding: CGFloat = 20

    title = creationType == .create ? "폴더 생성" : "폴더 편집"
    view.backgroundColor = .white
    navigationController?.navigationBar.topItem?.title = ""

    view.addSubview(titleLabel)
    view.addSubview(titleTextField)
    view.addSubview(colorLabel)
    view.addSubview(colorTextField)
    view.addSubview(createFolderButton)
    view.addSubview(titleErrorLabel)
    view.addSubview(colorErrorLabel)
    colorTextField.addGestureRecognizer(tapGesture)

    titleLabel = setGuideLabel(titleLabel, title: "폴더 이름")
    titleTextField = setTextField(titleTextField, placeholder: "어떤 북마크를 모을까요?")
    colorLabel = setGuideLabel(colorLabel, title: "라벨")
    
    titleErrorLabel.do {
      $0.text = "폴더 이름이 필요해요!"
      $0.textColor = .systemRed
      $0.font = .t_SB(14)
      $0.isHidden = true
    }
    
    colorErrorLabel.do {
      $0.text = "라벨을 달아주세요!"
      $0.textColor = .systemRed
      $0.font = .t_SB(14)
      $0.isHidden = true
    }

    createFolderButton.do {
      $0.setTitle("저장", for: .normal)
      $0.titleLabel?.font = .t_SB(18)
      $0.setTitleColor(.systemGray2, for: .normal)
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor.lightGray.cgColor
      $0.isEnabled = false
      $0.cornerRadius(radius: 16)
    }
    
    colorDataSource = [
      .t_tidiBlue01(),
      .t_tidiBlue00(),
      .t_indigo00(),
      .systemGreen,
      .systemYellow,
      .systemOrange,
      .systemRed,
      .black
    ]

    titleLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.lessThanOrEqualToSuperview()
    }
    
    titleErrorLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(20)
      $0.centerY.equalTo(titleLabel)
    }

    titleTextField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.equalToSuperview().offset(-sidePadding)
      $0.height.equalTo(Self.viewHeight * 0.067)
    }

    colorLabel.snp.makeConstraints {
      $0.top.equalTo(titleTextField.snp.bottom).offset(40)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.lessThanOrEqualToSuperview()
    }
    
    colorErrorLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(20)
      $0.centerY.equalTo(colorLabel)
    }

    colorTextField.snp.makeConstraints {
      $0.top.equalTo(colorLabel.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.equalToSuperview().offset(-sidePadding)
      $0.height.equalTo(Self.viewHeight * 0.067)
    }

    createFolderButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.equalToSuperview().offset(-sidePadding)
      $0.bottom.equalToSuperview().offset(-40)
      $0.height.equalTo(Self.viewHeight * 0.068)
    }
  }

  func setGuideLabel(_ label: UILabel, title: String) -> UILabel {
    label.do {
      $0.text = title
      $0.font = .t_EB(16)
      $0.textColor = .black
    }

    return label
  }

  func setTextField(_ textField: UITextField, placeholder: String) -> UITextField {
    let attrString: NSAttributedString = .init(
      string: placeholder,
      attributes: [.foregroundColor: UIColor.gray]
    )

    textField.do {
      $0.leftView = .init(frame: .init(x: 0, y: 0, width: 20, height: 0))
      $0.leftViewMode = .always
      $0.attributedPlaceholder = attrString
      $0.backgroundColor = .white
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor.t_borderColor().cgColor
      $0.cornerRadius(radius: 16)
      $0.font = .t_SB(16)
      $0.textColor = .black
    }

    return textField
  }
  
  //MARK: - Binding
  var isEnableCreateFolderButtonBinder: Binder<Bool> {
    return .init(self) { owner, isEnable in
      owner.createFolderButton.backgroundColor = isEnable ? .t_tidiBlue00() : .clear
      owner.createFolderButton.setTitleColor(isEnable ? .white : .systemGray2, for: .normal)
      owner.createFolderButton.layer.borderColor = isEnable ? UIColor.clear.cgColor : UIColor.lightGray.cgColor
      owner.createFolderButton.isEnabled = isEnable
    }
  }
  
  var isEnableFolderNameObservable: Observable<Bool> {
    titleTextField.rx.text.orEmpty.map { !$0.isEmpty }
  }
  
  var isEnableFolderColorObservable: Observable<Bool> {
    selectedColorIndexRelay.map { $0 != -1 }
  }
  
  var folderTitleObservable: Observable<String> {
    titleTextField.rx.text.orEmpty.asObservable()
  }
  
  var folderColorObservable: Observable<String> {
    Observable.just(colorTextField.getColorHexString())
  }
  
  func bindAction(reactor: FolderCreationReactor) {
    typealias Action = FolderCreationReactor.Action

    createFolderButton.rx.tap
      .withUnretained(self)
      .flatMap { owner, _ in
        Observable.combineLatest(owner.folderTitleObservable, owner.folderColorObservable)
      }
      .map { [weak self] in
        let requestDTO = FolderRequestDTO(title: $0, color: $1)
        if self?.creationType == .edit {
          guard let originFolder = self?.originFolder else { fatalError() }
          return Action.didTapUpdateFolderButton(id: originFolder.id, folder: requestDTO)
        }
        return Action.didTapCreateFolderButton(requestDTO)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    tapGesture.rx.event
      .asDriver()
      .drive(onNext: { [weak self] _ in
        self?.showBottomSheet()
      })
      .disposed(by: disposeBag)
  }
  
  func bindCreateFolderButton() {
    Observable.combineLatest(isEnableFolderNameObservable, isEnableFolderColorObservable)
      .map { $0 && $1 }
      .bind(to: isEnableCreateFolderButtonBinder)
      .disposed(by: disposeBag)
    
    isEnableFolderNameObservable
      .bind(to: titleErrorLabel.rx.isHidden)
      .disposed(by: disposeBag)
    
    isEnableFolderColorObservable
      .bind(to: colorErrorLabel.rx.isHidden)
      .disposed(by: disposeBag)
  }
  
  //MARK: - BottomSheet
  func showBottomSheet() {
    let bottomSheet: BottomSheetViewController = .init(
      .folder,
      dataSource: colorDataSource,
      selectedIndexRelay: selectedColorIndexRelay
    )
    bottomSheet.modalPresentationStyle = .overCurrentContext
    present(bottomSheet, animated: true)
    
    selectedColorIndexRelay
      .withUnretained(self)
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { owner, index in
        guard index != -1 else { return }
        owner.colorTextField.setText(text: "이 컬러의 라벨을 달았어요")
        owner.colorTextField.setColor(color: owner.colorDataSource[index])
      })
      .disposed(by: disposeBag)
  }
  
  //MARK: - Keyboard
  func registerKeyboardNotification() {
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillShow(notification:)),
      name: UIResponder.keyboardWillShowNotification,
      object: nil
    )
    
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(keyboardWillHide(_:)),
      name: UIResponder.keyboardWillHideNotification,
      object: nil
    )
  }
  
  func removeKeyboardNotification() {
    NotificationCenter.default.removeObserver(self)
  }
  
  @objc
  func keyboardWillShow(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
    else { return }
    let keyboardHeight = keyboardFrame.cgRectValue.height
    let safeAreaBottomHeight = view.safeAreaInsets.bottom
    
    createFolderButton.transform = CGAffineTransform(
      translationX: 0,
      y: safeAreaBottomHeight - keyboardHeight
    )
  }
  
  @objc
  func keyboardWillHide(_ sender: Notification) {
    createFolderButton.transform = .identity
  }
}
