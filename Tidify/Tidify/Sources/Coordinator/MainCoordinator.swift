//
//  MainCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit
import WebKit

class MainCoordinator: NSObject, Coordinator {

    // MARK: - Properties

    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    let window: UIWindow

    // MARK: - Initialize

    init(window: UIWindow) {
        self.window = window
        self.window.makeKeyAndVisible()

        self.navigationController = UINavigationController()
        self.window.rootViewController = navigationController
        self.navigationController.navigationBar.isHidden = true
        self.navigationController.view.backgroundColor = .systemBackground
    }

    // MARK: - Methods

    func start() {
        let tabBarCoordinator = TabBarCoordinator(navigationController: navigationController)
        tabBarCoordinator.parentCoordinator = self
        childCoordinators.append(tabBarCoordinator)

        tabBarCoordinator.start()
    }

    func startWithSignIn() {
        let signInViewModel = SignInViewModel()
        let signInViewController = SignInViewController(viewModel: signInViewModel)
        signInViewController.coordinator = self

        navigationController.pushViewController(signInViewController, animated: true)
    }
}
