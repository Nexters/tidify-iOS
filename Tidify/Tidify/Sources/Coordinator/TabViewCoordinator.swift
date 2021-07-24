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

        let profileButton = UIButton()
        profileButton.frame = CGRect(x: 0, y: 0, width: 30, height: 90)
        profileButton.setTitle("이미지", for: .normal)
        profileButton.setTitleColor(.t_tidiBlue(), for: .normal)
        profileButton.rx.tap.asDriver()
            .drive(onNext: { [weak self] in
                if let homeCoordinator =
                    self?.childCoordinators[TabViewCoordinator.HOME_VIEW_TAB_INDEX] as? HomeCoordinator {
                    homeCoordinator.pushSettingView()
                }
            })
            .disposed(by: disposeBag)

        navigationController.navigationItem.rightBarButtonItem = UIBarButtonItem(customView: profileButton)
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
