//
//  SettingTableHeaderView.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/10/22.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

final class SettingTableHeaderView: UIView {

  // MARK: - Properties
  private let titleLabel: UILabel = .init()

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension SettingTableHeaderView {
  func setupUI() {
    backgroundColor = .white
    addSubview(titleLabel)

    titleLabel.do {
      $0.text = "설정"
      $0.font = .systemFont(ofSize: 32, weight: .bold)
    }

    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
    }
  }
}
