//
//  TidifyTextFieldView.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/11/22.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Combine
import UIKit

import SnapKit

final class TidifyTextFieldView: UIView {
  enum TextFieldViewType {
    case bookmarkURL
    case bookmarkTitle
    case folderTitle

    var title: String {
      switch self {
      case .bookmarkURL: return "URL"
      case .bookmarkTitle, .folderTitle: return "제목"
      }
    }

    var placeHolder: String {
      switch self {
      case .bookmarkURL: return "링크 주소를 입력해주세요"
      case .bookmarkTitle: return "입력하지 않아도 저장할 수 있어요"
      case .folderTitle: return "어떤 폴더인지 입력해주세요"
      }
    }

    var errorMessage: String {
      switch self {
      case .bookmarkURL: return "링크를 입력해주세요"
      case .bookmarkTitle: return ""
      case .folderTitle: return "제목을 입력해주세요"
      }
    }
  }

  private let textFieldViewType: TextFieldViewType

  private let containerView: UIView = {
    let view: UIView = .init()
    view.backgroundColor = .white
    view.cornerRadius(radius: 15)
    return view
  }()

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.textColor = .t_ashBlue(weight: 800)
    label.font = .t_EB(20)
    return label
  }()

  private lazy var errorLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .t_SB(12)
    label.textColor = .red
    label.isHidden = true
    return label
  }()

  private let textField: UITextField = {
    let textField: UITextField = .init(frame: .zero)
    textField.backgroundColor = .t_ashBlue(weight: 50)
    textField.cornerRadius(radius: 10)
    textField.font = .t_SB(14)
    textField.leftView = .init(frame: .init(x: 0, y: 0, width: 15, height: 0))
    textField.leftViewMode = .always
    return textField
  }()

  var textFieldSubject: CurrentValueSubject<String, Never> = .init("")

  private var cancellable: Set<AnyCancellable> = []

  init(type: TextFieldViewType) {
    self.textFieldViewType = type
    super.init(frame: .zero)

    titleLabel.text = type.title
    errorLabel.text = type.errorMessage

    setupViews()
    setupLayoutConstraints()
    setupErrorLabel()
    setupTextFieldPlaceHolder()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupText(text: String) {
    textField.text = text
  }
}

private extension TidifyTextFieldView {
  func setupViews() {
    addSubview(containerView)
    containerView.addSubview(titleLabel)
    containerView.addSubview(errorLabel)
    containerView.addSubview(textField)
  }

  func setupLayoutConstraints() {
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    titleLabel.snp.makeConstraints {
      $0.top.leading.equalToSuperview().inset(20)
      $0.height.equalTo(20)
    }

    errorLabel.snp.makeConstraints {
      $0.centerY.equalTo(titleLabel)
      $0.trailing.equalToSuperview().inset(20)
    }

    textField.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(15)
      $0.leading.trailing.equalToSuperview().inset(10)
      $0.bottom.equalToSuperview().offset(-15)
    }
  }

  func setupErrorLabel() {
    if textFieldViewType == .bookmarkTitle {
      return
    }

    textField.publisher
      .receive(on: DispatchQueue.main)
      .sink(receiveValue: { [weak self] text in
        self?.errorLabel.isHidden = !text.isEmpty
        self?.textFieldSubject.send(text)
      })
      .store(in: &cancellable)
  }

  func setupTextFieldPlaceHolder() {
    let attributedString: NSAttributedString = .init(
      string: textFieldViewType.placeHolder,
      attributes: [.font: UIFont.t_SB(14), .foregroundColor: UIColor.t_gray(weight: 400)]
    )
    textField.attributedPlaceholder = attributedString
  }
}
