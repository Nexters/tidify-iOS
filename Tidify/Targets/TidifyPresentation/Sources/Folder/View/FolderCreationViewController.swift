//
//  FolderCreationViewController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/10/19.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Combine
import TidifyDomain
import UIKit

import SnapKit

enum CreationType {
  case create
  case edit
}

final class FolderCreationViewController: BaseViewController, Coordinatable, Alertable {

  // MARK: Properties
  weak var coordinator: DefaultFolderCreationCoordinator?
  private let viewModel: FolderCreationViewModel
  private let creationType: CreationType
  private let originFolder: Folder?
  private let textFieldView: TidifyTextFieldView
  @Published private var selectedColor: UIColor? = nil

  private let colorDataSource: [UIColor] = [
    .t_pink(), .t_red(), .t_orange(), .t_yellow(), .t_green(),
    .t_mint(), .t_ashBlue(), .t_purple(), .t_indigo(), .t_blue()
  ]

  private lazy var saveButton: UIButton = {
    let button: UIButton = .init()
    button.backgroundColor = .t_ashBlue(weight: 100)
    button.setTitle("저장", for: .normal)
    button.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
    button.titleLabel?.font = .t_SB(18)
    button.cornerRadius(radius: 10)
    button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
    button.isEnabled = false
    return button
  }()

  private let colorContainerView: UIView = {
    let view: UIView = .init()
    view.backgroundColor = .white
    view.cornerRadius(radius: 15)
    return view
  }()

  private let colorTitleLabel: UILabel = {
    let label: UILabel = .init()
    label.textColor = .t_ashBlue(weight: 800)
    label.font = .t_EB(20)
    label.text = "라벨"
    return label
  }()

  private lazy var colorCollectionView: UICollectionView = {
    let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    collectionView.isScrollEnabled = false
    collectionView.t_registerCellClass(cellType: FolderCreationCollectionViewCell.self)
    collectionView.backgroundColor = .white
    collectionView.delegate = self
    collectionView.dataSource = self
    return collectionView
  }()

  // MARK: Initializer
  init(viewModel: FolderCreationViewModel, creationType: CreationType, originFolder: Folder? = nil) {
    self.viewModel = viewModel
    self.creationType = creationType
    self.originFolder = originFolder
    self.textFieldView = .init(type: .folderTitle)
    super.init(nibName: nil, bundle: nil)
    title = creationType == .create ? "폴더 생성" : "폴더 편집"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayoutConstraints()
    bindState()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    registerKeyboardNotification()
    textFieldView.setFirstResponder()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    removeKeyboardNotification()
    coordinator?.didFinish()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    super.touchesBegan(touches, with: event)
    view.endEditing(true)
  }

  override func setupViews() {
    super.setupViews()

    view.addSubview(textFieldView)
    view.addSubview(colorContainerView)
    colorContainerView.addSubview(colorTitleLabel)
    colorContainerView.addSubview(colorCollectionView)
    view.addSubview(saveButton)
  }
}

extension FolderCreationViewController: UICollectionViewDelegate, UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return colorDataSource.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    let cell: FolderCreationCollectionViewCell = collectionView.t_dequeueReusableCell(indexPath: indexPath)
    cell.configure(color: colorDataSource[indexPath.row])

    if let originFolder = originFolder,
       originFolder.color == colorDataSource[indexPath.row].toColorString() {
      selectedColor = colorDataSource[indexPath.row]
      textFieldView.setupText(text: originFolder.title)
      textFieldView.textFieldSubject.send(originFolder.title)
      cell.setSelected(isSelected: true)
      collectionView.selectItem(at: indexPath, animated: false, scrollPosition: .init())
    }
    return cell
  }

  func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? FolderCreationCollectionViewCell else {
      return
    }
    selectedColor = colorDataSource[indexPath.row]
    cell.setSelected(isSelected: true)
  }

  func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
    guard let cell = collectionView.cellForItem(at: indexPath) as? FolderCreationCollectionViewCell else {
      return
    }

    cell.setSelected(isSelected: false)
  }
}

extension FolderCreationViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    let size = collectionView.frame.height * 0.4
    return .init(w: size, h: size)
  }

  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
    return collectionView.frame.height * 0.185
  }
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
    return collectionView.frame.width * 0.078
  }
}

// MARK: - private
private extension FolderCreationViewController {
  func setupLayoutConstraints() {
    textFieldView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
      $0.leading.trailing.equalToSuperview().inset(15)
      $0.height.equalTo(Self.viewHeight * 0.13)
    }

    colorContainerView.snp.makeConstraints {
      $0.top.equalTo(textFieldView.snp.bottom).offset(15)
      $0.leading.trailing.equalTo(textFieldView)
      $0.height.equalTo(Self.viewHeight * 0.22)
    }

    colorTitleLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview().inset(20)
      $0.height.equalTo(20)
    }

    colorCollectionView.snp.makeConstraints {
      $0.top.equalTo(colorTitleLabel.snp.bottom).offset(20)
      $0.leading.trailing.bottom.equalToSuperview().inset(20)
    }

    saveButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(25)
      $0.bottom.equalToSuperview().offset(-50)
      $0.height.equalTo(Self.viewHeight * 0.066)
    }
  }

  func bindState() {
    textFieldView.textFieldSubject
      .combineLatest($selectedColor)
      .sink(receiveValue: { [weak saveButton] text, color in
        let isEnable = (!text.isEmpty && color.isNotNil)
        saveButton?.isEnabled = isEnable
        saveButton?.backgroundColor = isEnable ? .t_blue() : .t_ashBlue(weight: 100)
        saveButton?.setTitleColor(isEnable ? .t_ashBlue(weight: 50) : .t_ashBlue(weight: 300), for: .normal)
      })
      .store(in: &cancellable)

    viewModel.$state
      .map { $0.isSuccess }
      .filter { $0 }
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] _ in
        self?.coordinator?.didFinish()
      })
      .store(in: &cancellable)

    viewModel.$state
      .map { $0.errorType }
      .compactMap { $0 }
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] error in
        self?.presentAlert(type: .folderCreationError)
      })
      .store(in: &cancellable)
  }

  @objc func didTapSaveButton() {
    guard let selectedColor = selectedColor else {
      return
    }

    let requestDTO: FolderRequestDTO = .init(
      title: textFieldView.textFieldSubject.value,
      color: selectedColor.toColorString()
    )

    if creationType == .edit {
      guard let originFolder = originFolder else {
        return
      }
      viewModel.action(.didTapUpdateFolderButton(id: originFolder.id, requestDTO: requestDTO))
    } else {
      viewModel.action(.didTapCreateFolderButton(requestDTO))
    }
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
  
  @objc func keyboardWillShow(notification: Notification) {
    guard let userInfo = notification.userInfo,
          let keyboardFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue else {
      return
    }
    let keyboardHeight = keyboardFrame.cgRectValue.height
    let safeAreaBottomHeight = view.safeAreaInsets.bottom
    
    saveButton.transform = CGAffineTransform(
      translationX: 0,
      y: safeAreaBottomHeight - keyboardHeight
    )
  }
  
  @objc func keyboardWillHide(_ sender: Notification) {
    saveButton.transform = .identity
  }
}
