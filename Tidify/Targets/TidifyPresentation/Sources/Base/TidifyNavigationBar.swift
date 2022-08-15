//
//  TidifyNavigationBar.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/13.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

import SnapKit
import Then

final class TidifyNavigationBar: UIView {
  private let viewHeight = UIScreen.main.bounds.height
  private let viewWidth = UIScreen.main.bounds.width
  
  enum NavigationBarStyle {
    case normal
    case home
    case folder
    case folderDetail
    
    var sidePadding: CGFloat {
      switch self {
      case .normal, .folderDetail: return 8
      case .home, .folder : return 20
      }
    }
    
    var bottomPadding: CGFloat {
      switch self {
      case .normal: return 10
      case .home, .folder, .folderDetail: return 24
      }
    }
  }
  
  // MARK: - Properties
  
  private lazy var titleLabel: UILabel = .init().then {
    $0.font = .t_EB(16)
    $0.textColor = .black
  }
  
  private let leftButton: UIButton
  
  private let rightButton: UIButton?
  
  private let navigationBarStyle: NavigationBarStyle
  
  // MARK: - Initialize
  
  init(
    _ navigationBarStyle: NavigationBarStyle,
    title: String? = nil,
    leftButton: UIButton,
    rightButton: UIButton? = nil
  ) {
    self.navigationBarStyle = navigationBarStyle
    self.leftButton = leftButton
    self.rightButton = rightButton
    super.init(frame: .zero)
    self.titleLabel.text = title
    
    setupUI(
      navigationBarStyle,
      title: title,
      leftButton: leftButton,
      rightButton: rightButton
    )
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Methods
  
  func setupUI(
    _ navigationBarStyle: NavigationBarStyle,
    title: String?,
    leftButton: UIButton,
    rightButton: UIButton?
  ) {
    backgroundColor = .white
    
    addSubview(leftButton)
    
    if navigationBarStyle != .normal {
      cornerRadius([.bottomLeft, .bottomRight], radius: 16)
    }
    
    if navigationBarStyle == .folderDetail {
      titleLabel.font = .t_EB(20)
    }
    
    leftButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(navigationBarStyle.sidePadding)
      $0.bottom.equalToSuperview().inset(navigationBarStyle.bottomPadding)
      $0.size.equalTo(Self.viewWidth * 0.106)
    }
    
    if let rightButton = rightButton {
      addSubview(rightButton)
      rightButton.snp.makeConstraints {
        $0.bottom.equalToSuperview().inset(navigationBarStyle.bottomPadding)
        $0.trailing.equalToSuperview().inset(navigationBarStyle.sidePadding)
        $0.height.equalTo(Self.viewHeight * 0.049)
        $0.width.equalTo(Self.viewWidth * (navigationBarStyle == .home ? 0.208 : 0.106))
      }
    }
    
    if let _ = title {
      addSubview(titleLabel)
      titleLabel.snp.makeConstraints {
        $0.centerY.equalTo(leftButton).offset(-3)
        if navigationBarStyle != .folderDetail {
          $0.centerX.equalToSuperview()
        } else {
          $0.leading.equalTo(leftButton.snp.trailing).offset(16)
        }
      }
    }
    
  }
}
