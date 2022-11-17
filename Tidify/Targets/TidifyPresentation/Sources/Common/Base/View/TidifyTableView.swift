//
//  TidifyTableView.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/11/13.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

import RxSwift

final class TidifyTableView: UITableView {
  private let swipedCellIndexPathSubject: PublishSubject<IndexPath> = .init()
  
  private let tabType: TabType
  
  private var cellSwipeBinder: Binder<IndexPath> {
    .init(self, binding: { owner, indexPath in
      guard let cell = owner.cellForRow(at: indexPath) else { return }
      cell.contentView.layer.cornerRadius = 0
      
      let contentViewHeight = cell.contentView.frame.height
      
      owner.subviews.forEach {
        if NSStringFromClass(type(of: $0)) == "_UITableViewCellSwipeContainerView" {
          $0.subviews.forEach {
            if NSStringFromClass(type(of: $0)) == "UISwipeActionPullView" {
              $0.frame.size.height = contentViewHeight
              $0.cornerRadius([.topRight, .bottomRight], radius: 8)
              
              guard let editButton = $0.subviews.first as? UIButton,
                    let deleteButton = $0.subviews.last as? UIButton
              else { return }
              
              editButton.setTitleColor(.t_indigo00(), for: .normal)
              editButton.layer.borderWidth = 1
              editButton.layer.borderColor = UIColor.t_borderColor().cgColor
              deleteButton.setTitleColor(.white, for: .normal)
            }
          }
        }
      }
    })
  }
  
  private var editAction: ((Observable<IndexPath>) -> Void)?
  private var deleteAction: ((Observable<IndexPath>) -> Void)?
  
  private let disposeBag: DisposeBag = .init()
  
  init(tabType: TabType) {
    self.tabType = tabType
    super.init(frame: .zero, style: .plain)
    setupUI()
    setupBind()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func setupEditAction(_ editAction: @escaping (Observable<IndexPath>) -> Void) {
    self.editAction = editAction
  }
  
  func setupDeleteAction(_ deleteAction: @escaping (Observable<IndexPath>) -> Void) {
    self.deleteAction = deleteAction
  }
}

private extension TidifyTableView {
  func setupUI() {
    t_registerCellClass(cellType: tabType == .folder ? FolderTableViewCell.self : BookmarkCell.self)
    separatorStyle = .none
    rowHeight = (UIScreen.main.bounds.height * 0.0689) + 24
    showsVerticalScrollIndicator = false
  }
  
  func setupBind() {
    delegate = self
    
    swipedCellIndexPathSubject
      .delay(.milliseconds(5), scheduler: MainScheduler.instance)
      .bind(to: cellSwipeBinder)
      .disposed(by: disposeBag)
  }
}

extension TidifyTableView: UITableViewDelegate {
  func tableView(
    _ tableView: UITableView,
    trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath
  ) -> UISwipeActionsConfiguration? {
    defer { swipedCellIndexPathSubject.onNext(indexPath) }
    
    let editAction: UIContextualAction = .init(
      style: .normal,
      title: "편집",
      handler: { _, _, completion in
        guard let action = self.editAction else { return }
        action(Observable.just(indexPath))
        completion(true)
      }).then {
        $0.backgroundColor = .white
      }
    
    let deleteAction: UIContextualAction = .init(
      style: .destructive,
      title: "삭제",
      handler: { _, _, completion in
        guard let action = self.deleteAction else { return }
        action(Observable.just(indexPath))
        completion(true)
      }).then {
        $0.backgroundColor = .red
      }

    return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
  }
  
  func tableView(_ tableView: UITableView, didEndEditingRowAt indexPath: IndexPath?) {
    guard let indexPath = indexPath,
          let cell = cellForRow(at: indexPath)
    else { return }
    
    cell.contentView.layer.cornerRadius = 8
  }
}
