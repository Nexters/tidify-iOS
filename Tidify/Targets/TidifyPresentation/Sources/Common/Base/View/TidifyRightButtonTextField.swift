//
//  TidifyRightButtonTextField.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/10/19.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

import RxSwift

final class TidifyRightButtonTextField: UIView {

  // MARK: - Properties
  private let rightButton: UIButton = .init()
  private let textField: UITextField = .init()
  private let rightButtonImage: UIImage?

  private let placeholder: String

  init(
    placeholder: String,
    rightButtonImage: UIImage? = nil
  ) {
    self.placeholder = placeholder
    self.rightButtonImage = rightButtonImage

    super.init(frame: .zero)

    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension TidifyRightButtonTextField {
  var rightButtonTap: Observable<Void> {
    rightButton.rx.tap
      .asObservable()
  }

  func setText(text: String) {
    textField.text = text
  }

  func setColor(color: UIColor) {
    textField.textColor = color
  }

  func getColorString() -> String {
    guard let textColor = textField.textColor else { return .init() }

    return textColor.toColorString()
  }
}

// MARK: - Private
private extension TidifyRightButtonTextField {
  func setupUI() {
    addSubview(textField)
    addSubview(rightButton)

    textField.leftView = .init(frame: .init(x: 0, y: 0, width: 20, height: 0))
    textField.leftViewMode = .always
    textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [.foregroundColor: UIColor.gray])
    textField.backgroundColor = .white
    textField.cornerRadius(radius: 16)
    textField.font = .t_SB(16)
    textField.textColor = .black
    textField.isUserInteractionEnabled = false

    if let rightButtonImage {
      rightButton.setImage(rightButtonImage, for: .normal)
      rightButton.imageView?.contentMode = .scaleAspectFill

    }

    rightButton.backgroundColor = .clear

    textField.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    rightButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalToSuperview()
    }
  }
}
