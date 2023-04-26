//
//  BottomSheetViewController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/10/21.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

import RxCocoa
import RxSwift
import SnapKit
import Then

enum TabType {
  case bookmark
  case folder
}

final class BottomSheetViewController: UIViewController {
  private let containerView: UIView = .init()
  private let sheetView: UIView = .init()
  private let titleLabel: UILabel = .init()
  private let closeButton: UIButton = .init()
  private let tableView: UITableView = .init()
  private let tapGesture: UITapGestureRecognizer = .init()
  
  private let tabType: TabType
  private let dataSource: [Any]
  private let selectedIndexRelay: BehaviorRelay<Int>
  
  private var containerViewDidTap: Driver<Void> {
    guard let containerViewGestures = containerView.gestureRecognizers,
          let gesture = containerViewGestures.first
    else { return .empty() }
    
    return gesture.rx.event.map { _ in }.asDriver(onErrorDriveWith: .empty())
  }
  
  private var closeButtonDidTap: Driver<Void> {
    closeButton.rx.tap.asDriver()
  }
  
  private let disposeBag = DisposeBag()
  
  init(
    _ tabType: TabType,
    dataSource: [Any],
    selectedIndexRelay: BehaviorRelay<Int>
  ) {
    self.tabType = tabType
    self.selectedIndexRelay = selectedIndexRelay
    
    switch tabType {
    case .bookmark:
      self.dataSource = dataSource as? [String] ?? []
    case .folder:
      self.dataSource = dataSource as? [UIColor] ?? []
    }
    
    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    setupUI()
    setupTableView()
    bind()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    showBottomSheet()
  }
}

private extension BottomSheetViewController {
  var cellDisplayBinder: Binder<WillDisplayCellEvent> {
    .init(self) { owner, event in
      guard owner.selectedIndexRelay.value == event.indexPath.row else { return }
      event.cell.setSelected(true, animated: false)
    }
  }
  
  var cellSelectedBinder: Binder<IndexPath> {
    .init(self) { owner, indexPath in
      var deselectCell: UITableViewCell = .init()
      let deselectIndexPath: IndexPath = .init(row: owner.selectedIndexRelay.value, section: 0)
      
      switch owner.tabType {
      case .bookmark:
        deselectCell = owner.tableView.cellForRow(at: deselectIndexPath)
        as? BottomSheetBookmarkTableViewCell ?? UITableViewCell()
      case .folder:
        deselectCell = owner.tableView.cellForRow(at: deselectIndexPath)
        as? BottomSheetFolderTableViewCell ?? UITableViewCell()
      }
      deselectCell.setSelected(false, animated: true)
      
      owner.selectedIndexRelay.accept(indexPath.row)
      owner.hideBottomSheet()
    }
  }
  
  func setupUI() {
    view.backgroundColor = .clear
    
    containerView.do {
      $0.backgroundColor = .black.withAlphaComponent(0)
      $0.addGestureRecognizer(tapGesture)
      view.addSubview($0)
    }
    
    sheetView.do {
      $0.backgroundColor = .white
      $0.layer.cornerRadius = 16
      view.addSubview($0)
    }
    
    titleLabel.do {
      $0.text = tabType == .folder ? "라벨 달기" : "폴더 선택"
      $0.font = .t_EB(28)
      $0.textColor = .black
      sheetView.addSubview($0)
    }
    
    closeButton.do {
      $0.setImage(UIImage(named: "closeIcon"), for: .normal)
      sheetView.addSubview($0)
    }
    
    tableView.do {
      $0.separatorStyle = .none
      $0.showsVerticalScrollIndicator = false
      $0.t_registerCellClass(cellType: BottomSheetFolderTableViewCell.self)
      $0.t_registerCellClass(cellType: BottomSheetBookmarkTableViewCell.self)
      if #available(iOS 15.0, *) { $0.sectionHeaderTopPadding = 0 }
      sheetView.addSubview($0)
    }
    
    containerView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
    
    sheetView.snp.makeConstraints {
      $0.height.equalTo(UIScreen.main.bounds.height * 0.57)
      $0.leading.trailing.equalToSuperview()
      $0.top.equalTo(view.frame.size.height)
    }
    
    titleLabel.snp.makeConstraints {
      $0.top.equalToSuperview().offset(38)
      $0.leading.equalToSuperview().offset(32)
    }
    
    closeButton.snp.makeConstraints {
      $0.size.equalTo(40)
      $0.top.equalToSuperview().offset(28)
      $0.trailing.equalToSuperview().inset(20)
    }
    
    tableView.snp.makeConstraints {
      $0.top.equalTo(titleLabel.snp.bottom).offset(38)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview()
    }
  }
  
  func bind() {
    Driver.merge(containerViewDidTap, closeButtonDidTap)
      .drive(onNext: { [weak self] _ in
        self?.hideBottomSheet()
      })
      .disposed(by: disposeBag)
  }
  
  func setupTableView() {
    let observableData = Observable.just(dataSource)
    
    switch tabType {
    case .bookmark:
      observableData.bind(to: tableView.rx.items(
        cellIdentifier: "BottomSheetBookmarkTableViewCell",
        cellType: BottomSheetBookmarkTableViewCell.self)) { _, name, cell in
          guard let name = name as? String else { return }
          cell.configure(folderName: name)
        }
        .disposed(by: disposeBag)
    case .folder:
      observableData.bind(to: tableView.rx.items(
        cellIdentifier: "BottomSheetFolderTableViewCell",
        cellType: BottomSheetFolderTableViewCell.self)) { _, color, cell in
          guard let color = color as? UIColor else { return }
          cell.configure(color: color)
        }
        .disposed(by: disposeBag)
    }
    
    tableView.rx.willDisplayCell
      .bind(to: cellDisplayBinder)
      .disposed(by: disposeBag)
    
    tableView.rx.itemSelected
      .bind(to: cellSelectedBinder)
      .disposed(by: disposeBag)
  }
  
  func showBottomSheet() {
    UIView.animate(withDuration: 0.3, animations: {
      self.containerView.backgroundColor = .black.withAlphaComponent(0.4)
      self.sheetView.transform = CGAffineTransform(
        translationX: 0,
        y: -UIScreen.main.bounds.height * 0.57
      )
      self.view.layoutIfNeeded()
    })
  }
  
  func hideBottomSheet() {
    UIView.animate(withDuration: 0.3, animations: {
      self.containerView.backgroundColor = .black.withAlphaComponent(0)
      self.sheetView.transform = CGAffineTransform(translationX: 0, y: self.view.frame.size.height)
      self.view.layoutIfNeeded()
    }, completion: { _ in
      self.dismiss(animated: false)
    })
  }
}
