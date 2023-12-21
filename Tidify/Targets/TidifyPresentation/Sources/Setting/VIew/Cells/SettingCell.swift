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
  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .t_B(15)
    label.textColor = .t_ashBlue(weight: 800)
    return label
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods
  func configure(title: String, isLastIndex: Bool) {
    titleLabel.text = title
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalToSuperview().inset(17)
      $0.bottom.equalToSuperview().inset(isLastIndex ? 27 : 17)
    }
  }
}

// MARK: - Private
private extension SettingCell {
  func setupUI() {
    selectionStyle = .none
    backgroundColor = .white

    contentView.addSubview(titleLabel)
  }
}
