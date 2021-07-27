//
//  SettingViewController.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/27.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class SettingViewController: BaseViewController {

    // MARK: - Properties

    weak var coordinator: SettingCoordinator?
    private weak var tableView: UITableView!

    private let viewModel: SettingViewModel
    private let userTapEvent = PublishSubject<SettingUserTapCase>()
    private let appLockTapEvent = PublishSubject<Void>()
    private let appLockIsOn = PublishSubject<Bool>()
    private let disposeBag = DisposeBag()

    // MARK: - Initialize

    init(viewModel: SettingViewModel) {
        self.viewModel = viewModel

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

        let input = SettingViewModel.Input(userTapEvent: userTapEvent.t_asDriverSkipError(),
                                           appLockTapEvent: appLockTapEvent.t_asDriverSkipError())

        let output = viewModel.transform(input)

        output.didUserTapCell.drive().disposed(by: disposeBag)

        output.didUserTapAppLock
            .drive(onNext: { [weak self] _ in
                self?.tableView.reloadSections(IndexSet(integer: SettingViewModel.Section.account.rawValue), with: .none)
            })
            .disposed(by: disposeBag)
    }

    // MARK: - Methods

    override func setupViews() {
        let tableView = UITableView().then {
            $0.delegate = self
            $0.dataSource = self
            $0.t_registerCellClass(cellType: RightSwitchTableViewCell.self)
            self.view.addSubview($0)
        }
        self.tableView = tableView
    }

    override func setupLayoutConstraints() {
        tableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}

// MARK: - DataSource

extension SettingViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return SettingViewModel.Section.allCases.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let section = SettingViewModel.Section(rawValue: section) else {
            return .zero
        }

        switch section {
        case .account:
            return 2
        case .security:
            return 2
        }
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let section = SettingViewModel.Section(rawValue: section) else {
            return .none
        }

        switch section {
        case .account:
            return R.string.localizable.settingAccount()
        case .security:
            return R.string.localizable.settingSecurity()
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SettingViewModel.Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        let cell: UITableViewCell
        switch section {
        case .account:
            cell = UITableViewCell()
            cell.accessoryType = .detailButton

            switch indexPath.row {
            case 0:
                cell.textLabel?.text = R.string.localizable.settingAccountProfile()
                cell.accessoryType = .detailButton
            case 1:
                cell.textLabel?.text = R.string.localizable.settingAccountInterLink()
                cell.accessoryType = .detailButton
            default:
                return cell
            }

        case .security:
            switch indexPath.row {
            case 0:
                let rightSwitchCell = RightSwitchTableViewCell()
                rightSwitchCell.textLabel?.text = R.string.localizable.settingSecurityAppLock()
                rightSwitchCell.isOn = viewModel.isOnAppLock
                cell = rightSwitchCell
            case 1:
                cell = UITableViewCell()
                cell.textLabel?.text = R.string.localizable.settingSecurityAuthMethod()
                cell.accessoryType = .detailButton
            default:
                return UITableViewCell()
            }
        }

        return cell
    }
}

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let section = SettingViewModel.Section(rawValue: indexPath.section) else {
            return
        }

        switch section {
        case .account:
            switch indexPath.row {
            case 0:
                coordinator?.goToProfile()
            case 1:
                coordinator?.goToInterLink()
            default:
                return
            }

        case .security:
            switch indexPath.row {
            case 1:
                coordinator?.gotoAuthMethod()
            default:
                return
            }
        }
    }
}
