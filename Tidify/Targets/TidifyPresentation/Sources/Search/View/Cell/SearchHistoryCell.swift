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
  private let rightArrowImageView: UIImageView = .init()

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
    contentView.addSubview(rightArrowImageView)
    selectionStyle = .none

    titleLabel.do {
      $0.font = .t_R(16)
      $0.textColor = .black
      $0.lineBreakMode = .byTruncatingTail
    }
    
    rightArrowImageView.do {
      $0.image = .init(named: "icon_arrowRight")
    }
    
    rightArrowImageView.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(12)
    }

    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.lessThanOrEqualTo(rightArrowImageView.snp.leading).inset(10)
    }
  }
}
