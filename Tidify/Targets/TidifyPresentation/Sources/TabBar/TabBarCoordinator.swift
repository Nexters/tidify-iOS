//
//  TabBarCoordinator.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

enum TabBarItem: CaseIterable {
  case home
  case folder
  case bookmarkCreation

  var index: Int {
    switch self {
    case .home: return 0
    case .folder: return 1
    case .bookmarkCreation: return 2
    }
  }
}

protocol TabBarCoordinator: Coordinator {
  var parentCoordinator: Coordinator? { get set }

  func pushBookmarkCreationScene()
}

final class DefaultTabBarCoordinator: TabBarCoordinator {
  
  // MARK: - Properties
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  // MARK: - Initialize
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }
  
  // MARK: - Methods
  func start() {
    let tabBarController: TabBarController = .init()
    setupTabBar(tabBarController)
    navigationController.viewControllers = [tabBarController]
  }

  func didFinish() {}

  func pushBookmarkCreationScene() {
    let bookmarkCreationCoordinator: DefaultBookmarkCreationCoordinator = .init(
      navigationController: navigationController
    )
    let bookmarkCreationViewController = bookmarkCreationCoordinator.startPush(type: .create)
    bookmarkCreationCoordinator.parentCoordinator = self
    addChild(bookmarkCreationCoordinator)

    navigationController.pushViewController(bookmarkCreationViewController, animated: true)
  }
}

private extension DefaultTabBarCoordinator {
  func setupTabBar(_ tabBarController: TabBarController) {
    tabBarController.tabBar.isHidden = true
    tabBarController.coordinator = self
    
    let homeCoordinator: DefaultHomeCoordinator = .init(
      navigationController: navigationController
    )
    homeCoordinator.parentCoordinator = self
    addChild(homeCoordinator)
    
    let folderCoordinator: DefaultFolderCoordinator = .init(
      navigationController: navigationController
    )
    folderCoordinator.parentCoordinator = self
    addChild(folderCoordinator)
    
    let homeViewController: UIViewController = homeCoordinator.startPush()
    let folderViewController: UIViewController = folderCoordinator.startPush()
    let dummyViewController: UIViewController = .init(nibName: nil, bundle: nil)
    
    tabBarController.setViewControllers(
      [homeViewController, folderViewController, dummyViewController],
      animated: false
    )
  }
}
