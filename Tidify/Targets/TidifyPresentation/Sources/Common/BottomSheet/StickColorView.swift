//
//  StickColorView.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/10/21.
//  Copyright © 2022 Tidify. All rights reserved.
//

import SnapKit
import Then
import UIKit

final class StickColorView: UIView {
  private let leftColorView: UIView = .init()
  private let whiteStickView: UIView = .init()
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setColor(_ color: UIColor) {
    leftColorView.backgroundColor = color
  }
}

private extension StickColorView {
  func setupUI() {
    whiteStickView.do {
      $0.cornerRadius([.topRight, .bottomRight], radius: 8)
      $0.layer.borderColor = UIColor.t_borderColor().cgColor
      $0.layer.borderWidth = 1
      addSubview($0)
    }

    leftColorView.do {
      $0.cornerRadius([.topLeft, .bottomLeft], radius: 8)
      addSubview($0)
    }
    
    leftColorView.snp.makeConstraints {
      $0.top.leading.bottom.equalToSuperview()
      $0.width.equalTo(9)
      $0.height.equalTo(30)
    }
    
    whiteStickView.snp.makeConstraints {
      $0.top.trailing.bottom.equalToSuperview()
      $0.leading.equalTo(leftColorView.snp.trailing)
      $0.width.equalTo(171)
      $0.height.equalTo(30)
    }
  }
}
