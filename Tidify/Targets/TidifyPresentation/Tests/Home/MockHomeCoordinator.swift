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
  private(set) var pushWebViewCalled: Bool = false
  private(set) var pushSettingSceneCalled: Bool = false
  private(set) var pushBookmarkCreateionSceneCalled: Bool = false
  private(set) var pushEditBookmarkSceneCalled: Bool = false

  func pushWebView(bookmark: Bookmark) {
    pushWebViewCalled = true
  }

  func pushSettingScene() {
    pushSettingSceneCalled = true
  }

  func pushBookmarkCreationScene() {
    pushBookmarkCreateionSceneCalled = true
  }

  func pushEditBookmarkScene(bookmark: TidifyDomain.Bookmark) {
    pushEditBookmarkSceneCalled = true
  }

  func start() {
    print("Start")
  }
}
