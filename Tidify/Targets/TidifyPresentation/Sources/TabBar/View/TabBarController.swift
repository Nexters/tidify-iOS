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

final class TabBarController: UITabBarController, Coordinatable {
  
  // MARK: - Properties
  private let tidifyTabBar: TidifyTabBar = .init()
  weak var coordinator: DefaultTabBarCoordinator?

  override func viewDidLoad() {
    super.viewDidLoad()
    tidifyTabBar.delegate = self
    setupUI()
  }
}

// MARK: - Methods
private extension TabBarController {
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
    if item == .bookmarkCreation {
      coordinator?.pushBookmarkCreationScene()
      return
    }

    selectedIndex = item.index
  }
}
