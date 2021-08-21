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
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

// MARK: - Delegate

extension FolderTabViewController: UICollectionViewDelegate {

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
