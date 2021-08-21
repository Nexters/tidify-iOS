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
    private let profileButton: UIButton!
    private let createFolderButton: UIButton!

    private let viewModel: FolderTabViewModel
    private let disposeBag = DisposeBag()

    private lazy var navigationBar = TidifyNavigationBar(.rounded,
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
    }

    override func setupViews() {
        setupNavigationBar()

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .vertical

        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
            $0.backgroundColor = .white
            $0.delegate = self
            $0.dataSource = self
            $0.t_registerCellClass(cellType: FolderCollectionViewCell.self)
            $0.t_registerCellClass(cellType: NoticeEmptyCollectionViewCell.self)
            view.addSubview($0)
        }
    }

    override func setupLayoutConstraints() {
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(navigationBar.snp.bottom)
            make.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - DataSource

extension FolderTabViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let isEmptyDataSource = self.viewModel.folderList.isEmpty

        return isEmptyDataSource ? 1 : self.viewModel.folderList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isEmptyDataSource = self.viewModel.folderList.isEmpty

        if isEmptyDataSource {
            let cell = collectionView.t_dequeueReusableCell(cellType: NoticeEmptyCollectionViewCell.self,
                                                            indexPath: indexPath)
            cell.setNoticeTitle(R.string.localizable.folderNoticeEmptyTitle())
            cell.contentView.t_cornerRadius([.topLeft, .topRight], radius: 18)

            return cell
        } else {
            guard let folder = self.viewModel.folderList[safe: indexPath.item] else {
                return UICollectionViewCell()
            }

            let cell = collectionView.t_dequeueReusableCell(cellType: FolderCollectionViewCell.self,
                                                            indexPath: indexPath)
            cell.setFolder(folder)
            return cell
        }
    }
}

// MARK: - DelegateFlowLayout

extension FolderTabViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(w: FolderCollectionViewCell.width, h: FolderCollectionViewCell.height)
    }
}

// MARK: - Delegate

extension FolderTabViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isEmptyDataSource = self.viewModel.folderList.isEmpty

        if isEmptyDataSource {
            return
        }

        guard let folder = self.viewModel.folderList[safe: indexPath.item] else {
            return
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
    }
}

private extension FolderTabViewController {
    func setupNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
