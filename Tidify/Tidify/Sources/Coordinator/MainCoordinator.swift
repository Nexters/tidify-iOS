//
//  MainCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import WebKit
import UIKit

class MainCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        // 추후 VC 객체 생성시 ViewModel을 주입하여 DI 해결
        let mainViewController = MainViewController()
        mainViewController.coordinator = self
        navigationController.pushViewController(mainViewController, animated: true)
    }

    func pushWebView() {
        let webViewController = WebViewController()
        webViewController.coordinator = self
        navigationController.pushViewController(webViewController, animated: true)
    }
}
