//
//  FolderViewController.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

final class FolderViewController: UIViewController {
  weak var coordinator: FolderCoordinator?
  
  private let navigationBar: TidifyNavigationBar
  
  private let containerView: UIView = .init().then {
    $0.cornerRadius([.topLeft, .topRight], radius: 16)
    $0.backgroundColor = .white
  }
  
  private lazy var emptyLabel: UILabel = .init().then {
    $0.textColor = .t_indigo02()
    $0.font = .t_EB(16)
  }
  
  private lazy var folderTableView: UITableView = .init().then {
    $0.t_registerCellClass(cellType: FolderTableViewCell.self)
    $0.showsVerticalScrollIndicator = false
  }
  
  private lazy var cellEditButton: UIButton = .init().then {
    $0.setTitle("편집", for: .normal)
    $0.setTitleColor(.t_indigo00(), for: .normal)
    $0.titleLabel?.font = .t_SB(14)
    $0.layer.borderWidth = 1
    $0.layer.borderColor = UIColor(hex: "3C3C43")?.withAlphaComponent(0.08).cgColor
  }
  
  private lazy var cellDeleteButton: UIButton = .init().then {
    $0.setTitle("삭제", for: .normal)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.font = .t_SB(14)
    $0.backgroundColor = .red
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupUI()
  }
  
  init(_ navigationBar: TidifyNavigationBar) {
    self.navigationBar = navigationBar
    super.init(nibName: nil, bundle: nil)
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension FolderViewController {
  func setupUI() {
    view.backgroundColor = .init(235, 235, 240)
    
    view.addSubview(navigationBar)
    view.addSubview(containerView)
    containerView.addSubview(folderTableView)
    
    navigationBar.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(Self.viewHeight * 0.182)
    }
    
    containerView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom).offset(16)
      $0.leading.bottom.trailing.equalToSuperview()
    }
    
    folderTableView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview().offset(20)
      $0.bottom.equalToSuperview().inset(Self.viewHeight * 0.142)
    }
  }
}
