//
//  FolderTabViewController.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/21.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class FolderTabViewController: BaseViewController {

  // MARK: - Properties

  weak var coordinator: FolderTabCoordinator?

  private weak var collectionView: UICollectionView!
  private var containerView: UIView!
  private var emptyLabel: UILabel!
  private let profileButton: UIButton!
  private let createFolderButton: UIButton!

  private let viewModel: FolderTabViewModel

  private lazy var navigationBar = TidifyNavigationBar(.folder,
                                                       leftButton: profileButton,
                                                       rightButtons: [createFolderButton])

  // MARK: - Initialize

  init(viewModel: FolderTabViewModel, leftButton: UIButton!, rightButton: UIButton!) {
    self.viewModel = viewModel
    self.profileButton = leftButton
    self.createFolderButton = rightButton

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Override

  override func viewDidLoad() {
    super.viewDidLoad()

    let input = FolderTabViewModel.Input()
    let output = viewModel.transform(input)

    output.didReceiveFolders
      .drive(onNext: { [weak self] _ in
        self?.collectionView.reloadData()
      })
      .disposed(by: disposeBag)

    profileButton.rx.tap.asDriver()
      .drive(onNext: { [weak self] _ in
        self?.coordinator?.pushSettingView()
      })
      .disposed(by: disposeBag)

    createFolderButton.rx.tap.asDriver()
      .drive(onNext: { [weak self] _ in
        self?.coordinator?.pushCreateFolderView()
      })
      .disposed(by: disposeBag)

    setupCollectionView()
  }

  override func setupViews() {
    setupNavigationBar()

    let flowLayout = UICollectionViewFlowLayout().then {
      $0.itemSize = CGSize(
        w: FolderCollectionViewCell.width,
        h: FolderCollectionViewCell.height
      )
    }

    self.containerView = UIView().then {
      $0.backgroundColor = .white
      $0.t_cornerRadius([.topLeft, .topRight], radius: 16)
      view.addSubview($0)
    }

    self.collectionView = UICollectionView(
      frame: .zero,
      collectionViewLayout: flowLayout
    ).then {
      $0.backgroundColor = .white
      $0.t_registerCellClass(cellType: FolderCollectionViewCell.self)
      $0.isHidden = true
      containerView.addSubview($0)
    }

    self.emptyLabel = UILabel().then {
      $0.text = R.string.localizable.folderNoticeEmptyTitle()
      $0.textColor = .t_indigo02()
      $0.font = .t_B(16)
      $0.textAlignment = .center
      $0.isHidden = true
      containerView.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    containerView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom).offset(16)
      $0.leading.trailing.bottom.equalToSuperview()
    }
    collectionView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(24)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-140)
    }

    emptyLabel.snp.makeConstraints{
      $0.top.equalToSuperview().offset(70)
      $0.leading.trailing.equalToSuperview()
    }
  }
}

private extension FolderTabViewController {
  func setupNavigationBar() {
    view.addSubview(navigationBar)
    navigationBar.snp.makeConstraints {
      $0.top.equalTo(view.top)
      $0.leading.trailing.equalToSuperview()
    }
    navigationBar.t_cornerRadius([.bottomLeft, .bottomRight], radius: 16)
  }

  func setupCollectionView() {
    guard !viewModel.folderListRelay.value.isEmpty else {
      emptyLabel.isHidden = false
      collectionView.isHidden = true
      return
    }
    collectionView.isHidden = false

    viewModel.folderListRelay
      .bind(to: collectionView.rx.items) { [weak self] _, row, item -> UICollectionViewCell in
        guard let self = self else { return UICollectionViewCell() }
        let cell = self.collectionView.t_dequeueReusableCell(
          cellType: FolderCollectionViewCell.self,
          indexPath: IndexPath(row: row, section: 0)
        )

        cell.editButton.addTarget(self,
                                  action: #selector(self.didTapEditButton(_:)),
                                  for: .touchUpInside)
        cell.deleteButton.addTarget(self,
                                    action: #selector(self.didTapDeleteButton(_:)),
                                    for: .touchUpInside)
        cell.setFolder(
          item,
          buttonTag: row,
          lastIndexObserver: self.viewModel.lastIndexSubject.asObserver()
        )
        return cell
      }
      .disposed(by: disposeBag)

    viewModel.lastIndexSubject
      .filter { [weak self] in $0 != (self?.viewModel.lastIndex ?? 0) }
      .subscribe(onNext: { [weak self] in
        let lastIndex = IndexPath(item: self?.viewModel.lastIndex ?? 0, section: 0)
        guard let self = self,
              let cell = self.collectionView.cellForItem(at: lastIndex)
                as? FolderCollectionViewCell else { return }

        cell.t_initSwipeView(
          swipeView: cell.swipeView,
          width: cell.width,
          isSwiped: cell.isSwiped
        )
        self.viewModel.lastIndex = $0
      })
      .disposed(by: disposeBag)

    collectionView.rx.modelSelected(Folder.self)
      .bind { [weak self] in
        guard let self = self else { return }
        self.coordinator?.pushFolderDetailView(titleString: $0.name)
      }
      .disposed(by: disposeBag)
  }

  @objc
  func didTapEditButton(_ sender: UIButton) {
    print("edit Was Tapped") // TODO
  }

  @objc
  func didTapDeleteButton(_ sender: UIButton) {
    let nextAction: Notifier.AlertButtonAction = (
      R.string.localizable.folderNotifierDeleteCancel(),
      nil,
      .default
    )
    let deleteAction: Notifier.AlertButtonAction = (
      R.string.localizable.folderNotifierDeleteAccept(),
      { [weak self] in
        guard let self = self else { return }
        var folderList = self.viewModel.folderListRelay.value
          folderList.remove(at: sender.tag)
        self.viewModel.folderListRelay.accept(folderList)
      },
      .destructive
    )

    Notifier.alert(
      on: self,
      title: R.string.localizable.folderNotifierDeleteTitle(),
      message: R.string.localizable.folderNotifierDeleteMessage(),
      buttons: [nextAction, deleteAction]
    )
  }
}
