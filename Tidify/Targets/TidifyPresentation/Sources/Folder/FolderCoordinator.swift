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

protocol FolderNavigationBarDelegate: AnyObject {
  func didTapFolderButton()
  func didTapSubscribeButton()
  func didTapShareButton()
}

protocol FolderCoordinator: Coordinator {

  // MARK: Methods
  func pushSettingScene()
  func pushDetailScene(folder: Folder)
  func pushFolderCreationScene(type: CreationType, originFolder: Folder?)

  // MARK: Properties
  var navigationBarDelegate: FolderNavigationBarDelegate? { get set }
}

final class DefaultFolderCoordinator: FolderCoordinator {
  weak var parentCoordinator: Coordinator?
  weak var navigationBarDelegate: FolderNavigationBarDelegate?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController

  private lazy var folderButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("폴더", for: .normal)
    button.setTitleColor(.t_ashBlue(weight: 800), for: .normal)
    button.titleLabel?.font = .t_EB(22)
    button.addTarget(self, action: #selector(didTapFolderButton), for: .touchUpInside)
    return button
  }()

  private lazy var subscribeButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("구독", for: .normal)
    button.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
    button.titleLabel?.font = .t_EB(22)
    button.addTarget(self, action: #selector(didTapSubscribeButton), for: .touchUpInside)
    return button
  }()

  private lazy var shareButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("공유중", for: .normal)
    button.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
    button.titleLabel?.font = .t_EB(22)
    button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
    return button
  }()

  private let leftButtonStackView: UIStackView = {
    let stackView: UIStackView = .init()
    stackView.distribution = .equalSpacing
    stackView.spacing = 15
    return stackView
  }()

  private lazy var settingButton: UIButton = {
    let button: UIButton = .init()
    button.setImage(.init(named: "settingButtonIcon"), for: .normal)
    button.addTarget(self, action: #selector(pushSettingScene), for: .touchUpInside)
    return button
  }()

  // MARK: - Initialize
  init(navigationController: UINavigationController) {
    self.navigationController = navigationController
  }

  // MARK: - Methods
  func start() {}
  
  func startPush() -> UIViewController {
    guard let useCase: FolderListUseCase = DIContainer.shared.resolve(type: FolderListUseCase.self) else {
      fatalError()
    }

    [folderButton, subscribeButton, shareButton].forEach {
      leftButtonStackView.addArrangedSubview($0)
    }

    let navigationBar: TidifyNavigationBar = .init(
      leftButtonStackView: leftButtonStackView,
      settingButton: settingButton
    )

    let viewModel: FolderViewModel = .init(useCase: useCase)

    let viewController: FolderViewController = .init(
      navigationBar: navigationBar,
      viewModel: viewModel
    )
    viewController.coordinator = self

    return viewController
  }
  
  @objc func pushSettingScene() {
    guard let settingCoordinator = DIContainer.shared.resolve(type: SettingCoordinator.self)
            as? DefaultSettingCoordinator else { return }
    settingCoordinator.parentCoordinator = self
    addChild(settingCoordinator)

    settingCoordinator.start()
  }
  
  func pushDetailScene(folder: Folder) {
//    guard let useCase: FolderDetailUseCase = DIContainer.shared.resolve(type: FolderDetailUseCase.self)
//    else { fatalError() }
//    let reactor: FolderDetailReactor = .init(coordinator: self, useCase: useCase, folderID: folder.id)
//    let viewController: FolderDetailViewController = .init(
//      folder: folder,
//      navigationBar: getDetailNavigationBar(folder: folder)
//    )
//    viewController.reactor = reactor
//
//    navigationController.pushViewController(
//      viewController,
//      animated: true
//    )
  }
  
  func pushFolderCreationScene(type: CreationType, originFolder: Folder?) {
    let folderCreationCoordinator: DefaultFolderCreationCoordinator = .init(
      navigationController: navigationController
    )
    let folderCreationViewController = folderCreationCoordinator.startPush(type: type, originFolder: originFolder)
    folderCreationCoordinator.parentCoordinator = self
    addChild(folderCreationCoordinator)

    guard let tabBarController = navigationController.viewControllers[0] as? TabBarController,
          let tabBarViewControllers = tabBarController.viewControllers,
          let folderViewController = tabBarViewControllers[1] as? FolderViewController else {
      return
    }

    folderCreationViewController.saveButtonDelegate = folderViewController
    navigationController.pushViewController(folderCreationViewController, animated: true)
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

private extension DefaultFolderCoordinator {
  @objc func didTapFolderButton() {
    navigationBarDelegate?.didTapFolderButton()
    folderButton.setTitleColor(.t_ashBlue(weight: 800), for: .normal)
    subscribeButton.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
    shareButton.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
  }
  @objc func didTapSubscribeButton() {
    navigationBarDelegate?.didTapSubscribeButton()
    folderButton.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
    subscribeButton.setTitleColor(.t_ashBlue(weight: 800), for: .normal)
    shareButton.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
  }
  @objc func didTapShareButton() {
    navigationBarDelegate?.didTapShareButton()
    folderButton.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
    subscribeButton.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
    shareButton.setTitleColor(.t_ashBlue(weight: 800), for: .normal)
  }
}
