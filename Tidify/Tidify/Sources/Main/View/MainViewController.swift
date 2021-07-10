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

class MainViewController: UIViewController {
    weak var coordinator: MainCoordinator?

    private weak var tableView: UITableView!
    private let viewModel: MainViewModel!

    private let cellTapSubject = PublishSubject<BookMark>()
    private let disposeBag = DisposeBag()

    init(_ viewModel: MainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayoutConstraints()

        let input = MainViewModel.Input(cellTapSubject: cellTapSubject.asObservable())
        let output = viewModel.transfrom(input)

        output.cellTapEvent
            .drive()
            .disposed(by: disposeBag)
    }
}

extension MainViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.mockUpData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: BookMarkTableViewCell = tableView.t_dequeueReusableCell(indexPath: indexPath)
        let bookMark = viewModel.mockUpData[indexPath.row]
        cell.setBookMark(bookMark)

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BookMarkTableViewCell.cellHeight
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let bookMark = viewModel.mockUpData[indexPath.row]
        cellTapSubject.onNext(bookMark)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

private extension MainViewController {
    func setupViews() {
        view.backgroundColor = .white

        let tableView = UITableView().then {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.t_registerCellClass(cellType: BookMarkTableViewCell.self)
            view.addSubview($0)
        }
        self.tableView = tableView
    }

    func setupLayoutConstraints() {
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
