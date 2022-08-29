//
//  MockHomeCoordinator.swift
//  TidifyPresentationTests
//
//  Created by Ian on 2022/08/29.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain
import UIKit

@testable import TidifyPresentation
final class MockHomeCoordinator: HomeCoordinator {
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController = .init()

  // MARK: - Properties
  var pushWebViewCalled: Bool = false
  var pushSettingSceneCalled: Bool = false
  var pushBookmarkCreateionSceneCalled: Bool = false

  func pushWebView(bookmark: Bookmark) {
    pushWebViewCalled = true
  }

  func pushSettingScene() {
    pushSettingSceneCalled = true
  }

  func pushBookmarkCreationScene() {
    pushBookmarkCreateionSceneCalled = true
  }

  func start() {
    print("TEST")
  }
}
