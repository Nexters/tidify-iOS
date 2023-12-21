//
//  SearchTableViewCell.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/12/15.
//  Copyright © 2023 Tidify. All rights reserved.
//

import UIKit

final class SearchTableViewCell: UITableViewCell {

  // MARK: Properties
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
  func configure(title: String) {
    titleLabel.text = title
  }
}

// MARK: - Private
private extension SearchTableViewCell {
  func setupUI() {
    selectionStyle = .none
    backgroundColor = .white

    contentView.addSubview(titleLabel)
    titleLabel.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().offset(20)
      $0.top.bottom.equalToSuperview().inset(17)
    }
  }
}
