//
//  TidifyTabBar.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2022/08/11.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

import SnapKit

protocol TidifyTabBarDelegate: AnyObject {
  func didSelectTab(_ item: TabBarItem)
}

final class TidifyTabBar: UIView {
  
  // MARK: - Properties
  weak var delegate: TidifyTabBarDelegate?
  
  private let backgroundView: UIView = {
    let view: UIView = .init()
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOpacity = 0.25
    view.layer.shadowOffset = CGSize(w: 0, h: 8)
    view.layer.shadowRadius = 16
    view.layer.cornerRadius = 28
    view.backgroundColor = .white
    return view
  }()
  
  private let stackView: UIStackView = {
    let stackView: UIStackView = .init()
    stackView.distribution = .fillEqually
    return stackView
  }()
  
  private lazy var homeTabButton: UIButton = {
    let button: UIButton = .init()
    button.setImage(UIImage(named: "homeSelectedIcon"), for: .selected)
    button.setImage(UIImage(named: "homeDeselectedIcon"), for: .normal)
    button.addTarget(self, action: #selector(didTapHomeButton), for: .touchUpInside)
    button.isSelected = true
    return button
  }()
  
  private lazy var folderTabButton: UIButton = {
    let button: UIButton = .init()
    button.setImage(UIImage(named: "folderSelectedIcon"), for: .selected)
    button.setImage(UIImage(named: "folderDeselectedIcon"), for: .normal)
    button.addTarget(self, action: #selector(didTapFolderButton), for: .touchUpInside)
    return button
  }()

  private lazy var bookmarkCreationButton: UIButton = {
    let button: UIButton = .init()
    button.setImage(UIImage(named: "folderCreationIcon"), for: .normal)
    button.addTarget(self, action: #selector(didTapBookmarkCreationButton), for: .touchUpInside)
    return button
  }()
  
  // MARK: - Initialize
  init() {
    super.init(frame: .zero)
    
    setupUI()
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
    backgroundView.addSubview(stackView)
    stackView.addArrangedSubview(homeTabButton)
    stackView.addArrangedSubview(folderTabButton)
    stackView.addArrangedSubview(bookmarkCreationButton)
    
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

  @objc func didTapHomeButton() {
    homeTabButton.isSelected = true
    folderTabButton.isSelected = false
    delegate?.didSelectTab(.home)
  }

  @objc func didTapFolderButton() {
    homeTabButton.isSelected = false
    folderTabButton.isSelected = true
    delegate?.didSelectTab(.folder)
  }

  @objc func didTapBookmarkCreationButton() {
    delegate?.didSelectTab(.bookmarkCreation)
  }
}
