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

    weak var coordinator: Coordinator?

    private weak var collectionView: UICollectionView!
    private weak var customHeaderView: UIView!
    private weak var registerBookMarkButton: UIButton!
    private let viewModel: HomeViewModel!

    private let cellTapSubject = PublishSubject<BookMark>()
    private let addListItemSubject = PublishSubject<URL>()
    private let disposeBag = DisposeBag()

    private var observer: NSObjectProtocol?

    // MARK: - Initialize

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] _ in
            self.viewShown()
        }

        setupViews()
        setupLayoutConstraints()

        let input = HomeViewModel.Input(registerButtonTap: registerBookMarkButton.rx.tap.asDriver().map { _ in },
                                        cellTapSubject: cellTapSubject.asObservable(),
                                        addListItemSubject: addListItemSubject.asObserver())
        let output = viewModel.transfrom(input)

        output.registerButtonTap.drive().disposed(by: disposeBag)
        output.cellTapEvent.drive().disposed(by: disposeBag)

        output.didReceiveBookMarks
            .drive(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .disposed(by: disposeBag)

        output.addListItem
            .do(onNext: { [weak self] _ in
                self?.collectionView.reloadData()
            })
            .drive()
            .disposed(by: disposeBag)
    }

    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    // MARK: - Methods

    override func setupViews() {
        view.backgroundColor = .white

        let customHeaderView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.shadowColor = UIColor.gray.cgColor
            $0.layer.shadowOpacity = 0.7
            $0.layer.shadowOffset = CGSize(w: 0, h: 3)
            $0.layer.shadowRadius = 10
            $0.layer.masksToBounds = false
            view.addSubview($0)
        }
        self.customHeaderView = customHeaderView

        let flowLayout = UICollectionViewFlowLayout()

        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout).then {
            $0.delegate = self
            $0.dataSource = self
            $0.t_registerCellClass(cellType: BookMarkCollectionViewCell.self)
            $0.t_registerCellClass(cellType: NoticeEmptyCollectionViewCell.self)
            $0.backgroundColor = .white
            view.addSubview($0)
        }
        self.collectionView = collectionView

        let registerBookMarkButton = UIButton().then {
            $0.setTitle(R.string.localizable.mainAddBookMarkTitle(), for: .normal)
            $0.titleLabel?.font = .t_B(20)
            $0.backgroundColor = .t_tidiBlue()
            $0.layer.cornerRadius = 16
            customHeaderView.addSubview($0)
        }
        self.registerBookMarkButton = registerBookMarkButton
    }

    override func setupLayoutConstraints() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
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
        let bookMark = self.viewModel.bookMarkList[indexPath.item]

        cellTapSubject.onNext(bookMark)
    }
}

// MARK: - DelegateFlowLayout

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(w: self.collectionView.frame.width, h: 50)
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
}
