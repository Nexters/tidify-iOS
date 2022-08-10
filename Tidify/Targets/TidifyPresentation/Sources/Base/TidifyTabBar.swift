//
//  TidifyTabBar.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

protocol TidifyTabBarDelegate: AnyObject {
  func didSelectTab(_ item: TabBarItem)
}

final class TidifyTabBar: UIView {
  
  // MARK: - Properties
  weak var delegate: TidifyTabBarDelegate?
  
  private let blurEffectView = UIVisualEffectView().then {
    $0.effect = UIBlurEffect(style: .regular)
    $0.frame = $0.bounds
    $0.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    $0.layer.cornerRadius = 28
    $0.clipsToBounds = true
  }
  
  private let backgroundView = UIView().then {
    $0.layer.shadowColor = UIColor.black.cgColor
    $0.layer.shadowOpacity = 0.25
    $0.layer.shadowOffset = CGSize(w: 0, h: 8)
    $0.layer.shadowRadius = 16
    $0.backgroundColor = UIAccessibility.isReduceTransparencyEnabled ? .gray : .clear
  }
  
  private let stackView = UIStackView().then {
    $0.distribution = .fillEqually
  }
  
  private let homeTabButton = UIButton().then {
    $0.setImage(UIImage(named: "homeSelectedIcon"), for: .selected)
    $0.setImage(UIImage(named: "homeDeselectedIcon"), for: .normal)
  }
  
  private let searchTabButton = UIButton().then {
    $0.setImage(UIImage(named: "searchSelectedIcon"), for: .selected)
    $0.setImage(UIImage(named: "searchDeselectedIcon"), for: .normal)
  }
  
  private let folderTabButton = UIButton().then {
    $0.setImage(UIImage(named: "folderSelectedIcon"), for: .selected)
    $0.setImage(UIImage(named: "folderDeselectedIcon"), for: .normal)
  }
  
  private lazy var disposeBag = DisposeBag()
  
  // MARK: - Initialize
  init() {
    super.init(frame: .zero)
    
    setupUI()
    binding()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

// MARK: - Methods
private extension TidifyTabBar {
  func setupUI() {
    backgroundColor = .clear
    
    addSubview(backgroundView)
    backgroundView.addSubview(blurEffectView)
    backgroundView.addSubview(stackView)
    stackView.addArrangedSubview(homeTabButton)
    stackView.addArrangedSubview(searchTabButton)
    stackView.addArrangedSubview(folderTabButton)
    
    backgroundView.snp.makeConstraints {
      $0.edges.equalToSuperview()
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
  
  func binding() {
    let didHomeTap = homeTabButton.rx.tap.asDriver()
      .do(onNext: { [weak self] _ in
        self?.delegate?.didSelectTab(.home)
      })
      .map { TabBarItem.home }
    
    let didSearchTap = searchTabButton.rx.tap.asDriver()
      .do(onNext: { [weak self] _ in
        self?.delegate?.didSelectTab(.search)
      })
      .map { TabBarItem.search }
    
    let didFolderTap = folderTabButton.rx.tap.asDriver()
      .do(onNext: { [weak self] _ in
        self?.delegate?.didSelectTab(.folder)
      })
      .map { TabBarItem.folder }
    
    Driver.merge(didHomeTap, didSearchTap, didFolderTap).startWith(.home)
      .drive(onNext: { [weak self] tab in
        self?.updateTabBar(tab)
      })
      .disposed(by: disposeBag)
  }
}
