//
//  BottomSheetViewController.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/10.
//

import RxCocoa
import RxSwift
import UIKit

enum BottomSheetType {
  case chooseFolder
  case labelColor
}

class BottomSheetViewController: BaseViewController {

  // MARK: - Constants

  static let bottomSheetHeight: CGFloat = UIScreen.main.bounds.height * 0.570
  static let bottomSheetHeaderViewHeight: CGFloat = bottomSheetHeight * 0.216

  // MARK: - Properties

  private weak var dimmedView: UIView!
  private weak var tableView: UITableView!

  private var dataSource: [Any]?
  private var previousIndex: Int!
  private let selectedEventObserver: AnyObserver<Int>
  private let closeButtonTap = PublishSubject<Void>()
  private let disposeBag = DisposeBag()
  private var bottomSheetType: BottomSheetType

  // MARK: - Initialize

  init(_ bottomSheetType: BottomSheetType,
       dataSource: [Any],
       selectedEventObserver: AnyObserver<Int>,
       previousIndex: Int? = -1
  ) {
    self.selectedEventObserver = selectedEventObserver
    self.bottomSheetType = bottomSheetType
    self.previousIndex = previousIndex

    switch bottomSheetType {
    case .chooseFolder:
      self.dataSource = dataSource as? [String] ?? []
    case .labelColor:
      self.dataSource = dataSource as? [UIColor] ?? []
    }

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
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    showBottomSheet()
  }

  // MARK: - Methods

  override func setupViews() {
    view.backgroundColor = .clear

    dimmedView = UIView().then {
      $0.backgroundColor = .black.withAlphaComponent(0)
      view.addSubview($0)
    }

    tableView = UITableView().then {
      $0.layer.cornerRadius = 16
      $0.separatorStyle = .none
      if #available(iOS 15.0, *) {
        $0.sectionHeaderTopPadding = 0
      }
      $0.t_registerCellClass(cellType: BottomSheetFolderTableViewCell.self)
      $0.t_registerCellClass(cellType: BottomSheetLabelColorTableViewCell.self)
      $0.delegate = self
      $0.dataSource = self
      view.addSubview($0)
    }

    Driver.merge(dimmedView.t_addTap().rx.event.asDriver().map { _ in },
                 closeButtonTap.t_asDriverSkipError())
      .drive(onNext: { [weak self] _ in
        self?.hideBottomSheet()
      })
      .disposed(by: disposeBag)
  }

  override func setupLayoutConstraints() {
    dimmedView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    tableView.snp.makeConstraints {
      $0.height.equalTo(Self.bottomSheetHeight)
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(view.height)
    }
  }
}

// MARK: - DataSource

extension BottomSheetViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return dataSource?.count ?? 0
  }

  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell: UITableViewCell

    switch bottomSheetType {
    case .chooseFolder:
      guard let dataSource = dataSource as? [String] else { return UITableViewCell() }

      let folderCell = tableView.t_dequeueReusableCell(
        cellType: BottomSheetFolderTableViewCell.self,
        indexPath: indexPath
      )
      folderCell.setFolder(dataSource[indexPath.row])
      cell = folderCell

    case .labelColor:
      guard let dataSource = dataSource as? [UIColor] else { return UITableViewCell() }

      let labelColorCell = tableView.t_dequeueReusableCell(
        cellType: BottomSheetLabelColorTableViewCell.self,
        indexPath: indexPath
      )
      labelColorCell.setColor(dataSource[indexPath.row])
      cell = labelColorCell
    }

    return cell
  }

  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    selectedEventObserver.onNext(indexPath.row)
    hideBottomSheet()
  }
}

// MARK: - Delegate

extension BottomSheetViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
    let headerView = BottomSheetHeaderView()
    switch bottomSheetType {
    case .chooseFolder:
      headerView.setBottomSheetHeader(R.string.localizable.bottomSheetFolderTitle(),
                                      closeButonTapObserver: closeButtonTap.asObserver())
    case .labelColor:
      headerView.setBottomSheetHeader(R.string.localizable.bottomSheetLabelTitle(),
                                      closeButonTapObserver: closeButtonTap.asObserver())
    }

    return headerView
  }

  func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
    return Self.bottomSheetHeaderViewHeight
  }

  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return BottomSheetFolderTableViewCell.cellHeight
  }

  func tableView(
    _ tableView: UITableView,
    willDisplay cell: UITableViewCell,
    forRowAt indexPath: IndexPath
  ) {
    if previousIndex == indexPath.row {
      cell.setSelected(true, animated: false)
    }
  }
}

private extension BottomSheetViewController {
  func showBottomSheet() {
    UIView.animate(withDuration: 0.5, animations: { [weak self] in
      guard let self = self else { return }
      self.dimmedView.backgroundColor = .black.withAlphaComponent(0.4)

      self.tableView.transform = CGAffineTransform(translationX: 0, y: -Self.bottomSheetHeight)
      self.view.layoutIfNeeded()
    })
  }

  func hideBottomSheet() {
    UIView.animate(withDuration: 0.5, animations: { [weak self] in
      guard let self = self else { return }
      self.dimmedView.backgroundColor = .black.withAlphaComponent(0)

      self.tableView.transform = CGAffineTransform(translationX: 0, y: self.view.height)
      self.view.layoutIfNeeded()
    }, completion: { [weak self] _ in
      if self?.presentingViewController != nil {
        self?.dismiss(animated: false, completion: nil)
      }
    })
  }
}
