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

    // MARK: - Constants

    static let outerCellHeight: CGFloat = 68
    static let innerCellHeight: CGFloat = 56

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

        let input = SettingViewModel.Input(userTapEvent: userTapEvent.t_asDriverSkipError())

        let output = viewModel.transform(input)

        output.didUserTapCell.drive().disposed(by: disposeBag)
    }

    // MARK: - Methods

    override func setupViews() {
        self.tableView = UITableView(frame: .zero, style: .insetGrouped).then {
            $0.delegate = self
            $0.dataSource = self
            $0.backgroundColor = .init(235, 235, 240, 100)
            $0.separatorStyle = .none
            $0.t_registerCellClass(cellType: DefaultTableViewCell.self)
            view.addSubview($0)
        }
    }

    override func setupLayoutConstraints() {
        tableView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide)
            make.leading.trailing.bottom.equalToSuperview()
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
            return 3
        case .dataManagement:
            return 3
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let section = SettingViewModel.Section(rawValue: indexPath.section) else {
            return UITableViewCell()
        }

        let cell = tableView.t_dequeueReusableCell(cellType: DefaultTableViewCell.self, indexPath: indexPath)

        switch section {
        case .account:
            switch indexPath.row {
            case 0:
                cell.setCell("계정관리", isHeader: true, showDisclosure: false)
            case 1:
                cell.setCell("프로필", isHeader: false, showDisclosure: true)
            case 2:
                cell.setCell("소셜 로그인", isHeader: false, showDisclosure: true)
            default:
                return DefaultTableViewCell()
            }

        case .dataManagement:
            switch indexPath.row {
            case 0:
                cell.setCell("데이터 관리", isHeader: true, showDisclosure: false)
            case 1:
                cell.setCell("이미지 캐시 정리", isHeader: false, showDisclosure: false)
            case 2:
                cell.setCell("모든 캐시 정리", isHeader: false, showDisclosure: false)
            default:
                return DefaultTableViewCell()
            }
        }

        return cell
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = SettingViewModel.Section(rawValue: indexPath.section) else {
            return .zero
        }

        switch section {
        case .account:
            switch indexPath.row {
            case 0, 2:
                return Self.outerCellHeight
            case 1:
                return Self.innerCellHeight
            default:
                return .zero
            }
        case .dataManagement:
            switch indexPath.row {
            case 0, 2:
                return Self.outerCellHeight
            case 1:
                return Self.innerCellHeight
            default:
                return .zero
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let section = SettingViewModel.Section(rawValue: section) else {
            return UIView()
        }

        if section == .dataManagement {
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.frame.width, height: 16))
            paddingView.backgroundColor = .clear

            return paddingView
        }

        return UIView()
    }
}

// MARK: - Delegate

extension SettingViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let section = SettingViewModel.Section(rawValue: indexPath.section) else {
            return
        }

        switch section {
        case .account:
            switch indexPath.row {
            case 1:
                coordinator?.goToProfile()
            case 2:
                coordinator?.goToSocialLogin()
            default:
                return
            }

        case .dataManagement:
            switch indexPath.row {
            case 1:
                let cancelButton: Notifier.AlertButtonAction = (R.string.localizable.settingAlertImageCacheCancelTitle(), { [weak self] in self?.dismiss(animated: true, completion: nil) })
                let okButton: Notifier.AlertButtonAction = (R.string.localizable.settingAlertImageCacheOkTitle(), { [weak self] in self?.dismiss(animated: true, completion: nil) })
                Notifier.alert(on: self, title: R.string.localizable.settingAlertImageCacheTitle(), message: R.string.localizable.settingAlertImageCacheMessage(), buttons: [cancelButton, okButton])
            case 2:
                let cancelButton: Notifier.AlertButtonAction = (R.string.localizable.settingAlertAllCacheCancelTitle(), { [weak self] in  self?.dismiss(animated: true, completion: nil) })
                let okButton: Notifier.AlertButtonAction = (R.string.localizable.settingAlertAllCacheOkTitle(), { [weak self] in self?.dismiss(animated: true, completion: nil) })
                Notifier.alert(on: self, title: R.string.localizable.settingAlertAllCacheTitle(), message: R.string.localizable.settingAlertAllCacheMessage(), buttons: [cancelButton, okButton])
            default:
                return
            }
        }
    }
}
