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
  private let cellHeight = UIScreen.main.bounds.height * 0.068
  private let cellWidth = UIScreen.main.bounds.width * 0.893
  
  private let colorView: UIView = .init().then {
    $0.cornerRadius([.topLeft, .bottomLeft], radius: 8)
  }
  
  private let nameLabel: UILabel = .init().then {
    $0.font = .t_B(16)
  }
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupPadding()
  }
  
  func configure(folder: Folder) {
    nameLabel.text = folder.title
    nameLabel.textColor = .toColor(folder.color)
    colorView.backgroundColor = .toColor(folder.color)
  }
}

private extension FolderTableViewCell {
  func setupUI() {
    backgroundColor = .white
    selectionStyle = .none
    
    contentView.backgroundColor = .white
//    contentView.layer.cornerRadius = 8
//    contentView.layer.borderWidth = 1
//    contentView.layer.borderColor = UIColor.t_borderColor().cgColor
    
    contentView.addSubview(colorView)
    contentView.addSubview(nameLabel)
    
    colorView.snp.makeConstraints {
      $0.leading.top.bottom.equalToSuperview()
      $0.width.equalTo(cellWidth * 0.047)
    }
    
    nameLabel.snp.makeConstraints {
      $0.leading.equalTo(colorView.snp.trailing).offset(24)
      $0.centerY.equalToSuperview()
    }
  }
  
  func setupPadding() {
    contentView.frame = contentView.frame.inset(
      by: UIEdgeInsets(
        top: 0,
        left: 0,
        bottom: 24,
        right: 0
      )
    )
  }
}
