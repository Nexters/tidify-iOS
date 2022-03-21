//
//  FolderDetailCoordinator.swift
//  Tidify
//
//  Created by 한상진 on 2022/03/21.
//

import RxSwift

class FolderDetailCoordinator: Coordinator {
  
  // MARK: - Properties

  weak var parentCoordinator: Coordinator?
  var childCoordinators: [Coordinator] = []
  var navigationController: UINavigationController
  var titleString: String?

  private let disposeBag = DisposeBag()

  // MARK: - Initialize

  init(titleString: String, navigationController: UINavigationController) {
    self.titleString = titleString
    self.navigationController = navigationController
  }

  // MARK: - Methods

  func start() {
    let leftButton = UIButton().then {
      $0.setImage(R.image.nav_icon_back(), for: .normal)
    }

    let rightButton = UIButton().then {
      $0.setImage(R.image.folder_sheare_img(), for: .normal)
    }

    let folderDetailViewModel = FolderDetailViewModel()
    let folderDetailViewController = FolderDetailViewController(
      viewModel: folderDetailViewModel,
      titleString: titleString,
      leftButton: leftButton,
      rightButton: rightButton)
    folderDetailViewController.coordinator = self

    leftButton.rx.tap.asDriver()
        .drive(onNext: { _ in
          folderDetailViewController.navigationController?.popViewController(animated: true)
        })
        .disposed(by: disposeBag)

    rightButton.rx.tap.asDriver()
      .drive(onNext: { [weak self] _ in
        self?.shareFolder()
      })
      .disposed(by: disposeBag)

    navigationController.pushViewController(folderDetailViewController, animated: true)
  }
}

// MARK: - 1Depth

extension FolderDetailCoordinator {
  func shareFolder() {
    //TODO: will be implemented.
  }
}
