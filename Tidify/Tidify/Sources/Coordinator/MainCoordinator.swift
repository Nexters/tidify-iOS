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
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    let window: UIWindow

    init(window: UIWindow) {
        self.window = window
        self.navigationController = UINavigationController()
    }

    func start() {
        window.rootViewController = navigationController
        window.makeKeyAndVisible()

        let tabViewCoordinator = TabViewCoordinator(navigationController: navigationController)
        tabViewCoordinator.parentCoordinator = self
        childCoordinators.append(tabViewCoordinator)

        tabViewCoordinator.start()
    }

    func startWithSignIn() {
        let signInViewModel = SignInViewModel()
        let signInViewController = SignInViewController(viewModel: signInViewModel)
        signInViewController.coordinator = self

        navigationController.pushViewController(signInViewController, animated: true)
    }
}
