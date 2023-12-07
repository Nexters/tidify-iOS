//
//  FolderCreationCollectionViewCell.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/11/22.
//  Copyright © 2023 Tidify. All rights reserved.
//

import TidifyDomain
import UIKit

import SnapKit

final class FolderCreationCollectionViewCell: UICollectionViewCell {

  // MARK: Properties
  private let colorView: UIView = .init()

  private let checkImageView: UIImageView = {
    let imageView: UIImageView = .init(image: .init(named: "colorSelectIcon"))
    imageView.isHidden = true
    return imageView
  }()

  // MARK: Initializer
  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
    setupLayoutConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    checkImageView.isHidden = true
  }

  // MARK: Methods
  func configure(color: UIColor) {
    colorView.backgroundColor = color
    colorView.cornerRadius(radius: contentView.frame.height / 2)
  }

  func setSelected(isSelected: Bool) {
    checkImageView.isHidden = !isSelected
  }
}

// MARK: - Private
private extension FolderCreationCollectionViewCell {
  func setupViews() {
    contentView.addSubview(colorView)
    colorView.addSubview(checkImageView)
  }

  func setupLayoutConstraints() {
    colorView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    checkImageView.snp.makeConstraints {
      $0.edges.equalToSuperview().inset(9)
    }
  }
}
