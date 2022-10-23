//
//  SettingCell.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/10/22.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

final class SettingCell: UITableViewCell {

  // MARK: - Properties
  private let titleLabel: UILabel = .init()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods
  func configure(title: String) {
    titleLabel.text = title
  }
}

private extension SettingCell {
  func setupUI() {
    selectionStyle = .none
    backgroundColor = .white

    contentView.addSubview(titleLabel)

    titleLabel.do {
      $0.font = .systemFont(ofSize: 16)
    }

    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }
  }
}
