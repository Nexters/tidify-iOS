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
  func pushWebView(bookmark: Bookmark)
  func pushEditBookmarkScene(bookmark: Bookmark)
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
    let viewController: FolderDetailViewController = .init(viewModel: viewModel, folder: folder)
    viewController.coordinator = self

    return viewController
  }

  func pushWebView(bookmark: Bookmark) {
    guard let detailWebViewCoordinator = DIContainer.shared.resolve(type: DetailWebCoordinator.self)
            as? DefaultDetailWebCoordinator else { return }

    detailWebViewCoordinator.parentCoordinator = self
    detailWebViewCoordinator.bookmark = bookmark
    addChild(detailWebViewCoordinator)

    detailWebViewCoordinator.start()
  }

  func pushEditBookmarkScene(bookmark: Bookmark) {
    guard let bookmarkCreationCoordinator = DIContainer.shared.resolve(
      type: BookmarkCreationCoordinator.self) as? DefaultBookmarkCreationCoordinator else { return }

    let bookmarkEditViewController = bookmarkCreationCoordinator.startPush(type: .edit, originBookmark: bookmark)
    bookmarkCreationCoordinator.parentCoordinator = self
    addChild(bookmarkCreationCoordinator)

    navigationController.pushViewController(bookmarkEditViewController, animated: true)
  }

  func didFinish() {
    parentCoordinator?.removeChild(self)
  }
}
