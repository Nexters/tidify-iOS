//
//  TabBarController.swift
//  TidifyDataTests
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import SnapKit
import Then
import UIKit

class TabBarController: UITabBarController {
  
  // MARK: - Properties
  weak var coordinator: TabBarCoordinator?
  
  private let tidifyTabBar: TidifyTabBar = .init()
  
  // MARK: - LifeCycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
}

// MARK: - Methods
private extension TabBarController {
  func setupUI() {
    tidifyTabBar.delegate = self
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
