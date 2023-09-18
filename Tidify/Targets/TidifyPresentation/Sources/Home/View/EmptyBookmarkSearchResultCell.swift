//
//  EmptyBookmarkSearchResultCell.swift
//  TidifyPresentation
//
//  Created by 여정수 on 2023/09/18.
//  Copyright © 2023 Tidify. All rights reserved.
//

import UIKit

final class EmptyBookmarkSearchResultCell: UITableViewCell {

  // MARK: Properties
  private let containerView: UIView = {
    let view: UIView = .init()
    view.backgroundColor = .white
    view.cornerRadius(radius: 15)
    view.translatesAutoresizingMaskIntoConstraints = false
    return view
  }()

  private let exclameImageView: UIImageView = {
    let imageView: UIImageView = .init(image: .init(named: "home_exclamationMark"))
    imageView.translatesAutoresizingMaskIntoConstraints = false
    return imageView
  }()

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.text = "북마크를 찾을 수 없어요"
    label.font = .t_EB(20)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let descLabel: UILabel = {
    let label: UILabel = .init()
    label.text = "다른 키워드를 입력해주세요"
    label.numberOfLines = 2
    label.font = .t_R(16)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension EmptyBookmarkSearchResultCell {
  func setupLayout() {
    contentView.addSubview(containerView)

    [exclameImageView, titleLabel, descLabel].forEach { containerView.addSubview($0) }

    NSLayoutConstraint.activate([
      containerView.topAnchor.constraint(equalTo: contentView.topAnchor),
      containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
      containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
      containerView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor),

      exclameImageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
      exclameImageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),

      titleLabel.topAnchor.constraint(equalTo: exclameImageView.bottomAnchor, constant: 20),
      titleLabel.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
      titleLabel.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),

      descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
      descLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      descLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      descLabel.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
    ])
  }
}
