//
//  FolderDetailCoordinator.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/12/14.
//  Copyright © 2023 Tidify. All rights reserved.
//


import TidifyCore
import TidifyDomain
import UIKit

protocol FolderDetailCoordinator: Coordinator {
  func pushEditBookmarkScene(bookmark: Bookmark)
  func startWebView(bookmark: Bookmark)
}

enum FolderDetailViewMode {
  case ownerNotSharing
  case owner
  case subscribeNotSubscribe
  case subscriber
}

final class DefaultFolderDetailCoordinator: FolderDetailCoordinator {

  // MARK: - Properties
  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  // MARK: - Initializer
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  func start() {}

  func startPush(folder: Folder) -> FolderDetailViewController {
    guard let useCase: FolderDetailUseCase = DIContainer.shared.resolve(type: FolderDetailUseCase.self) else {
      fatalError()
    }

    let viewModel: FolderDetailViewModel = .init(useCase: useCase)
    let viewController: FolderDetailViewController = .init(viewModel: viewModel, folderID: folder.id, title: folder.title)
    viewController.coordinator = self

    return viewController
  }

  func pushEditBookmarkScene(bookmark: Bookmark) {
    guard let bookmarkCreationCoordinator = DIContainer.shared.resolve(
      type: BookmarkCreationCoordinator.self) as? DefaultBookmarkCreationCoordinator else { return }

    let bookmarkEditViewController = bookmarkCreationCoordinator.startPush(type: .edit, originBookmark: bookmark)
    bookmarkCreationCoordinator.parentCoordinator = self
    addChild(bookmarkCreationCoordinator)

    navigationController.pushViewController(bookmarkEditViewController, animated: true)
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
