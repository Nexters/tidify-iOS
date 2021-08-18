//
//  MainViewController.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class HomeViewController: BaseViewController {

    // MARK: - Properties

    weak var coordinator: HomeCoordinator?

    private weak var collectionView: UICollectionView!
    private weak var customHeaderView: UIView!
    private let profileButton: UIButton!
    private let createBookMarkButton: UIButton!

    private let viewModel: HomeViewModel!
    private let cellTapSubject = PublishSubject<BookMark>()
    private let addListItemSubject = PublishSubject<URL>()
    private let disposeBag = DisposeBag()

    lazy var navigationBar = TidifyNavigationBar(.rounded,
                                                 leftButton: profileButton,
                                                 rightButtons: [createBookMarkButton])

    // MARK: - Initialize

    init(viewModel: HomeViewModel, leftButton: UIButton, rightButton: UIButton) {
        self.viewModel = viewModel
        self.profileButton = leftButton
        self.createBookMarkButton = rightButton

        super.init(nibName: nil, bundle: nil)

        self.rx.viewDidLoad
            .subscribe(onNext: { [weak self] _ in
                self?.viewShown()
            })
            .disposed(by: disposeBag)

        self.profileButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.coordinator?.pushSettingView()
            })
            .disposed(by: disposeBag)

        self.createBookMarkButton.rx.tap
            .asDriver()
            .drive(onNext: { [weak self] _ in
                self?.coordinator?.pushRegisterView()
            })
            .disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        let input = HomeViewModel.Input(cellTapSubject: cellTapSubject.t_asDriverSkipError())
        let output = viewModel.transform(input)

        output.cellTapEvent.drive().disposed(by: disposeBag)

        output.didReceiveBookMarks
            .drive(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

    override func setupViews() {
        setupNavigationBar()
        view.backgroundColor = .white

        let flowLayout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
            $0.delegate = self
            $0.dataSource = self
            $0.t_registerCellClass(cellType: BookMarkCollectionViewCell.self)
            $0.t_registerCellClass(cellType: NoticeEmptyCollectionViewCell.self)
            $0.backgroundColor = .init(235, 235, 240, 100)
            view.addSubview($0)
        }
        self.collectionView = collectionView
    }

    override func setupLayoutConstraints() {
        collectionView.snp.makeConstraints {
            $0.top.equalTo(navigationBar.snp.bottom).inset(15)
            $0.leading.trailing.bottom.equalToSuperview()
        }
    }
}

// MARK: - DataSource

extension HomeViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let isEmptyDataSource = self.viewModel.bookMarkList.isEmpty

        return isEmptyDataSource ? 1 : self.viewModel.bookMarkList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let isEmptyDataSource = self.viewModel.bookMarkList.isEmpty

        if isEmptyDataSource {
            let cell = collectionView.t_dequeueReusableCell(cellType: NoticeEmptyCollectionViewCell.self,
                                                            indexPath: indexPath)

            cell.contentView.t_cornerRadius([.topLeft, .topRight], radius: 18)

            return cell
        } else {
            let cell = collectionView.t_dequeueReusableCell(cellType: BookMarkCollectionViewCell.self,
                                                            indexPath: indexPath)
            let bookMark = self.viewModel.bookMarkList[indexPath.item]
            cell.setBookMark(bookMark)

            return cell
        }
    }
}

// MARK: - Delegate

extension HomeViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let isEmptyDataSource = self.viewModel.bookMarkList.isEmpty

        if isEmptyDataSource {
            return
        }

        let bookMark = self.viewModel.bookMarkList[indexPath.item]

        cellTapSubject.onNext(bookMark)
    }
}

// MARK: - DelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(w: self.collectionView.frame.width, h: BookMarkCollectionViewCell.cellHeight)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if section == .zero {
            return UIEdgeInsets(top: 30, left: 0, bottom: 0, right: 0)
        }

        return UIEdgeInsets.zero
    }
}

private extension HomeViewController {
    func viewShown() {
        if let userDefaults = UserDefaults(suiteName: "group.com.aksmj.Tidify") {
            if let bookMarkUrl = userDefaults.string(forKey: "newBookMark") {
                self.addListItemSubject
                    .onNext(URL(string: bookMarkUrl)!)

                userDefaults.removeObject(forKey: "newBookMark")
            }
        }
    }

    func setupNavigationBar() {
        view.addSubview(navigationBar)
        navigationBar.snp.makeConstraints {
            $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
        }
    }
}
