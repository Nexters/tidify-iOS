//
//  WebViewCoordinator.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/14.
//

import Foundation
import UIKit

class WebViewCoordinator: Coordinator {

    // MARK: - Properties

    weak var parentCoordinator: Coordinator?
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    private let bookMarkURLString: String

    // MARK: - Initialize

    init(navigationController: UINavigationController, urlString: String) {
        self.navigationController = navigationController
        self.bookMarkURLString = urlString
    }

    // MARK: - Methods

    func start() {
        let webViewViewModel = WebViewViewModel(bookMarkURLString)
        let webViewController = WebViewController(viewModel: webViewViewModel)
        webViewController.coordinator = self

        navigationController.navigationBar.isHidden = false
        navigationController.pushViewController(webViewController, animated: true)
    }
}
