//
//  SearchCoordinator.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain
import UIKit

protocol SearchCoordinator: Coordinator {
  func startWebView(bookmark: Bookmark)
}

final class DefaultSearchCoordinator: SearchCoordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  // MARK: - Initialize
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  func start() {}
  
  func startPush() -> SearchViewController {
    guard let useCase: SearchListUseCase = DIContainer.shared.resolve(type: SearchListUseCase.self) else {
      fatalError()
    }

    let viewModel: SearchViewModel = .init(useCase: useCase)
    let viewController: SearchViewController = .init(viewModel: viewModel)
    viewController.coordinator = self

    return viewController
  }

  func startWebView(bookmark: Bookmark) {
    let webViewController: WebViewController = .init(bookmark: bookmark)
    webViewController.modalPresentationStyle = .fullScreen
    navigationController.present(webViewController, animated: false)
  }

  func didFinish() {
    parentCoordinator?.removeChild(self)
  }
}
