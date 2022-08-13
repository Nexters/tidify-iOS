//
//  TabBarCoordinator.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

import Then

enum TabBarItem: CaseIterable {
  case home
  case search
  case folder

  var index: Int {
    switch self {
    case .home: return 0
    case .search: return 1
    case .folder: return 2
    }
  }
}

protocol TabBarCoordinator: Coordinator {}

final class DefaultTabBarCoordinator: TabBarCoordinator {
  
  // MARK: - Properties
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController
  
  private let tabBarController: TabBarController = .init()
  
  // MARK: - Initialize
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Methods
  func start() {
    setupTabBar()
    navigationController.viewControllers = [tabBarController]
  }
}

private extension DefaultTabBarCoordinator {
  func setupTabBar() {
    tabBarController.tabBar.isHidden = true
    
    let homeCoordinator: DefaultHomeCoordinator = .init(
      navigationController: navigationController
    )
    homeCoordinator.parentCoordinator = self
    addChild(homeCoordinator)
    
    let searchCoordinator: DefaultSearchCoordinator = .init(
      navigationController: navigationController
    )
    searchCoordinator.parentCoordinator = self
    addChild(searchCoordinator)
    
    let folderCoordinator: DefaultFolderCoordinator = .init(
      navigationController: navigationController
    )
    folderCoordinator.parentCoordinator = self
    addChild(folderCoordinator)
    
    let homeViewController: UIViewController = homeCoordinator.startPush()
    let searchViewController: UIViewController = searchCoordinator.startPush()
    let folderViewController: UIViewController = folderCoordinator.startPush()
    
    tabBarController.setViewControllers(
      [homeViewController, searchViewController, folderViewController],
      animated: false
    )
  }
}
