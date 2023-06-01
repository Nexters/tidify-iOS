//
//  TidifyTabBar.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import SnapKit
import Then

protocol TidifyTabBarDelegate: AnyObject {
  func didSelectTab(_ item: TabBarItem)
}

final class TidifyTabBar: UIView, View {
  
  // MARK: - Properties
  weak var delegate: TidifyTabBarDelegate?
  
  private let backgroundView: UIView = .init().then {
    $0.layer.shadowColor = UIColor.black.cgColor
    $0.layer.shadowOpacity = 0.25
    $0.layer.shadowOffset = CGSize(w: 0, h: 8)
    $0.layer.shadowRadius = 16
    $0.layer.cornerRadius = 28
    $0.backgroundColor = .white
  }
  
  private let stackView: UIStackView = .init().then {
    $0.distribution = .fillEqually
  }
  
  private let homeTabButton: UIButton = .init().then {
    $0.setImage(UIImage(named: "homeSelectedIcon"), for: .selected)
    $0.setImage(UIImage(named: "homeDeselectedIcon"), for: .normal)
  }
  
  private let searchTabButton: UIButton = .init().then {
    $0.setImage(UIImage(named: "searchSelectedIcon"), for: .selected)
    $0.setImage(UIImage(named: "searchDeselectedIcon"), for: .normal)
  }
  
  private let folderTabButton: UIButton = .init().then {
    $0.setImage(UIImage(named: "folderSelectedIcon"), for: .selected)
    $0.setImage(UIImage(named: "folderDeselectedIcon"), for: .normal)
  }
  
  var disposeBag: DisposeBag = .init()
  
  // MARK: - Initialize
  init() {
    super.init(frame: .zero)
    
    setupUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func bind(reactor: TidifyTabBarReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
}

// MARK: - Methods
private extension TidifyTabBar {
  typealias Action = TidifyTabBarReactor.Action
  
  func setupUI() {
    backgroundColor = .clear
    
    addSubview(backgroundView)
    backgroundView.addSubview(stackView)
    stackView.addArrangedSubview(homeTabButton)
    stackView.addArrangedSubview(searchTabButton)
    stackView.addArrangedSubview(folderTabButton)
    
    backgroundView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(76)
      $0.top.equalToSuperview().inset(22)
      $0.bottom.equalToSuperview().inset(38)
    }
    
    stackView.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(28)
      $0.top.bottom.equalToSuperview()
    }
  }
  
  func updateTabBar(_ selectedItem: TabBarItem) {
    switch selectedItem {
    case .home:
      homeTabButton.isSelected = true
      searchTabButton.isSelected = false
      folderTabButton.isSelected = false
      
    case .search:
      homeTabButton.isSelected = false
      searchTabButton.isSelected = true
      folderTabButton.isSelected = false
      
    case .folder:
      homeTabButton.isSelected = false
      searchTabButton.isSelected = false
      folderTabButton.isSelected = true
    }
  }
  
  func bindAction(reactor: TidifyTabBarReactor) {
    homeTabButton.rx.tap
      .map { Action.selectHomeTab }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    searchTabButton.rx.tap
      .map { Action.selectSearchTab }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
    
    folderTabButton.rx.tap
      .map { Action.selectFolderTab }
      .bind(to: reactor.action )
      .disposed(by: disposeBag)
  }
  
  func bindState(reactor: TidifyTabBarReactor) {
    reactor.state
      .map { $0.selectedTab }
      .bind(onNext: { [weak self] in
        self?.updateTabBar($0)
        self?.delegate?.didSelectTab($0)
      })
      .disposed(by: disposeBag)
  }
}
