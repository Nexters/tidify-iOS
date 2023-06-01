//
//  MockSearchCoordinator.swift
//  TidifyPresentationTests
//
//  Created by 여정수 on 2023/06/01.
//  Copyright © 2023 Tidify. All rights reserved.
//

import TidifyDomain
import UIKit

@testable import TidifyPresentation
final class MockSearchCoordinator: SearchCoordinator {

  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController = .init()

  private(set) var pushWebViewCalled: Bool = false

  func pushWebView(bookmark: Bookmark) {
    pushWebViewCalled = true
  }

  func start() {
    print("Start")
  }
}
