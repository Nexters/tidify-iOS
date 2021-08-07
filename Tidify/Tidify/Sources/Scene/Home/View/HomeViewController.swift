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

class HomeViewController: UIViewController {
    weak var coordinator: Coordinator?

    private weak var tableView: UITableView!
    private weak var customHeaderView: UIView!
    private weak var registerBookMarkButton: UIButton!
    private let viewModel: HomeViewModel!

    private let cellTapSubject = PublishSubject<BookMark>()
    private let addListItemSubject = PublishSubject<URL>()
    private let disposeBag = DisposeBag()

    private var observer: NSObjectProtocol?

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        observer = NotificationCenter.default.addObserver(forName: UIApplication.willEnterForegroundNotification, object: nil, queue: .main) { [unowned self] _ in
            self.viewShown()
        }

        setupViews()
        setupLayoutConstraints()
        tableView.layoutIfNeeded()

        let input = HomeViewModel.Input(registerButtonTap: registerBookMarkButton.rx.tap.asDriver().map { _ in },
                                        cellTapSubject: cellTapSubject.asObservable(),
                                        addListItemSubject: addListItemSubject.asObserver())
        let output = viewModel.transfrom(input)

        output.registerButtonTap.drive().disposed(by: disposeBag)
        output.cellTapEvent.drive().disposed(by: disposeBag)

        output.didReceiveBookMarks
            .drive(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        output.addListItem
            .do(onNext: { [weak self] _ in
                self?.tableView.reloadData()
            })
            .drive()
            .disposed(by: disposeBag)

        self.generateMockUp()
    }

    deinit {
        if let observer = observer {
            NotificationCenter.default.removeObserver(observer)
        }
    }

    func viewShown() {
        if let userDefaults = UserDefaults(suiteName: "group.com.aksmj.Tidify") {
            if let bookMarkUrl = userDefaults.string(forKey: "newBookMark") {
                self.addListItemSubject
                    .onNext(URL(string: bookMarkUrl)!)

                userDefaults.removeObject(forKey: "newBookMark")
            }
        }
    }

    // TEST
    private func generateMockUp() {
        let mockUpList = [
            URL(string: "https://news.naver.com/main/read.naver?mode=LS2D&mid=shm&sid1=105&sid2=227&oid=366&aid=0000745596")!,
            URL(string: "https://news.naver.com/main/read.naver?mode=LSD&mid=shm&sid1=103&oid=422&aid=0000494233")!,
            URL(string: "https://news.naver.com/main/read.naver?mode=LS2D&mid=shm&sid1=105&sid2=731&oid=014&aid=0004672150")!,
            URL(string: "https://news.naver.com/main/read.naver?mode=LS2D&mid=shm&sid1=105&sid2=228&oid=001&aid=0012516598")!
        ]

        for mockUp in mockUpList {
            self.addListItemSubject
                .onNext(mockUp)
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.bookMarkList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookMarkTableViewCell = tableView.t_dequeueReusableCell(indexPath: indexPath)
        let bookMark = viewModel.bookMarkList[indexPath.row]
        cell.setBookMark(bookMark)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookMarkTableViewCell.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookMark = viewModel.bookMarkList[indexPath.row]
        cellTapSubject.onNext(bookMark)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension HomeViewController {
    func setupViews() {
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

        let tableView = UITableView().then {
            $0.delegate = self
            $0.dataSource = self
            $0.tableHeaderView = customHeaderView
            $0.separatorStyle = .none
            $0.t_registerCellClass(cellType: BookMarkTableViewCell.self)
            view.addSubview($0)
        }
        self.tableView = tableView

        let registerBookMarkButton = UIButton().then {
            $0.setTitle(R.string.localizable.mainAddBookMarkTitle(), for: .normal)
            $0.titleLabel?.font = .t_B(20)
            $0.backgroundColor = .t_tidiBlue()
            $0.layer.cornerRadius = 16
            customHeaderView.addSubview($0)
        }
        self.registerBookMarkButton = registerBookMarkButton
    }

    func setupLayoutConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        customHeaderView.snp.makeConstraints {
            $0.size.equalTo(CGSize(w: view.frame.width, h: 104))
        }

        registerBookMarkButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().offset(-24)
            $0.trailing.equalToSuperview().offset(-20)
            $0.size.equalTo(CGSize(w: 233, h: 48))
        }
    }
}
