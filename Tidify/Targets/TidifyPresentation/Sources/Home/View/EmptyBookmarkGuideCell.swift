//
//  EmptyBookmarkGuideCell.swift
//  TidifyPresentation
//
//  Created by 여정수 on 2023/09/18.
//  Copyright © 2023 Tidify. All rights reserved.
//

import UIKit

protocol EmptyBookmarkGuideCellDelegate: AnyObject {
  func didTapShowGuideButton()
}

final class EmptyBookmarkGuideCell: UITableViewCell {

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
    label.text = "아직 모아놓은 북마크가 없어요"
    label.font = .t_EB(20)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let descLabel: UILabel = {
    let label: UILabel = .init()
    label.text = "깔끔한 정리를 도와주는\n티디파이 가이드를 보러 가실래요?"
    label.numberOfLines = 2
    label.font = .t_R(16)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var guideButton: UIButton = {
    let button: UIButton = .init()
    button.backgroundColor = .init(28, 100, 234)
    button.setTitle("가이드 보기", for: .normal)
    button.titleLabel?.font = .t_B(16)
    button.setTitleColor(.white, for: .normal)
    button.cornerRadius(radius: 10)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(didTapShowGuideButton), for: .touchUpInside)
    return button
  }()

  weak var delegate: EmptyBookmarkGuideCellDelegate?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension EmptyBookmarkGuideCell {
  @objc func didTapShowGuideButton() {
    // TODO
  }

  func setupLayout() {
    contentView.addSubview(containerView)

    [exclameImageView, titleLabel, descLabel, guideButton].forEach { containerView.addSubview($0)}

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

      guideButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20),
      guideButton.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
      guideButton.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
      guideButton.heightAnchor.constraint(equalToConstant: 50),

      descLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 15),
      descLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
      descLabel.trailingAnchor.constraint(equalTo: titleLabel.trailingAnchor),
      descLabel.bottomAnchor.constraint(equalTo: guideButton.topAnchor, constant: -40)
    ])
  }
}
