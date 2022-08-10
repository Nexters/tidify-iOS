//
//  TabBarCoordinator.swift
//  TidifyDataTests
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Then
import UIKit

protocol TabBarCoordinator: Coordinator {}

final class DefaultTabBarCoordinator: TabBarCoordinator {
  
  // MARK: - Properties
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController
  
  private let tabBarController = TabBarController()
  
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
//    tabBarController.tabBar.isHidden = true
    
    let homeCoordinator: DefaultHomeCoordinator =
      .init(navigationController: navigationController)
    homeCoordinator.parentCoordinator = self
    addChild(homeCoordinator)
    let homeViewController = homeCoordinator.startPush()
    
    let searchCoordinator: DefaultSearchCoordinator =
      .init(navigationController: navigationController)
    searchCoordinator.parentCoordinator = self
    addChild(searchCoordinator)
    let searchViewController = searchCoordinator.startPush()
    
    let folderCoordinator: DefaultFolderCoordinator =
      .init(navigationController: navigationController)
    folderCoordinator.parentCoordinator = self
    addChild(folderCoordinator)
    let folderViewController = folderCoordinator.startPush()
    
    tabBarController.setViewControllers(
      [homeViewController, searchViewController, folderViewController],
      animated: false
    )
  }
}
