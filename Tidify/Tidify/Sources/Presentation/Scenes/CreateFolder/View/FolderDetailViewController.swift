//
//  FolderDetailViewController.swift
//  Tidify
//
//  Created by 한상진 on 2022/03/21.
//

import UIKit

import RxSwift

final class FolderDetailViewController: BaseViewController {

  // MARK: - Properties

  weak var coordinator: FolderDetailCoordinator?

  private weak var collectionView: UICollectionView!
  private var naviTitleString: String!
  private var containerView: UIView!
  private var emptyLabel: UILabel!
  private let backButton: UIButton!
  private let shareFolderButton: UIButton!

  private let viewModel: FolderDetailViewModel

  private lazy var navigationBar = TidifyNavigationBar(.folder,
                                                       title: naviTitleString,
                                                       leftButton: backButton,
                                                       rightButtons: [shareFolderButton])

  // MARK: - Initialize

  init(
    viewModel: FolderDetailViewModel,
    titleString: String!,
    leftButton: UIButton!,
    rightButton: UIButton!
  ) {
    self.viewModel = viewModel
    self.naviTitleString = titleString
    self.backButton = leftButton
    self.shareFolderButton = rightButton

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Override

  override func viewDidLoad() {
    super.viewDidLoad()

    let input = FolderDetailViewModel.Input()
    let output = viewModel.transform(input)

    output.didReceiveBookMarks
      .drive(onNext: { [weak self] _ in
        self?.collectionView.reloadData()
      })
      .disposed(by: disposeBag)

    shareFolderButton.rx.tap.asDriver()
      .drive(onNext: { [weak self] _ in
        self?.coordinator?.shareFolder()
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
      $0.t_registerCellClass(cellType: BookMarkCollectionViewCell.self)
      $0.isHidden = true
      containerView.addSubview($0)
    }

    self.emptyLabel = UILabel().then {
      $0.text = R.string.localizable.folderNoticeBookmarkEmptyTitle()
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

private extension FolderDetailViewController {
  func setupNavigationBar() {
    view.addSubview(navigationBar)
    navigationBar.snp.makeConstraints {
      $0.top.equalTo(view.top)
      $0.leading.trailing.equalToSuperview()
    }

    navigationBar.leftButton.snp.updateConstraints {
      $0.width.height.equalTo(24)
      $0.leading.equalToSuperview().offset(8)
      $0.bottom.equalToSuperview().inset(32)
    }

    navigationBar.titleLabel.font = .t_B(20)
    navigationBar.titleLabel.snp.makeConstraints {
      $0.leading.equalTo(navigationBar.leftButton.snp.trailing).offset(16)
    }

    navigationBar.t_cornerRadius([.bottomLeft, .bottomRight], radius: 16)
  }

  func setupCollectionView() {
    guard !viewModel.bookMarkListRelay.value.isEmpty else {
      emptyLabel.isHidden = false
      collectionView.isHidden = true
      return
    }
    collectionView.isHidden = false

    viewModel.bookMarkListRelay
      .bind(to: collectionView.rx.items) { [weak self] _, row, item -> UICollectionViewCell in
        guard let self = self else { return UICollectionViewCell() }
        let cell = self.collectionView.t_dequeueReusableCell(
          cellType: BookMarkCollectionViewCell.self,
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
                as? BookMarkCollectionViewCell else { return }

        cell.t_initSwipeView(
          swipeView: cell.swipeView,
          width: cell.width,
          isSwiped: cell.isSwiped
        )
        self.viewModel.lastIndex = $0
      })
      .disposed(by: disposeBag)
  }

  @objc
  func didTapEditButton(_ sender: UIButton) {
    print("edit Was Tapped") // TODO
  }

  @objc
  func didTapDeleteButton(_ sender: UIButton) {
    let nextAction: Notifier.AlertButtonAction = (
      R.string.localizable.mainNotifierBookMarkButtonNext(),
      nil,
      .default
    )
    let deleteAction: Notifier.AlertButtonAction = (
      R.string.localizable.mainNotifierBookMarkButtonDelete(),
      { [weak self] in
        guard let self = self else { return }
        var bookMarkList = self.viewModel.bookMarkListRelay.value
          bookMarkList.remove(at: sender.tag)
        self.viewModel.bookMarkListRelay.accept(bookMarkList)
      },
      .destructive
    )
    Notifier.alert(
      on: self,
      title: R.string.localizable.mainNotifierBookMarkDeleteTitle(),
      message: R.string.localizable.mainNotifierBookMarkDeleteDesc(),
      buttons: [nextAction, deleteAction]
    )
  }
}
