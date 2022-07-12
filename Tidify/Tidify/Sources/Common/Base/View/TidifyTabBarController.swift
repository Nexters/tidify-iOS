//
//  TidifyTabBarController.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/16.
//

import SnapKit
import Then
import UIKit

class TidifyTabBarController: UITabBarController {

  // MARK: - Properties

  weak var coordinator: TabBarCoordinator?
  private weak var tidifyTabBar: TidifyTabBar!

  // MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()

    setupTabBar()
    setupLayoutConstraints()
  }
}

private extension TidifyTabBarController {
  func setupTabBar() {
    self.tidifyTabBar = TidifyTabBar().then {
      $0.delegate = self
      view.addSubview($0)
    }
  }

  func setupLayoutConstraints() {
    tidifyTabBar.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(75)
      $0.trailing.equalToSuperview().inset(75)
      $0.bottom.equalToSuperview().inset(50)
    }
  }
}

extension TidifyTabBarController: TidifyTabBarDelegate {
  func didSelectTab(_ item: TabBarItem) {
    self.selectedIndex = item.index
  }
}
