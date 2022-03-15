//
//  SearchViewController.swift
//  Tidify
//
//  Created by Ian on 2022/03/12.
//

import UIKit

import RxCocoa
import RxSwift

final class SearchViewController: BaseViewController {

    // MARK: - Properties
    private weak var searchTextField: UITextField!
    private weak var tableView: UITableView!

    private let viewModel: SearchViewModel
    private let disposeBag = DisposeBag()
    private let eraseAllHistorySubject = PublishSubject<Void>()

    // MARK: - Initializer
    init(_ viewModel: SearchViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        let endTextFieldEdit = searchTextField.rx.controlEvent(
            [.editingDidEnd, .editingDidEndOnExit]
        ).asObservable()

        let input = SearchViewModel.Input(
            eraseAllHistoryButtonTap: eraseAllHistorySubject.asObservable(),
            beginTextFieldEdit: searchTextField.rx.controlEvent(.editingDidBegin).asObservable(),
            endTextFieldEdit: endTextFieldEdit)
        let output = viewModel.transform(input)

        output.didTapEraseAllHistoryButton
            .subscribe()
            .disposed(by: disposeBag)

        output.didChangedSearchViewMode
            .drive(onNext: { [weak self] in
                self?.tableView.reloadData()
            })
            .disposed(by: disposeBag)

        output.textFieldControlEvent
            .subscribe(onNext: {
                print("⚠️ [Ian] \(#file) - \(#line): \(#function): ")
            })
            .disposed(by: disposeBag)
    }

    override func setupViews() {
        view.backgroundColor = .white

        let searchImageView = UIImageView().then {
            $0.image = R.image.search_icon()
            $0.frame = CGRect(x: 15,
                              y: 0,
                              width: $0.image?.size.width ?? 0,
                              height: $0.image?.size.height ?? 0)
        }

        let leftView = UIView().then {
            $0.frame = CGRect(x: 0,
                              y: 0,
                              width: searchImageView.frame.width + 30,
                              height: searchImageView.frame.height)
            $0.addSubview(searchImageView)
        }

        self.searchTextField = UITextField().then {
            $0.placeholder = R.string.localizable.settingSearchPlaceholder()
            $0.leftView = leftView
            $0.leftViewMode = .always
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.t_cornerRadius(radius: 20)
            view.addSubview($0)
        }

        self.tableView = UITableView(frame: .zero, style: .grouped).then {
            $0.delegate = self
            $0.dataSource = self
            $0.separatorStyle = .none
            $0.backgroundColor = .white
            $0.t_registerCellClass(cellType: SearchHistoryCell.self)
            $0.t_registerCellClass(cellType: BookMarkTableViewCell.self)
            if #available(iOS 15, *) {
                $0.sectionHeaderTopPadding = 0
            }
            view.addSubview($0)
        }
    }

    override func setupLayoutConstraints() {
        searchTextField.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(38)
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().inset(20)
            $0.height.equalToSuperview().multipliedBy(0.07)
        }

        tableView.snp.makeConstraints {
            $0.top.equalTo(searchTextField.snp.bottom).offset(30)
            $0.leading.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}

// MARK: UITableViewDataSource
extension SearchViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView,
                   numberOfRowsInSection section: Int) -> Int {
        switch viewModel.searchViewModeRelay.value {
        case .history:
            return 10
        case .search:
            return 10
        }
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell

        switch viewModel.searchViewModeRelay.value {
        case .history:
            let historyCell = tableView.t_dequeueReusableCell(cellType: SearchHistoryCell.self,
                                                              indexPath: indexPath)
            historyCell.configure("contents\(indexPath.row)")
            cell = historyCell
        case .search:
            cell = UITableViewCell()
        }

        return cell
    }

    func tableView(_ tableView: UITableView,
                   viewForHeaderInSection section: Int) -> UIView? {
        switch viewModel.searchViewModeRelay.value {
        case .history:
            return SearchHistoryHeaderView(
                eraseAllButtonTapObserver: eraseAllHistorySubject.asObserver())
        case .search:
            return nil
        }
    }

    func tableView(_ tableView: UITableView,
                   heightForHeaderInSection section: Int) -> CGFloat {
        switch viewModel.searchViewModeRelay.value {
        case .history:
            return view.frame.height * 0.02
        case .search:
            return .zero
        }
    }
}

// MARK: UITableViewDelegate
extension SearchViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView,
                   heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.frame.height * 0.075
    }

    func tableView(_ tableView: UITableView,
                   didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
    }
}
