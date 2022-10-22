//
//  FolderCoordinator.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyCore
import TidifyDomain
import UIKit

import RxSwift

protocol FolderCoordinator: Coordinator {
  func pushDetailScene()
  func pushEditScene()
  func pushCreationScene()
  func popCreationScene()
}

final class DefaultFolderCoordinator: FolderCoordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController
  
  private let profileButton: UIButton = .init().then {
    $0.setImage(UIImage(named: "profileIcon"), for: .normal)
  }
  
  private let createButton: UIButton = .init().then {
    $0.setImage(UIImage(named: "createFolderIcon"), for: .normal)
  }
  
  private let navigationBar: TidifyNavigationBar?
  
  private let disposeBag: DisposeBag = .init()

  // MARK: - Initialize
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.navigationBar = TidifyNavigationBar(
      .folder,
      leftButton: profileButton,
      rightButton: createButton
    )
    setupNavigationBar()
  }

  // MARK: - Methods
  func start() {
    navigationController.pushViewController(getViewController(), animated: true)
  }
  
  func startPush() -> UIViewController {
    return getViewController()
  }
  
  func pushDetailScene() {}
  func pushEditScene() {}
  
  func pushCreationScene() {
    navigationController.pushViewController(
      FolderCreationViewController(),
      animated: true
    )
  }
  
  func popCreationScene() {
    navigationController.popViewController(animated: true)
  }
}

// MARK: - Private
private extension DefaultFolderCoordinator {
  func getViewController() -> FolderViewController {
    guard let usecase: FolderUseCase = DIContainer.shared.resolve(type: FolderUseCase.self),
          let navigationBar = navigationBar
    else { fatalError() }

    let reactor: FolderReactor = .init(coordinator: self, usecase: usecase)
    let viewController: FolderViewController = .init(navigationBar)
    viewController.reactor = reactor

    return viewController
  }
  
  func setupNavigationBar() {
    createButton.rx.tap
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { [weak self] in
        self?.navigationController.pushViewController(
          FolderCreationViewController(),
          animated: true
        )
      })
      .disposed(by: disposeBag)
  }
}
