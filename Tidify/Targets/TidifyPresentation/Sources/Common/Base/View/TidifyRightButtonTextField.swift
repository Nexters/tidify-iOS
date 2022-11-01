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

  var isEmptyTextObsevable: Observable<Bool> {
    textField.rx.text
      .orEmpty
      .map { $0.isEmpty }
      .asObservable()
  }

  func setText(text: String) {
    textField.text = text
  }
  
  func setColor(color: UIColor) {
    textField.textColor = color
  }
}

// MARK: - Private
private extension TidifyRightButtonTextField {
  func setupUI() {
    addSubview(textField)
    addSubview(rightButton)

    textField.do {
      let attrString: NSAttributedString = .init(
        string: placeholder,
        attributes: [.foregroundColor: UIColor.gray]
      )

      $0.leftView = .init(frame: .init(x: 0, y: 0, width: 20, height: 0))
      $0.leftViewMode = .always
      $0.attributedPlaceholder = attrString
      $0.backgroundColor = .white
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor.init(hex: "3C3C43").withAlphaComponent(0.08).cgColor
      $0.cornerRadius(radius: 16)
      $0.font = .t_SB(16)
      $0.textColor = .black
      $0.isUserInteractionEnabled = false
    }

    rightButton.do {
      if let rightButtonImage = rightButtonImage {
        $0.setImage(rightButtonImage, for: .normal)
        $0.imageView?.contentMode = .scaleAspectFit
      }
      $0.backgroundColor = .clear
    }

    textField.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    rightButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-20)
      $0.centerY.equalToSuperview()
    }
  }
}
