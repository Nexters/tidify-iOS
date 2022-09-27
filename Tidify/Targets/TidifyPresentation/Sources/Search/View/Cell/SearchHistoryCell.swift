//
//  SearchHistoryCell.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/09/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

final class SearchHistoryCell: UITableViewCell {

  // MARK: - Properties
  private let titleLabel: UILabel = .init()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    titleLabel.text = nil
  }

  func configure(title: String) {
    titleLabel.text = title
  }
}

// MARK: - Private
private extension SearchHistoryCell {
  func setupUI() {
    contentView.addSubview(titleLabel)
    self.accessoryType = .disclosureIndicator

    titleLabel.do {
      $0.font = .t_R(16)
      $0.textColor = .black
    }

    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.lessThanOrEqualToSuperview().offset(-36)
    }
  }
}
