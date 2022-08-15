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
  
  override func viewDidLoad() {
    super.viewDidLoad()
  }
  
  init(_ navigationBar: TidifyNavigationBar) {
    self.navigationBar = navigationBar
    super.init(nibName: nil, bundle: nil)
    setupUI()
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
    
    navigationBar.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(Self.viewHeight * 0.182)
    }
    
    containerView.snp.makeConstraints {
      $0.top.equalTo(navigationBar.snp.bottom).offset(16)
      $0.leading.bottom.trailing.equalToSuperview()
    }
  }
}
