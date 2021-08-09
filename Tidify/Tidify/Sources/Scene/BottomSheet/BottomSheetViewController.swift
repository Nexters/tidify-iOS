//
//  BottomSheetViewController.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/10.
//

import RxCocoa
import RxSwift
import UIKit

class BottomSheetViewController: BaseViewController {

    // MARK: - Constants

    static let bottomSheetTopPaddingWhenPresent: CGFloat = 250
    static let bottomSheetHeaderViewHeight: CGFloat = 60

    // MARK: - Properties

    private weak var dimmedView: UIView!
    private weak var tableView: UITableView!

    private var tagList: [String]
    private let selectedEventObserver: AnyObserver<Int>
    private let disposeBag = DisposeBag()


    // MARK: - Initialize

    init(tagList: [String], selectedEventObserver: AnyObserver<Int>) {
        self.tagList = tagList
        self.selectedEventObserver = selectedEventObserver

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayoutConstraints()

        Driver.merge(dimmedView.t_addTap().rx.event.asDriver().map { _ in })
            .drive(onNext: { [weak self] _ in
                self?.hideBottomSheet()
            })
            .disposed(by: disposeBag)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        showBottomSheet()
    }

    // MARK: - Methods

    override func setupViews() {
        let dimmedView = UIView()
        dimmedView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        view.addSubview(dimmedView)
        self.dimmedView = dimmedView

        let bottomSheetTableView = UITableView(frame: .zero)
        bottomSheetTableView.backgroundColor = .white
        bottomSheetTableView.layer.cornerRadius = 10
        bottomSheetTableView.clipsToBounds = true
        bottomSheetTableView.delegate = self
        bottomSheetTableView.dataSource = self
        bottomSheetTableView.separatorStyle = .none
        bottomSheetTableView.t_registerCellClass(cellType: BottomSheetTableViewCell.self)
        view.addSubview(bottomSheetTableView)
        self.tableView = bottomSheetTableView
    }

    override func setupLayoutConstraints() {
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        tableView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(view.frame.height)
        }
    }
}

// MARK: - DataSource

extension BottomSheetViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tagList.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.t_dequeueReusableCell(cellType: BottomSheetTableViewCell.self, indexPath: indexPath)
        cell.setTag(tagList[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedEventObserver.onNext(indexPath.row)
    }
}

// MARK: - Delegate

extension BottomSheetViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = BottomSheetHeaderView()
        headerView.setBottomSheetHeader(R.string.localizable.bottomSheetTagTitle())

        return headerView
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return Self.bottomSheetHeaderViewHeight
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return BottomSheetTableViewCell.cellHeight
    }
}

private extension BottomSheetViewController {
    func showBottomSheet() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let strongSelf = self else {
                return
            }

            strongSelf.dimmedView.alpha = 0.7
            strongSelf.tableView.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(Self.bottomSheetTopPaddingWhenPresent)
            }
            strongSelf.view.layoutIfNeeded()
        })
    }

    func hideBottomSheet() {
        UIView.animate(withDuration: 0.5, animations: { [weak self] in
            guard let strongSelf = self else {
                return
            }

            strongSelf.dimmedView.alpha = 0
            strongSelf.tableView.snp.updateConstraints { make in
                make.top.equalToSuperview().offset(strongSelf.view.frame.height)
            }
            strongSelf.view.layoutIfNeeded()
        }, completion: { [weak self] _ in
            if self?.presentingViewController != nil {
                self?.dismiss(animated: false, completion: nil)
            }
        })
    }
}

