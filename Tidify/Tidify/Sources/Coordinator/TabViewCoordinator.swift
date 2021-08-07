//
//  TabViewCoordinator.swift
//  Tidify
//
//  Created by Manjong Han on 2021/07/17.
//

import Foundation
import RxSwift
import UIKit

class TabViewCoordinator: Coordinator {

    static let HOME_VIEW_TAB_INDEX = 0
    static let REGISTER_VIEW_TAB_INDEX = 1

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    private let disposeBag = DisposeBag()

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController

        let homeTabRootController = generateTabRootController()
        let homeCoordinator = HomeCoordinator(navigationController: homeTabRootController)
        homeCoordinator.parentCoordinator = self
        childCoordinators.insert(homeCoordinator, at: TabViewCoordinator.HOME_VIEW_TAB_INDEX)
        homeCoordinator.start()

        let registerTabRootController = generateTabRootController()
        let registerCoordinator = RegisterCoordinator(navigationController: registerTabRootController)
        registerCoordinator.parentCoordinator = self
        childCoordinators.insert(registerCoordinator, at: TabViewCoordinator.REGISTER_VIEW_TAB_INDEX)
        registerCoordinator.start()
    }

    func start() {
        let tabViewViewModel = TabViewViewModel()
        let tabViewController = TabViewController(viewModel: tabViewViewModel)
        tabViewController.coordinator = self

        navigationController.setViewControllers([tabViewController], animated: true)

        tabViewController.showOnTab(selectedIndex: TabViewCoordinator.HOME_VIEW_TAB_INDEX)
    }

    func getChildViewController(index: Int) -> UIViewController {
        return childCoordinators[index].navigationController
    }

    private func generateTabRootController() -> UINavigationController {
        let newNavigationController = UINavigationController()
        newNavigationController.isNavigationBarHidden = true
        return newNavigationController
    }
}
