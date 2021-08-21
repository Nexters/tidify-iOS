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

class TabBarCoordinator: Coordinator {

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

private extension TabBarCoordinator {
    // 탭 바 테스트를 위해 기획되어진 VC가 아닌 임의의 VC를 생성하여 구성하였음.
    func setupTabBarCoordinator() {
        tidifyTabBarController.tabBar.isHidden = true

        let homeViewController: UIViewController!
        let searchViewController: UIViewController!
        let folderTabController: UIViewController!

        let homeCoordinator = HomeCoordinator(navigationController: navigationController)
        homeCoordinator.parentCoordinator = self
        childCoordinators.append(homeCoordinator)
        homeViewController = homeCoordinator.startPush()

        // 추후 searchVC로 변경
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
        registerCoordinator.parentCoordinator = self
        childCoordinators.append(registerCoordinator)
        searchViewController = registerCoordinator.startPush()

        let folderTabCoordinator = FolderTabCoordinator(navigationController: navigationController)
        folderTabCoordinator.parentCoordinator = self
        childCoordinators.append(folderTabCoordinator)
        folderTabController = folderTabCoordinator.startPush()

        tidifyTabBarController.setViewControllers([homeViewController, searchViewController, folderTabController], animated: false)
        tidifyTabBarController.selectedIndex = 0
    }
}
