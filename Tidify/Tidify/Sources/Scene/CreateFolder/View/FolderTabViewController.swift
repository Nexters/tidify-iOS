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
    private let disposeBag = DisposeBag()

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
        view.backgroundColor = .t_background()

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
            $0.textColor = .t_indigo2()
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
        guard !viewModel.folderList.value.isEmpty else {
            emptyLabel.isHidden = false
            collectionView.isHidden = true
            return
        }
        collectionView.rx.setDelegate(self).disposed(by: disposeBag)
        collectionView.isHidden = false

        viewModel.folderList
            .bind(to: collectionView.rx.items) {_, row, item -> UICollectionViewCell in
                let cell = self.collectionView.t_dequeueReusableCell(
                    cellType: FolderCollectionViewCell.self,
                    indexPath: IndexPath.init(row: row, section: 0)
                )

                cell.editButton.tag = row
                cell.deleteButton.tag = row
                cell.editButton.addTarget(self,
                                          action: #selector(self.editWasTapped(_:)),
                                          for: .touchUpInside)
                cell.deleteButton.addTarget(self,
                                            action: #selector(self.deleteWasTapped(_:)),
                                            for: .touchUpInside)
                cell.setFolder(item)
                return cell
            }
            .disposed(by: disposeBag)
    }

    @objc
    func editWasTapped(_ sender: UIButton) {
        print("edit Was Tapped") // TODO
    }

    @objc
    func deleteWasTapped(_ sender: UIButton) {
        var data = viewModel.folderList.value
        data.remove(at: sender.tag)
        viewModel.folderList.accept(data)
    }
}

// MARK: - Delegate

extension FolderTabViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        performAction action: Selector,
        forItemAt indexPath: IndexPath,
        withSender sender: Any?
    ) {
        guard viewModel.lastIndex != nil else { viewModel.lastIndex = indexPath; return }
        guard let lastIndex = viewModel.lastIndex, lastIndex != indexPath else { return }
        guard let cell = collectionView.cellForItem(at: lastIndex)
                as? FolderCollectionViewCell else { return }

        cell.initSwipeView()
        viewModel.lastIndex = indexPath
    }
}
