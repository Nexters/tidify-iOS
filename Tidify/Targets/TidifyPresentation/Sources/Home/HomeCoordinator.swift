//
//  HomeCoordinator.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain
import UIKit

import RxSwift

protocol HomeCoordinator: Coordinator {
  func pushWebView(bookmark: Bookmark)
  func pushSettingScene()
  func pushBookmarkCreationScene()
}

final class DefaultHomeCoordinator: HomeCoordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  private let navigationBar: TidifyNavigationBar!

  private let settingButton: UIButton = .init().then {
    $0.setImage(.init(named: "profileIcon"), for: .normal)
  }

  private let createBookmarkButton: UIButton = .init().then {
    $0.setImage(.init(named: "createBookMarkIcon"), for: .normal)
    $0.frame = .init(x: 0, y: 0, width: 78, height: 40)
  }

  private let disposeBag: DisposeBag = .init()

  // MARK: - Constructor
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController

    self.navigationBar = .init(
      .home,
      leftButton: settingButton,
      rightButton: createBookmarkButton
    )

    settingButton.rx.tap
      .withUnretained(self)
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { coordinator, _ in
        coordinator.pushSettingScene()
      })
      .disposed(by: disposeBag)

    createBookmarkButton.rx.tap
      .withUnretained(self)
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { coordinator, _ in
        coordinator.pushBookmarkCreationScene()
      })
      .disposed(by: disposeBag)
  }

  // MARK: - Methods
  func start() {
    let viewController: HomeViewController = getViewController()
    navigationController.pushViewController(viewController, animated: true)
  }
  
  func startPush() -> UIViewController {
    return getViewController()
  }

  func pushWebView(bookmark: Bookmark) {
    // TODO: Implementation
  }

  func pushSettingScene() {
    guard let settingCoordinator = DIContainer.shared.resolve(type: SettingCoordinator.self)
            as? DefaultSettingCoordinator else { return }
    settingCoordinator.parentCoordinator = self
    addChild(settingCoordinator)

    settingCoordinator.start()
  }

  func pushBookmarkCreationScene() {
    guard let bookmarkCreationCoordinator = DIContainer.shared.resolve(
      type: BookmarkCreationCoordinator.self) as? DefaultBookmarkCreationCoordinator else { return }

    bookmarkCreationCoordinator.parentCoordinator = self
    addChild(bookmarkCreationCoordinator)

    bookmarkCreationCoordinator.start()
  }
}

// MARK: - Private
private extension DefaultHomeCoordinator {
  func getViewController() -> HomeViewController {
    guard let usecase: HomeUseCase = DIContainer.shared.resolve(type: HomeUseCase.self) else {
      fatalError()
    }

    let reactor: HomeReactor = .init(coordinator: self, useCase: usecase)
    let viewController: HomeViewController = .init(navigationBar)
    viewController.reactor = reactor

    return viewController
  }
}
