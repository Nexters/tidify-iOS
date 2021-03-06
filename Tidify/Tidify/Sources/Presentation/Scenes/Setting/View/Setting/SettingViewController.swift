//
//  SettingViewController.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/27.
//

import Kingfisher
import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

final class SettingViewController: BaseViewController {

  // MARK: - Constants

  static let outerCellHeight: CGFloat = 68
  static let innerCellHeight: CGFloat = 56

  // MARK: - Properties

  weak var coordinator: SettingCoordinator?
  private weak var tableView: UITableView!
  private let backButton: UIButton!

  private let viewModel: SettingViewModel
  private let userTapEvent = PublishSubject<SettingUserTapCase>()
  private let appLockTapEvent = PublishSubject<Void>()
  private let appLockIsOn = PublishSubject<Bool>()

  lazy var navigationBar = TidifyNavigationBar(
    .default,
    title: "",
    leftButton: backButton,
    rightButtons: [])

  // MARK: - Initialize

  init(viewModel: SettingViewModel, leftButton: UIButton) {
    self.viewModel = viewModel
    self.backButton = leftButton

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - LifeCycle

  override func viewDidLoad() {
    super.viewDidLoad()

    let input = SettingViewModel.Input(userTapEvent: userTapEvent.t_asDriverSkipError())
    let output = viewModel.transform(input)

    output.didUserTapCell.drive().disposed(by: disposeBag)
  }

  // MARK: - Methods

  override func setupViews() {
    setupNavigationBar()

    view.backgroundColor = .white

    self.tableView = UITableView().then {
      $0.delegate = self
      $0.dataSource = self
      $0.backgroundColor = .init(235, 235, 240, 100)
      $0.separatorStyle = .none
      $0.t_registerCellClass(cellType: DefaultTableViewCell.self)
      if #available(iOS 15, *) {
        $0.sectionHeaderTopPadding = 0
      }
      view.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    tableView.snp.makeConstraints { make in
      make.top.equalTo(navigationBar.snp.bottom)
      make.leading.trailing.bottom.equalToSuperview()
    }
  }
}

private extension SettingViewController {
  func setupNavigationBar() {
    view.addSubview(navigationBar)
    navigationBar.snp.makeConstraints {
      $0.top.leading.trailing.equalTo(view.safeAreaLayoutGuide)
    }
  }
}

// MARK: - DataSource

extension SettingViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return SettingViewModel.Section.allCases.count
  }

  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    guard let section = SettingViewModel.Section(rawValue: section) else {
      return .zero
    }

    return section.numberOfRows
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let section = SettingViewModel.Section(rawValue: indexPath.section) else {
      return UITableViewCell()
    }

    let cell = tableView.t_dequeueReusableCell(cellType: DefaultTableViewCell.self,
                                               indexPath: indexPath)

    switch section {
    case .account:
      switch indexPath.row {
      case 0:
        cell.setCell(R.string.localizable.settingAccount(),
                     isHeader: true)
      case 1:
        cell.setCell(R.string.localizable.settingAccountSocialLogin(),
                     showDisclosure: true,
                     radiusEdges: [.bottomLeft, .bottomRight],
                     radius: 15)
      default:
        return DefaultTableViewCell()
      }

    case .dataManagement:
      switch indexPath.row {
      case 0:
        cell.setCell(R.string.localizable.settingDataManagement(),
                     isHeader: true,
                     radiusEdges: [.topLeft, .topRight],
                     radius: 15)
      case 1:
        cell.setCell(R.string.localizable.settingDataManagementImageCache())
      case 2:
        cell.setCell(R.string.localizable.settingDataManagementCache())
      case 3:
        cell.setCell(R.string.localizable.settingDataManagementLogout())
      case 4:
        cell.setCell(R.string.localizable.settingDatamanagementAppVersion(),
                     radiusEdges: [.bottomLeft, .bottomRight],
                     radius: 15)
        cell.titleLabel.font = .t_R(12)
        cell.titleLabel.textColor = .lightGray
      default:
        return DefaultTableViewCell()
      }
    }

    return cell
  }

  func tableView(_ tableView: UITableView,
                 heightForRowAt indexPath: IndexPath) -> CGFloat {
    guard let section = SettingViewModel.Section(rawValue: indexPath.section) else {
      return .zero
    }

    switch section {
    case .account:
      switch indexPath.row {
      case 1:
        return Self.outerCellHeight
      default:
        return Self.innerCellHeight
      }
    case .dataManagement:
      switch indexPath.row {
      case 0, 4:
        return Self.outerCellHeight
      default:
        return Self.innerCellHeight
      }
    }
  }

  func tableView(_ tableView: UITableView,
                 viewForHeaderInSection section: Int) -> UIView? {
    guard let section = SettingViewModel.Section(rawValue: section) else {
      return nil
    }

    let sectionHeaderView: UIView?

    switch section {
    case .account:
      let headerView = AccountSectionHeaderView()
      sectionHeaderView = headerView
    case .dataManagement:
      let headerView = UIView()
      headerView.backgroundColor = .clear
      sectionHeaderView = headerView
    }

    return sectionHeaderView
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    guard let section = SettingViewModel.Section(rawValue: section) else {
      return .zero
    }

    switch section {
    case .account:
      return tableView.frame.height / 9
    case .dataManagement:
      return 20
    }
  }
}

// MARK: - Delegate

extension SettingViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    tableView.deselectRow(at: indexPath, animated: false)
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
        let cancelButton: Notifier.AlertButtonAction = (
          R.string.localizable.settingAlertImageCacheCancelTitle(),
          { [weak self] in self?.dismiss(animated: true, completion: nil) },
          .default
        )

        let okButton: Notifier.AlertButtonAction = (
          R.string.localizable.settingAlertImageCacheOkTitle(),
          { [weak self] in ImageCache.default.clearCache()
            self?.dismiss(animated: true, completion: nil) },
          .destructive
        )

        Notifier.alert(on: self,
                       title: R.string.localizable.settingAlertImageCacheTitle(),
                       message: R.string.localizable.settingAlertImageCacheMessage(),
                       buttons: [cancelButton, okButton])
      case 2:
        let cancelButton: Notifier.AlertButtonAction = (
          R.string.localizable.settingAlertAllCacheCancelTitle(),
          { [weak self] in  self?.dismiss(animated: true, completion: nil) },
          .default
        )

        let okButton: Notifier.AlertButtonAction = (
          R.string.localizable.settingAlertAllCacheOkTitle(),
          { [weak self] in ImageCache.default.clearCache()
            URLCache.shared.removeAllCachedResponses()
            self?.dismiss(animated: true, completion: nil) },
          .destructive
        )

        Notifier.alert(on: self,
                       title: R.string.localizable.settingAlertAllCacheTitle(),
                       message: R.string.localizable.settingAlertAllCacheMessage(),
                       buttons: [cancelButton, okButton])
      default:
        return
      }
    }
  }
}
