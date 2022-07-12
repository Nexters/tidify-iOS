//
//  TabBarCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/16.
//

import Foundation
import RxSwift
import UIKit

enum TabBarItem: CaseIterable {
  case home
  case search
  case category

  var index: Int {
    switch self {
    case .home: return 0
    case .search: return 1
    case .category: return 2
    }
  }
}

protocol TabBarCoordinator: Coordinator { }

final class DefaultTabBarCoordinator: TabBarCoordinator {

  // MARK: - Properties

  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  private var tidifyTabBarController: TidifyTabBarController!

  private let disposeBag = DisposeBag()

  // MARK: - Initialize

  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.tidifyTabBarController = TidifyTabBarController()
  }

  func start() {
    setupTabBarCoordinator()

    navigationController.viewControllers = [tidifyTabBarController]
  }
}

private extension DefaultTabBarCoordinator {
  func setupTabBarCoordinator() {
    tidifyTabBarController.tabBar.isHidden = true

    let homeViewController: UIViewController!
    let searchViewController: UIViewController!
    let folderTabController: UIViewController!

    let homeCoordinator = HomeCoordinator(navigationController: navigationController)
    homeCoordinator.parentCoordinator = self
    addChild(homeCoordinator)
    homeViewController = homeCoordinator.startPush()

    let searchCoordinator = SearchCoordinator(navigationController: navigationController)
    searchCoordinator.parentCoordinator = self
    addChild(searchCoordinator)
    searchViewController = searchCoordinator.startPush()

    let folderTabCoordinator = FolderTabCoordinator(navigationController: navigationController)
    folderTabCoordinator.parentCoordinator = self
    addChild(folderTabCoordinator)
    folderTabController = folderTabCoordinator.startPush()

    tidifyTabBarController.setViewControllers(
      [homeViewController, searchViewController, folderTabController],
      animated: false
    )
    tidifyTabBarController.selectedIndex = 0
  }
}
