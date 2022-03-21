//
//  FolderDetailViewController.swift
//  Tidify
//
//  Created by 한상진 on 2022/03/21.
//

import RxSwift

class FolderDetailViewController: BaseViewController {

  // MARK: - Properties

  weak var coordinator: FolderDetailCoordinator?

  private weak var collectionView: UICollectionView!
  private var naviTitleString: String!
  private var containerView: UIView!
  private var emptyLabel: UILabel!
  private let backButton: UIButton!
  private let shareFolderButton: UIButton!

  private let viewModel: FolderDetailViewModel
  private let disposeBag = DisposeBag()

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
//      $0.t_registerCellClass(cellType: FolderCollectionViewCell.self)
      $0.isHidden = true
      containerView.addSubview($0)
    }

    self.emptyLabel = UILabel().then {
      $0.text = R.string.localizable.folderNoticeBookmarkEmptyTitle()
      $0.textColor = .t_indigo2()
      $0.font = .t_B(16)
      $0.textAlignment = .center
//      $0.isHidden = true
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
    navigationBar.t_cornerRadius([.bottomLeft, .bottomRight], radius: 16)
  }

  func setupCollectionView() {
//    guard !viewModel.bookMarkList.value.isEmpty else {
//      emptyLabel.isHidden = false
//      collectionView.isHidden = true
//      return
//    }
//    collectionView.isHidden = false
//
//    viewModel.bookMarkList
//      .bind(to: collectionView.rx.items) { [weak self] _, row, item -> UICollectionViewCell in
//        guard let self = self else { return UICollectionViewCell() }
//        let cell = self.collectionView.t_dequeueReusableCell(
//          cellType: FolderCollectionViewCell.self,
//          indexPath: IndexPath.init(row: row, section: 0)
//        )
//
//        cell.editButton.addTarget(self,
//                                  action: #selector(self.editWasTapped(_:)),
//                                  for: .touchUpInside)
//        cell.deleteButton.addTarget(self,
//                                    action: #selector(self.deleteWasTapped(_:)),
//                                    for: .touchUpInside)
//        cell.setFolder(
//          item,
//          buttonTag: row,
//          lastIndexObserver: self.viewModel.lastIndexSubject.asObserver()
//        )
//        return cell
//      }
//      .disposed(by: disposeBag)
//
//    viewModel.lastIndexSubject
//      .filter { [weak self] in $0 != (self?.viewModel.lastIndex ?? 0) }
//      .subscribe(onNext: { [weak self] in
//        let lastIndex = IndexPath(item: self?.viewModel.lastIndex ?? 0, section: 0)
//        guard let self = self,
//              let cell = self.collectionView.cellForItem(at: lastIndex)
//                as? FolderCollectionViewCell else { return }
//        cell.initSwipeView()
//        self.viewModel.lastIndex = $0
//      })
//      .disposed(by: disposeBag)
  }

  @objc
  func editWasTapped(_ sender: UIButton) {
  }

  @objc
  func deleteWasTapped(_ sender: UIButton) {
  }
}
