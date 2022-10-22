//
//  BottomSheetBookmarkTableViewCell.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/10/21.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

import SnapKit
import Then

final class BottomSheetBookmarkTableViewCell: UITableViewCell {
  private let checkImageView: UIImageView = .init()
  private let titleLabel: UILabel = .init()
  
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func setSelected(_ selected: Bool, animated: Bool) {
    super.setSelected(selected, animated: animated)
    
    checkImageView.image = selected ? UIImage(named: "checkIcon") : UIImage(named: "uncheckIcon")
  }
  
  func configure(folderName: String) {
    titleLabel.text = folderName
  }
}

private extension BottomSheetBookmarkTableViewCell {
  func setupUI() {
    backgroundColor = .white
    selectionStyle = .none
    
    checkImageView.do {
      $0.image = UIImage(named: "uncheckIcon")
      addSubview($0)
    }
    
    titleLabel.do {
      $0.font = .t_SB(16)
      $0.textColor = .black
      addSubview($0)
    }
    
    checkImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }
    
    titleLabel.snp.makeConstraints {
      $0.leading.equalTo(checkImageView.snp.trailing).offset(24)
      $0.top.bottom.equalToSuperview().inset(20)
    }
  }
}
