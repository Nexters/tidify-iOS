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
      $0.leading.trailing.equalToSuperview()
      $0.height.greaterThanOrEqualTo(Self.viewHeight * 0.068 + 22)
      $0.bottom.equalToSuperview()
    }
  }
}

extension TabBarController: TidifyTabBarDelegate {
  func didSelectTab(_ item: TabBarItem) {
    selectedIndex = item.index
  }
}
