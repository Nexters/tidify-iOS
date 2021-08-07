//
//  HomeCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/12.
//

import Foundation
import RxCocoa
import UIKit

class HomeCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let homeViewModel = HomeViewModel()
        homeViewModel.delegate = self
        let homeViewController = HomeViewController(viewModel: homeViewModel)
        homeViewController.coordinator = self

        navigationController.pushViewController(homeViewController, animated: true)
    }
}

// MARK: - 1 Depth
extension HomeCoordinator: HomeViewModelDelegate {
    func pushRegisterView() {
        let registerCoordinator = RegisterCoordinator(navigationController: navigationController)
        registerCoordinator.parentCoordinator = self
        childCoordinators.append(registerCoordinator)

        registerCoordinator.start()
    }

    func pushWebView() {
        let webViewCoordinator = WebViewCoordinator(navigationController: navigationController)
        webViewCoordinator.parentCoordinator = self
        childCoordinators.append(webViewCoordinator)

        webViewCoordinator.start()
    }
}

extension HomeCoordinator {
    func pushSettingView() {
        let settingCoordinator = SettingCoordinator(navigationController: navigationController)
        settingCoordinator.parentCoordinator = self
        childCoordinators.append(settingCoordinator)

        settingCoordinator.start()
    }
}
