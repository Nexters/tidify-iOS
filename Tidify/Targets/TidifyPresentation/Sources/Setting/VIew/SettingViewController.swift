//
//  SettingViewController.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/28.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Combine
import TidifyCore
import TidifyDomain
import UIKit

import Kingfisher
import SnapKit

final class SettingViewController: BaseViewController, Coordinatable, Alertable {

  // MARK: Properties
  weak var coordinator: DefaultSettingCoordinator?
  private let viewModel: SettingViewModel

  private lazy var tableView: UITableView = {
    let tableView: UITableView = .init(frame: .zero, style: .grouped)
    tableView.separatorStyle = .none
    tableView.t_registerCellClass(cellType: SettingCell.self)
    tableView.isScrollEnabled = false
    tableView.delegate = self
    tableView.dataSource = self
    return tableView
  }()

  private lazy var versionLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .t_R(12)
    label.textColor = .lightGray
    label.text = "앱 버전 " + fetchAppVersionInfo()
    return label
  }()

  enum Sections: Int, CaseIterable {
    case accountManaging
    case dataManaging

    var numberOfRows: Int {
      rowTitles.count
    }

    var sectionTitle: String {
      switch self {
      case .accountManaging:
        return "계정"
      case .dataManaging:
        return "데이터 관리"
      }
    }

    var rowTitles: [String] {
      switch self {
      case .accountManaging:
        return ["로그아웃", "회원탈퇴"]
      case .dataManaging:
        return ["이미지 캐시 정리", "모든 캐시 정리"]
      }
    }
  }

  // MARK: - Initializer
  init(viewModel: SettingViewModel) {
    self.viewModel = viewModel
    super.init(nibName: nil, bundle: nil)
    title = "설정"
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupLayoutConstraints()
    bindState()
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    navigationController?.navigationBar.isHidden = false
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    coordinator?.didFinish()
  }

  override func setupViews() {
    super.setupViews()

    view.addSubview(tableView)
    view.addSubview(versionLabel)
  }
}

// MARK: - Private
private extension SettingViewController {
  func setupLayoutConstraints() {
    tableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
      $0.leading.trailing.equalToSuperview().inset(15)
      $0.height.equalTo(Self.viewHeight * 0.42 + 20)
    }

    versionLabel.snp.makeConstraints {
      $0.top.equalTo(tableView.snp.bottom)
      $0.leading.equalToSuperview().offset(20)
    }
  }

  func bindState() {
    viewModel.$state
      .map { $0.isSuccess }
      .filter { $0 }
      .receiveOnMain()
      .sink(receiveValue: { [weak self] _ in
        self?.coordinator?.resetCoordinator()
        self?.coordinator?.transitionToLogin()
      })
      .store(in: &cancellable)
  }

  func clearAllCache() {
    let cache = KingfisherManager.shared.cache

    cache.clearCache()
    cache.cleanExpiredCache()
  }

  func fetchAppVersionInfo() -> String {
    guard let dictionary = Bundle.main.infoDictionary,
          let version = dictionary["CFBundleShortVersionString"] as? String,
          let build = dictionary["CFBundleVersion"] as? String else {
      return ""
    }

    let versionAndBuildString: String = "\(version).\(build)"
    return versionAndBuildString
  }
}

// MARK: - UITableViewDataSource
extension SettingViewController: UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return Sections.allCases.count
  }

  func tableView(
    _ tableView: UITableView,
    numberOfRowsInSection section: Int
  ) -> Int {
    guard let section = Sections.init(rawValue: section) else {
      return 0
    }

    return section.numberOfRows
  }

  func tableView(
    _ tableView: UITableView,
    cellForRowAt indexPath: IndexPath
  ) -> UITableViewCell {
    guard let section = Sections.init(rawValue: indexPath.section) else {
      return .init()
    }

    let cell: SettingCell = tableView.t_dequeueReusableCell(
      cellType: SettingCell.self,
      indexPath: indexPath
    )
    
    let isLastIndex = section.numberOfRows - 1 == indexPath.row
    if isLastIndex {
      cell.cornerRadius([.bottomLeft, .bottomRight], radius: 15)
    }
    
    cell.configure(title: section.rowTitles[indexPath.row], isLastIndex: isLastIndex)
    return cell
  }

  func tableView(
    _ tableView: UITableView,
    viewForHeaderInSection section: Int
  ) -> UIView? {
    guard let section = Sections.init(rawValue: section) else {
      return nil
    }

    let sectionHeaderView: SettingSectionHeaderView = .init(section: section)
    return sectionHeaderView
  }

  func tableView(
    _ tableView: UITableView,
    didSelectRowAt indexPath: IndexPath
  ) {
    switch indexPath.section {
    case 0:
      switch indexPath.row {
      case 0:
        presentAlert(
          type: .logout,
          leftButtonTapHandler: nil,
          rightButtonTapHandler: { [weak coordinator] in
            coordinator?.resetCoordinator()
            coordinator?.transitionToLogin()
          }
        )
      case 1:
        presentAlert(
          type: .signOut,
          leftButtonTapHandler: nil,
          rightButtonTapHandler: { [weak viewModel] in
            viewModel?.action(.didTapSignOutButton)
          }
        )
      default: return
      }
    case 1:
      switch indexPath.row {
      case 0:
        presentAlert(
          type: .removeImageCache,
          leftButtonTapHandler: nil,
          rightButtonTapHandler: {
            KingfisherManager.shared.cache.clearMemoryCache()
          }
        )
      case 1:
        presentAlert(
          type: .removeImageCache,
          leftButtonTapHandler: nil,
          rightButtonTapHandler: { [weak self] in
            self?.clearAllCache()
          }
        )
      default: return
      }
    default:
      return
    }
  }
}

// MARK: - UITableViewDelegate
extension SettingViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    heightForHeaderInSection section: Int
  ) -> CGFloat {
    return 60
  }
}
