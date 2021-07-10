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
        let mainViewModel = MainViewModel()
        let mainViewController = MainViewController(mainViewModel)
        mainViewController.coordinator = self
        mainViewController.title = "Tidify"
        navigationController.navigationBar.prefersLargeTitles = true
        navigationController.navigationItem.largeTitleDisplayMode = .never  // 하위 뷰에서는 비활성화
        navigationController.pushViewController(mainViewController, animated: true)
    }

    func pushWebView() {
        let webViewController = WebViewController()
        webViewController.coordinator = self
        navigationController.pushViewController(webViewController, animated: true)
    }
}
