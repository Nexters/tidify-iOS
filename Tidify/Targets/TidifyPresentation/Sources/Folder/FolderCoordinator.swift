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

  //TODO: - 추후 구현
//  func didTapSubscribeButton()
//  func didTapShareButton()
}

protocol FolderCoordinator: Coordinator {

  // MARK: Methods
  func pushSettingScene()
  func pushDetailScene(folder: Folder)
  func pushFolderCreationScene(type: CreationType, originFolder: Folder?)
  func pushSearchScene()

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

    //TODO: - 추후 구현
//    button.addTarget(self, action: #selector(didTapSubscribeButton), for: .touchUpInside)
    return button
  }()

  private lazy var shareButton: UIButton = {
    let button: UIButton = .init()
    button.setTitle("공유중", for: .normal)
    button.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
    button.titleLabel?.font = .t_EB(22)

    //TODO: - 추후 구현
//    button.addTarget(self, action: #selector(didTapShareButton), for: .touchUpInside)
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

    leftButtonStackView.addArrangedSubview(folderButton)

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
    let settingViewController = settingCoordinator.startPush()
    settingCoordinator.parentCoordinator = self
    addChild(settingCoordinator)

    navigationController.pushViewController(settingViewController, animated: true)
  }
  
  func pushDetailScene(folder: Folder) {
    let folderDetailCoordinator: DefaultFolderDetailCoordinator = .init(
      navigationController: navigationController
    )
    let folderDetailViewController = folderDetailCoordinator.startPush(folder: folder)
    folderDetailCoordinator.parentCoordinator = self
    addChild(folderDetailCoordinator)

    navigationController.pushViewController(folderDetailViewController, animated: true)
  }
  
  func pushFolderCreationScene(type: CreationType, originFolder: Folder?) {
    let folderCreationCoordinator: DefaultFolderCreationCoordinator = .init(
      navigationController: navigationController
    )
    let folderCreationViewController = folderCreationCoordinator.startPush(type: type, originFolder: originFolder)
    folderCreationCoordinator.parentCoordinator = self
    addChild(folderCreationCoordinator)

    navigationController.pushViewController(folderCreationViewController, animated: true)
  }

  func pushSearchScene() {
    guard let searchCoordinator = DIContainer.shared.resolve(type: SearchCoordinator.self)
            as? DefaultSearchCoordinator else {
      return
    }

    let searchViewController = searchCoordinator.startPush()
    navigationController.pushViewController(searchViewController, animated: false)
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

  //TODO: - 추후 구현
//  @objc func didTapSubscribeButton() {
//    navigationBarDelegate?.didTapSubscribeButton()
//    folderButton.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
//    subscribeButton.setTitleColor(.t_ashBlue(weight: 800), for: .normal)
//    shareButton.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
//  }
//  @objc func didTapShareButton() {
//    navigationBarDelegate?.didTapShareButton()
//    folderButton.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
//    subscribeButton.setTitleColor(.t_ashBlue(weight: 300), for: .normal)
//    shareButton.setTitleColor(.t_ashBlue(weight: 800), for: .normal)
//  }
}
