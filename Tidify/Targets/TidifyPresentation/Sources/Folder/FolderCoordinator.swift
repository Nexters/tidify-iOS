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
  func pushSettingScene()
  func pushDetailScene(folder: Folder)
  func pushFolderEditScene(folder: Folder)
  func pushBookmarkEditScene(bookmark: Bookmark)
  func pushCreationScene()
  func popCreationScene()
  func pushWebView(bookmark: Bookmark)
}

final class DefaultFolderCoordinator: FolderCoordinator {
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController
  
  private let settingButton: UIButton = .init().then {
    $0.setImage(UIImage(named: "profileIcon"), for: .normal)
  }
  
  private let createButton: UIButton = .init().then {
    $0.setImage(UIImage(named: "createFolderIcon"), for: .normal)
  }
  
  private let navigationBar: TidifyNavigationBar?
  private var folderUseCase: FolderUseCase?
  
  private let disposeBag: DisposeBag = .init()

  // MARK: - Initialize
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
    self.navigationBar = TidifyNavigationBar(
      .folder,
      leftButton: settingButton,
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
  
  func pushSettingScene() {
    guard let settingCoordinator = DIContainer.shared.resolve(type: SettingCoordinator.self)
            as? DefaultSettingCoordinator else { return }
    settingCoordinator.parentCoordinator = self
    addChild(settingCoordinator)

    settingCoordinator.start()
  }
  
  func pushDetailScene(folder: Folder) {
    guard let useCase: FolderDetailUseCase = DIContainer.shared.resolve(type: FolderDetailUseCase.self)
    else { fatalError() }
    let reactor: FolderDetailReactor = .init(coordinator: self, useCase: useCase, folderID: folder.id)
    let viewController: FolderDetailViewController = .init(
      folder: folder,
      navigationBar: getDetailNavigationBar(folder: folder)
    )
    viewController.reactor = reactor
    
    navigationController.pushViewController(
      viewController,
      animated: true
    )
  }
  
  func pushFolderEditScene(folder: Folder) {
    guard let useCase: FolderUseCase = folderUseCase else { fatalError() }
    let reactor: FolderCreationReactor = .init(coordinator: self, useCase: useCase)
    let viewController: FolderCreationViewController = .init(creationType: .edit, originFolder: folder)
    viewController.reactor = reactor
    navigationController.pushViewController(
      viewController,
      animated: true
    )
  }

  func pushBookmarkEditScene(bookmark: Bookmark) {
    guard let bookmarkCreationCoordinator = DIContainer.shared.resolve(
      type: BookmarkCreationCoordinator.self) as? DefaultBookmarkCreationCoordinator else { return }

    bookmarkCreationCoordinator.parentCoordinator = self
    addChild(bookmarkCreationCoordinator)

    bookmarkCreationCoordinator.pushEditBookmarkScene(with: bookmark)
  }
  
  func pushCreationScene() {
    guard let useCase: FolderUseCase = folderUseCase else { fatalError() }
    let reactor: FolderCreationReactor = .init(coordinator: self, useCase: useCase)
    let viewController: FolderCreationViewController = .init(creationType: .create)
    viewController.coordinator = self
    viewController.reactor = reactor
    
    navigationController.pushViewController(
      viewController,
      animated: true
    )
  }
  
  func popCreationScene() {
    navigationController.popViewController(animated: true)
  }
  
  func pushWebView(bookmark: Bookmark) {
    guard let detailWebViewCoordinator = DIContainer.shared.resolve(type: DetailWebCoordinator.self)
            as? DefaultDetailWebCoordinator else { return }

    detailWebViewCoordinator.parentCoordinator = self
    detailWebViewCoordinator.bookmark = bookmark
    addChild(detailWebViewCoordinator)

    detailWebViewCoordinator.start()
  }

  func didFinish() {
    parentCoordinator?.removeChild(self)
  }
}

// MARK: - Private
private extension DefaultFolderCoordinator {
  func getViewController() -> FolderViewController {
    guard let useCase: FolderUseCase = DIContainer.shared.resolve(type: FolderUseCase.self),
          let navigationBar = navigationBar
    else { fatalError() }

    let reactor: FolderReactor = .init(coordinator: self, useCase: useCase)
    let viewController: FolderViewController = .init(navigationBar)
    viewController.reactor = reactor
    folderUseCase = useCase

    return viewController
  }
  
  func getDetailNavigationBar(folder: Folder) -> TidifyNavigationBar {
    let backButton: UIButton = .init().then {
      $0.setImage(UIImage(named: "backIcon"), for: .normal)
      $0.setTitle("  \(folder.title)", for: .normal)
      $0.titleLabel?.font = .t_EB(20)
    }
    
    backButton.rx.tap
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { [weak self] in
        self?.navigationController.popViewController(animated: true)
      })
      .disposed(by: disposeBag)

    //TODO: Implements
//    let rightButton: UIButton = .init().then {
//      $0.setImage(UIImage(named: "shareIcon"), for: .normal)
//    }
    
    let navigationBar: TidifyNavigationBar = .init(
      .folderDetail,
      title: folder.title,
      leftButton: backButton
    )
    
    return navigationBar
  }
  
  func setupNavigationBar() {
    settingButton.rx.tap
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { [weak self] in
        self?.pushSettingScene()
      })
      .disposed(by: disposeBag)
    
    createButton.rx.tap
      .asDriver(onErrorDriveWith: .empty())
      .drive(onNext: { [weak self] in
        self?.pushCreationScene()
      })
      .disposed(by: disposeBag)
  }
}
