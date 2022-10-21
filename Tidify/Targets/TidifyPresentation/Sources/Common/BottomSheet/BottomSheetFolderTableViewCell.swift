//
//  BottomSheetFolderTableViewCell.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/10/21.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

import SnapKit
import Then

final class BottomSheetFolderTableViewCell: UITableViewCell {
  private let checkImageView: UIImageView = .init()
  private let circleView: UIView = .init()
  private let stickColorView: StickColorView = .init()
  
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
  
  func configure(color: UIColor) {
    circleView.backgroundColor = color
    stickColorView.setColor(color)
  }
}

private extension BottomSheetFolderTableViewCell {
  func setupUI() {
    backgroundColor = .white
    selectionStyle = .none
    
    checkImageView.do {
      $0.image = UIImage(named: "uncheckIcon")
      addSubview($0)
    }
    
    circleView.do {
      $0.cornerRadius(radius: 15)
      addSubview($0)
    }
    
    stickColorView.do {
      addSubview($0)
    }
    
    checkImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }
    
    circleView.snp.makeConstraints {
      $0.leading.equalTo(checkImageView.snp.trailing).offset(52)
      $0.size.equalTo(30)
      $0.centerY.equalToSuperview()
    }
    
    stickColorView.snp.makeConstraints {
      $0.leading.equalTo(circleView.snp.trailing).offset(28)
      $0.width.equalTo(180)
      $0.height.equalTo(30)
      $0.top.bottom.equalToSuperview().inset(13)
    }
  }
}
