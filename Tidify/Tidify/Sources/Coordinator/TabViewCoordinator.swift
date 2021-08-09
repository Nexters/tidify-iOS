//
//  TabViewCoordinator.swift
//  Tidify
//
//  Created by Manjong Han on 2021/07/17.
//

import Foundation
import RxSwift
import UIKit

enum TabBarIndex: Int, CaseIterable {
    case Home
    case Search
    case Category
}

class TabViewCoordinator: Coordinator {

    // MARK: - Properties

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    private var tabViewController: TabViewController?

    private let disposeBag = DisposeBag()

    // MARK: - Initialize

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

        setupTabBarCoordinator()
    }

    // MARK: - Methods

    func start() {
        let tabViewViewModel = TabViewViewModel()
        let tabViewController = TabViewController(viewModel: tabViewViewModel)
        tabViewController.coordinator = self
        navigationController.setViewControllers([tabViewController], animated: true)

        self.tabViewController = tabViewController

        show(selectedIndex: TabBarIndex.Home.rawValue)
    }

    func show(selectedIndex: Int) {
        self.tabViewController?.showOnTab(selectedIndex: selectedIndex)
        (self.childCoordinators[selectedIndex] as? TabChildCoordinator)?.show()
    }

    func hide(previousIndex: Int) {
        self.tabViewController?.removeFromTab(previousIndex: previousIndex)
        (self.childCoordinators[previousIndex] as? TabChildCoordinator)?.hide()
    }

    func getChildViewController(index: Int) -> UIViewController {
        return childCoordinators[index].navigationController
    }

    func setupTabBarCoordinator() {
        let homeNavigationController = UINavigationController()
        let homeCoordinator = HomeCoordinator(navigationController: homeNavigationController)
        homeCoordinator.parentCoordinator = self
        homeCoordinator.startPush()
        childCoordinators.insert(homeCoordinator, at: TabBarIndex.Home.rawValue)

        // TODO: 서치VC로 변경
        let registerNavigationController = UINavigationController()
        let registerCoordinator = RegisterCoordinator(navigationController: registerNavigationController)
        registerCoordinator.parentCoordinator = self
        registerCoordinator.startPush()
        childCoordinators.insert(registerCoordinator, at: TabBarIndex.Search.rawValue)

        // TODO: 카테고리VC 추가
    }
}
