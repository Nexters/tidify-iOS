//
//  WebViewCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/14.
//

import Foundation
import UIKit

class WebViewCoordinator: Coordinator {
    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }

    func start() {
        let webViewViewModel = WebViewViewModel()
        let webViewController = WebViewController(viewModel: webViewViewModel)
        webViewController.coordinator = self

        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(webViewController, animated: true)
    }
}
