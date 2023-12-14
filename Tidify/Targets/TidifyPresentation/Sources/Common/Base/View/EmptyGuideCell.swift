//
//  EmptyGuideCell.swift
//  TidifyPresentation
//
//  Created by 여정수 on 2023/09/18.
//  Copyright © 2023 Tidify. All rights reserved.
//

import TidifyDomain
import UIKit

protocol EmptyGuideCellDelegate: AnyObject {
  func didTapShowGuideButton()
}

final class EmptyGuideCell: UITableViewCell {

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
    label.font = .t_EB(20)
    label.textColor = .t_ashBlue(weight: 800)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private let descLabel: UILabel = {
    let label: UILabel = .init()
    label.numberOfLines = 2
    label.font = .t_R(16)
    label.textColor = .t_gray(weight: 700)
    label.translatesAutoresizingMaskIntoConstraints = false
    return label
  }()

  private lazy var guideButton: UIButton = {
    let button: UIButton = .init()
    button.backgroundColor = .t_blue()
    button.setTitle("가이드 보기", for: .normal)
    button.titleLabel?.font = .t_B(16)
    button.setTitleColor(.white, for: .normal)
    button.cornerRadius(radius: 10)
    button.translatesAutoresizingMaskIntoConstraints = false
    button.addTarget(self, action: #selector(didTapShowGuideButton), for: .touchUpInside)
    return button
  }()

  weak var delegate: EmptyGuideCellDelegate?

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupLayout()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupBookmarkGuideLabel() {
    titleLabel.text = "아직 모아놓은 북마크가 없어요"
    descLabel.text = "깔끔한 정리를 도와주는\n티디파이 가이드를 보러 가실래요?"
  }

  func setupFolderGuideLabel(category: FolderCategory) {
    switch category {
    case .normal:
      titleLabel.text = "아직 정리된 폴더가 없어요"
      descLabel.text = "깔끔한 정리를 도와주는\n티디파이 가이드를 보러 가실래요?"
    case .share:
      titleLabel.text = "연재중인 폴더가 없어요"
      descLabel.text = "다른 사람들에게 내가 정리한 폴더를\n공유하는 방법을 알아볼까요?"
    case .subscribe:
      titleLabel.text = "구독중인 폴더가 없어요"
      descLabel.text = "다른 사람이 정리한 폴더를 볼 수 있는\n초대링크를 받아보셨나요?"
    }
  }
}

private extension EmptyGuideCell {
  @objc func didTapShowGuideButton() {
    delegate?.didTapShowGuideButton()
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
