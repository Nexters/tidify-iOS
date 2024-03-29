//
//  FolderTableViewCell.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/16.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain
import UIKit

final class FolderTableViewCell: UITableViewCell {

  // MARK: Properties
  private let colorView: UIView = {
    let view: UIView = .init(frame: .zero)
    view.cornerRadius(radius: 2)
    return view
  }()
  
  private let nameLabel: UILabel = {
    let label: UILabel = .init(frame: .zero)
    label.font = .t_B(15)
    label.textColor = .t_ashBlue(weight: 800)
    return label
  }()

  private let countLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .t_SB(14)
    label.textColor = .t_gray(weight: 500)
    return label
  }()

  private lazy var checkImageView: UIImageView = {
    let imageView: UIImageView = .init(image: .init(named: "folderSelectIcon"))
    imageView.isHidden = true
    return imageView
  }()

  // MARK: Initializer
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    checkImageView.isHidden = true
  }

  // MARK: Methods
  func configure(folder: Folder, category: FolderCategory? = nil) {
    nameLabel.text = folder.title
    colorView.backgroundColor = .toColor(folder.color)

    if let category {
      countLabel.text = category == .share ? "\(folder.count)명 구독중" : "\(folder.count)개 정리됨"
    } else {
      countLabel.isHidden = true
    }
  }

  func setSelected(isSelected: Bool) {
    checkImageView.isHidden = !isSelected
  }
}

// MARK: - Private
private extension FolderTableViewCell {
  func setupUI() {
    selectionStyle = .none
    contentView.backgroundColor = .white
    contentView.addSubview(colorView)
    contentView.addSubview(nameLabel)
    contentView.addSubview(countLabel)
    contentView.addSubview(checkImageView)
    
    colorView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.bottom.equalToSuperview().inset(15)
      $0.width.equalTo(UIViewController.viewWidth * 0.025)
    }

    countLabel.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(20)
      $0.centerY.equalToSuperview()
    }

    nameLabel.snp.makeConstraints {
      $0.leading.equalTo(colorView.snp.trailing).offset(20)
      $0.trailing.lessThanOrEqualTo(countLabel.snp.trailing).inset(80)
      $0.centerY.equalToSuperview()
    }

    checkImageView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(18)
      $0.trailing.equalToSuperview().inset(20)
      $0.width.equalTo(checkImageView.snp.height)
    }
  }
}
