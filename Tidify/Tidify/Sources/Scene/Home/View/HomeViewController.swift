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

  private weak var tableView: UITableView!
  private let profileButton: UIButton!
  private let createBookMarkButton: UIButton!

  private let viewModel: HomeViewModel!
  private let didTapCellSubject = PublishSubject<BookMark>()
  private let addListItemSubject = PublishSubject<URL>()

  private let didSwipeBookMarkCellSubject = PublishSubject<BookMarkCellSwipeOption>()

  private lazy var navigationBar = TidifyNavigationBar(.rounded,
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

  // MARK: - Override
  override func viewDidLoad() {
    super.viewDidLoad()

    let input = HomeViewModel.Input(
      didSwipeBookMarkCell: didSwipeBookMarkCellSubject.t_asDriverSkipError(),
      didTapCell: didTapCellSubject.t_asDriverSkipError()
    )

    let output = viewModel.transform(input)

    output.didReceiveBookMarks
      .drive(onNext: { [weak self] _ in
        self?.tableView.reloadData()
      })
      .disposed(by: disposeBag)

    output.didTapCell
      .drive()
      .disposed(by: disposeBag)
  }

  override func setupViews() {
    setupNavigationBar()

    self.tableView = UITableView().then {
      $0.delegate = self
      $0.dataSource = self
      $0.backgroundColor = .white
      $0.t_registerCellClass(cellType: BookMarkTableViewCell.self)
      $0.t_cornerRadius([.topLeft, .topRight], radius: 16)
      view.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    tableView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom).offset(15)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
}

// MARK: - TableViewDataSource
extension HomeViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView,
                 numberOfRowsInSection section: Int) -> Int {
    return viewModel.bookMarkList.count
  }

  func tableView(_ tableView: UITableView,
                 cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    guard let bookMark = viewModel.bookMarkList[safe: indexPath.row] else {
      return UITableViewCell()
    }

    let cell = tableView.t_dequeueReusableCell(cellType: BookMarkTableViewCell.self,
                                               indexPath: indexPath)

    cell.configure(bookMark)
    return cell
  }
}

// MARK: - TableViewDelegate
extension HomeViewController: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
  ) -> UISwipeActionsConfiguration? {
    guard let bookMark = viewModel.bookMarkList[safe: indexPath.row] else {
      return .none
    }

    let editAction = UIContextualAction(style: .normal,
                                        title: R.string.localizable.mainCellEditTitle(),
                                        handler: { [weak self] _, _, _ in
      self?.showAlertForDeleteBookMark(bookMark: bookMark)
    })

    let deleteAction = UIContextualAction(style: .destructive,
                                          title: R.string.localizable.mainCellDeleteTitle(),
                                          handler: { [weak self] _, _, _ in
      self?.didSwipeBookMarkCellSubject.onNext(.delete(bookMark))
    })

    return .init(actions: [editAction, deleteAction])
  }

  func tableView(_ tableView: UITableView,
                 didSelectRowAt indexPath: IndexPath) {
    guard let bookMark = viewModel.bookMarkList[safe: indexPath.row] else { return }

    didTapCellSubject.onNext(bookMark)
  }
}

// MARK: - Private Extension
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
      $0.top.equalTo(view.top)
      $0.leading.trailing.equalToSuperview()
    }
  }

  func showAlertForDeleteBookMark(bookMark: BookMark) {
    let nextAction: Notifier.AlertButtonAction = (
      R.string.localizable.mainNotifierBookMarkButtonNext(), nil)

    let deleteAction: Notifier.AlertButtonAction = (
      R.string.localizable.mainNotifierBookMarkButtonDelete(),
      { [weak self] in self?.didSwipeBookMarkCellSubject.onNext(.delete(bookMark)) }
    )

    Notifier.alert(on: self,
                   title: R.string.localizable.mainNotifierBookMarkDeleteTitle(),
                   message: R.string.localizable.mainNotifierBookMarkDeleteDesc(),
                   buttons: [nextAction, deleteAction])
  }
}
