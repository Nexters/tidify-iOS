//
//  TabBarController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

import SnapKit
import Then

final class TabBarController: UITabBarController {
  
  // MARK: - Properties
  private let tidifyTabBar: TidifyTabBar = .init()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupTabBar()
    setupUI()
  }
}

// MARK: - Methods
private extension TabBarController {
  func setupTabBar() {
    tidifyTabBar.delegate = self
    let reactor: TidifyTabBarReactor = .init()
    tidifyTabBar.reactor = reactor
  }
  
  func setupUI() {
    view.addSubview(tidifyTabBar)
    
    tidifyTabBar.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(76)
      $0.height.equalTo(Self.viewHeight * 0.068)
      $0.bottom.equalToSuperview().inset(38)
    }
  }
}

extension TabBarController: TidifyTabBarDelegate {
  func didSelectTab(_ item: TabBarItem) {
    selectedIndex = item.index
  }
}
