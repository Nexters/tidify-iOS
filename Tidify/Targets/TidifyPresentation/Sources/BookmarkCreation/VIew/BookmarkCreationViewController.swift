//
//  BookmarkCreationViewController.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain
import UIKit

import ReactorKit
import SnapKit
import RxRelay

final class BookmarkCreationViewController: UIViewController, View {

  // MARK: - Properties
  private var urlGuideLabel: UILabel = .init()
  private var urlTextField: UITextField = .init()
  private let urlErrorLabel: UILabel = .init()
  private var bookmarkGuideLabel: UILabel = .init()
  private var nameTextField: UITextField = .init()
  private var folderGuideLabel: UILabel = .init()
  private var createBookmarkButton: UIButton = .init()
  private var folderTextField: TidifyRightButtonTextField = .init(
    placeholder: "폴더 선택",
    rightButtonImage: .init(named: "icon_arrowDown_gray")
  )

  var disposeBag: DisposeBag = .init()
  private let selectedFolderIndexRelay: BehaviorRelay<Int> = .init(value: -1)

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
  }

  func bind(reactor: BookmarkCreationReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindExtra()
  }
}

// MARK: - Private
private extension BookmarkCreationViewController {
  typealias Action = BookmarkCreationReactor.Action

  func bindAction(reactor: BookmarkCreationReactor) {
    createBookmarkButton.rx.tap
      .map(createBookmarkButtonAction)
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    rx.viewWillAppear
      .map { Action.viewWillAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindState(reactor: BookmarkCreationReactor) {
    reactor.state
      .map { $0.folders }
      .subscribe()
      .disposed(by: disposeBag)
  }

  func bindExtra() {
    urlTextField.rx.text.orEmpty
      .map(isEnableUrlTextField)
      .bind(to: isEnableCreateBookmarkButtonBinder)
      .disposed(by: disposeBag)


    view.addTap().rx.event
      .filter { $0.state == .recognized }
      .asDriver(onErrorDriveWith: .empty())
      .drive(with: self, onNext: { owner, _ in
        owner.view.endEditing(true)
      })
      .disposed(by: disposeBag)

    folderTextField.addTap().rx.event
      .filter { $0.state == .recognized }
      .asDriver(onErrorDriveWith: .empty())
      .drive(with: self, onNext: { owner, _ in
        owner.showBottomSheet()
      })
      .disposed(by: disposeBag)

    selectedFolderIndexRelay
      .bind(to: didSelectFolderBinder)
      .disposed(by: disposeBag)
  }

  func setupUI() {
    let sidePadding: CGFloat = 20

    title = "북마크 생성"
    view.backgroundColor = .white
    navigationController?.navigationBar.topItem?.title = ""

    view.addSubview(urlGuideLabel)
    view.addSubview(urlErrorLabel)
    view.addSubview(urlTextField)
    view.addSubview(bookmarkGuideLabel)
    view.addSubview(nameTextField)
    view.addSubview(folderGuideLabel)
    view.addSubview(folderTextField)
    view.addSubview(createBookmarkButton)

    urlGuideLabel = setGuideLabel(urlGuideLabel, title: "주소입력")
    urlTextField = setTextField(urlTextField, placeholder: "URL 주소를 넣어주세요")

    bookmarkGuideLabel = setGuideLabel(bookmarkGuideLabel, title: "북마크 이름")
    nameTextField = setTextField(nameTextField, placeholder: "입력하지 않으면 자동으로 저장돼요")

    folderGuideLabel = setGuideLabel(folderGuideLabel, title: "저장할 폴더")

    urlErrorLabel.do {
      $0.textColor = .systemRed
      $0.font = .t_SB(14)
    }

    createBookmarkButton.do {
      $0.setTitle("저장", for: .normal)
      $0.titleLabel?.font = .t_SB(19)
      $0.setTitleColor(.systemGray2, for: .normal)
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor.t_borderColor().cgColor
      $0.isEnabled = false
      $0.cornerRadius(radius: 16)
    }

    urlGuideLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.lessThanOrEqualToSuperview()
    }

    urlErrorLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(20)
      $0.centerY.equalTo(urlGuideLabel)
    }

    urlTextField.snp.makeConstraints {
      $0.top.equalTo(urlGuideLabel.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.equalToSuperview().offset(-sidePadding)
      $0.height.equalTo(Self.viewHeight * 0.067)
    }

    bookmarkGuideLabel.snp.makeConstraints {
      $0.top.equalTo(urlTextField.snp.bottom).offset(40)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.lessThanOrEqualToSuperview()
    }

    nameTextField.snp.makeConstraints {
      $0.top.equalTo(bookmarkGuideLabel.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.equalToSuperview().offset(-sidePadding)
      $0.height.equalTo(Self.viewHeight * 0.067)
    }

    folderGuideLabel.snp.makeConstraints {
      $0.top.equalTo(nameTextField.snp.bottom).offset(40)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.lessThanOrEqualToSuperview()
    }

    folderTextField.snp.makeConstraints {
      $0.top.equalTo(folderGuideLabel.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.equalToSuperview().offset(-sidePadding)
      $0.height.equalTo(Self.viewHeight * 0.067)
    }

    createBookmarkButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.equalToSuperview().offset(-sidePadding)
      $0.bottom.equalToSuperview().offset(-40)
      $0.height.equalTo(Self.viewHeight * 0.068)
    }
  }

  func setGuideLabel(_ label: UILabel, title: String) -> UILabel {
    label.do {
      $0.text = title
      $0.font = .t_B(16)
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
      $0.font = .t_R(16)
      $0.textColor = .black
    }

    return textField
  }

  func showBottomSheet() {
    guard let folders = reactor?.currentState.folders,
          !folders.isEmpty else {
      return
    }

    let bottomSheet: BottomSheetViewController = .init(
      .bookmark,
      dataSource: folders.map { $0.title },
      selectedIndexRelay: selectedFolderIndexRelay
    )

    bottomSheet.modalPresentationStyle = .overCurrentContext
    present(bottomSheet, animated: true)
  }

  func isEnableUrlTextField(_ text: String) -> Bool {
    if text.isEmpty {
      urlErrorLabel.text = "링크가 없어요"
      urlErrorLabel.isHidden = false
      return false
    }

    guard let url = URL(string: text),
          ["http", "https"].contains(url.scheme?.lowercased() ?? ""),
          text.count >= 10 else {
      urlErrorLabel.text = "링크를 확인해주세요"
      urlErrorLabel.isHidden = false
      return false
    }

    urlErrorLabel.isHidden = true
    return true
  }

  func createBookmarkButtonAction() -> Action {
    let url: String = urlTextField.text ?? ""
    let name: String = nameTextField.text ?? url
    var folderID: Int = 0

    if let reactor = reactor,
       selectedFolderIndexRelay.value != -1 {
      folderID = reactor.currentState.folders[selectedFolderIndexRelay.value].id
    }

    let requestDTO: BookmarkRequestDTO = .init(
      folderID: folderID,
      url: url,
      name: name
    )

    return .didTapCreateButton(requestDTO)
  }
}

private extension BookmarkCreationViewController {
  var isEnableCreateBookmarkButtonBinder: Binder<Bool> {
    return .init(self) { owner, isEnable in
      owner.createBookmarkButton.isEnabled = isEnable
      owner.createBookmarkButton.backgroundColor = isEnable ? .t_tidiBlue00() : .clear
      owner.createBookmarkButton.setTitleColor(isEnable ? .white : .systemGray2, for: .normal)
      owner.createBookmarkButton.layer.borderColor = isEnable ? UIColor.clear.cgColor : UIColor.t_borderColor().cgColor
    }
  }

  var didSelectFolderBinder: Binder<Int> {
    return .init(self) { owner, selectedIndex in
      guard selectedIndex != -1,
            let selectedFolder: Folder = owner.reactor?.currentState.folders[selectedIndex] else {
        return
      }

      owner.folderTextField.setText(text: selectedFolder.title)
      owner.folderTextField.setColor(color: .toColor(selectedFolder.color))
    }
  }
}
