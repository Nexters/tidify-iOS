//
//  TidifyNavigationBar.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/13.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

import SnapKit

final class TidifyNavigationBar: UIView {

  // MARK: Properties
  private let leftButtonStackView: UIStackView
  private let settingButton: UIButton

  init(leftButtonStackView: UIStackView, settingButton: UIButton) {
    self.leftButtonStackView = leftButtonStackView
    self.settingButton = settingButton
    super.init(frame: .zero)

    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension TidifyNavigationBar {
  func setupUI() {
    backgroundColor = .clear

    addSubview(leftButtonStackView)
    addSubview(settingButton)

    leftButtonStackView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.bottom.equalToSuperview().inset(10)
    }

    settingButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(26)
      $0.top.bottom.equalToSuperview().inset(11)
      $0.width.equalTo(settingButton.snp.height)
    }
  }
}
