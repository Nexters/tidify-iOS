//
//  CreateFolderViewController.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/21.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class CreateFolderViewController: BaseViewController {

    // MARK: - Properties

    private weak var collectionView: UICollectionView!
    private let profileButton: UIButton!
    private let createFolderButton: UIButton!

    private let viewModel: CreateFolderViewModel
    private let disposeBag = DisposeBag()

    private lazy var navigationBar = TidifyNavigationBar(.rounded,
                                                        leftButton: profileButton,
                                                        rightButtons: [createFolderButton])

    // MARK: - Initialize

    init(viewModel: CreateFolderViewModel, leftButton: UIButton!, rightButton: UIButton!) {
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

        // Do any additional setup after loading the view.
    }

    override func setupViews() {
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

extension CreateFolderViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        return UICollectionViewCell()
    }
}

// MARK: - Delegate

extension CreateFolderViewController: UICollectionViewDelegate {

}

private extension CreateFolderViewController {
    func setupNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
