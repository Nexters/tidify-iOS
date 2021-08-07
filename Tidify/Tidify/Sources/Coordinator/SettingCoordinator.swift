//
//  SettingCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/27.
//

import Foundation
import UIKit

class SettingCoordinator: Coordinator {

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
        let settingViewModel = SettingViewModel()
        let settingViewController = SettingViewController(viewModel: settingViewModel)
        settingViewController.coordinator = self

        navigationController.pushViewController(settingViewController, animated: true)
    }
}

extension SettingCoordinator {
    func goToProfile() {

    }

    func goToInterLink() {

    }

    func gotoAuthMethod() {

    }
}
