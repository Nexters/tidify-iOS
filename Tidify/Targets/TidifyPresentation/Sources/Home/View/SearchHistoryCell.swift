//
//  SearchHistoryCell.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/09/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

protocol SearchHistoryCellDelegate: AnyObject {
  func didTapSearchTitle(_ title: String)
}

final class SearchHistoryCell: UITableViewCell {

  // MARK: - Properties
  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .t_B(15)
    label.textColor = .black
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  weak var delegate: SearchHistoryCellDelegate?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupUI()

    let gestureRecognizer = contentView.addTap()
    gestureRecognizer.addTarget(self, action: #selector(tapSearchHistoryCell))
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
    selectionStyle = .none

    NSLayoutConstraint.activate([
      titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
      titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
      titleLabel.trailingAnchor.constraint(lessThanOrEqualTo: contentView.trailingAnchor, constant: -10)
    ])
  }

  @objc func tapSearchHistoryCell() {
    delegate?.didTapSearchTitle(titleLabel.text ?? "")
  }
}
