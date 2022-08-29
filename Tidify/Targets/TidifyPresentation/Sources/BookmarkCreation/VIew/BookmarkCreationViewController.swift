//
//  BookmarkCreationViewController.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

import ReactorKit

final class BookmarkCreationViewController: UIViewController, View {

  // MARK: - Properties
  private var urlGuideLabel: UILabel = .init()
  private var urlTextField: UITextField = .init()
  private var bookmarkGuideLabel: UILabel = .init()
  private var bookmarkTextField: UITextField = .init()
  private var folderGuideLabel: UILabel = .init()
  private var folderTextField: UITextField = .init()
  private var registerButton: UIButton = .init()
  private var invalidFormatURLGuideLabel: UILabel = .init()

  var disposeBag: DisposeBag = .init()

  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
  }

  func bind(reactor: BookmarkCreationReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
}

// MARK: - Private
private extension BookmarkCreationViewController {
  func bindAction(reactor: BookmarkCreationReactor) {

  }

  func bindState(reactor: BookmarkCreationReactor) {

  }

  func setupUI() {
    let sidePadding: CGFloat = 20

    title = "북마크 생성"
    view.backgroundColor = .white
    navigationController?.navigationBar.topItem?.title = ""

    view.addSubview(urlGuideLabel)
    view.addSubview(urlTextField)
    view.addSubview(bookmarkGuideLabel)
    view.addSubview(bookmarkTextField)
    view.addSubview(folderGuideLabel)
    view.addSubview(folderTextField)
    view.addSubview(registerButton)
    view.addSubview(invalidFormatURLGuideLabel)

    urlGuideLabel = setGuideLabel(urlGuideLabel, title: "주소입력")
    urlTextField = setTextField(urlTextField, placeholder: "URL 주소를 넣어주세요")

    bookmarkGuideLabel = setGuideLabel(bookmarkGuideLabel, title: "북마크 이름")
    bookmarkTextField = setTextField(bookmarkTextField, placeholder: "입력하지 않으면 자동으로 저장돼요")

    folderGuideLabel = setGuideLabel(folderGuideLabel, title: "저장할 폴더")
    folderTextField = setTextField(folderTextField, placeholder: "폴더 선택")
    folderTextField.do {
      $0.rightView = UIImageView(image: .init(named: "icon_arrowDown_gray"))
      $0.rightViewMode = .always
    }

    registerButton.do {
      $0.setTitle("저장", for: .normal)
      $0.titleLabel?.font = .t_SB(14)
      $0.setTitleColor(.systemGray2, for: .normal)
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor.lightGray.cgColor
      $0.cornerRadius(radius: 16)
    }

    invalidFormatURLGuideLabel.do {
      $0.font = .t_SB(14)
      $0.textColor = .systemRed
      $0.text = "링크를 확인해주세요!"
      $0.isHidden = true
    }

    urlGuideLabel.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(40)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.lessThanOrEqualToSuperview()
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

    bookmarkTextField.snp.makeConstraints {
      $0.top.equalTo(bookmarkGuideLabel.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.equalToSuperview().offset(-sidePadding)
      $0.height.equalTo(Self.viewHeight * 0.067)
    }

    folderGuideLabel.snp.makeConstraints {
      $0.top.equalTo(bookmarkTextField.snp.bottom).offset(40)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.lessThanOrEqualToSuperview()
    }

    folderTextField.snp.makeConstraints {
      $0.top.equalTo(folderGuideLabel.snp.bottom).offset(16)
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.equalToSuperview().offset(-sidePadding)
      $0.height.equalTo(Self.viewHeight * 0.067)
    }

    registerButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(sidePadding)
      $0.trailing.equalToSuperview().offset(-sidePadding)
      $0.bottom.equalToSuperview().offset(-40)
      $0.height.equalTo(Self.viewHeight * 0.068)
    }

    invalidFormatURLGuideLabel.snp.makeConstraints {
      $0.centerY.equalTo(urlGuideLabel)
      $0.trailing.equalToSuperview().inset(sidePadding)
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
      $0.layer.borderColor = UIColor(hex: "3C3C43").withAlphaComponent(0.08).cgColor
      $0.cornerRadius(radius: 16)
      $0.font = .t_R(16)
      $0.textColor = .black
    }

    return textField
  }
}
