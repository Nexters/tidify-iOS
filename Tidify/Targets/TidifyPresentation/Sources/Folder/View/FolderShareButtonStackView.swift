//
//  FolderShareButtonStackView.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2024/01/22.
//  Copyright © 2024 Tidify. All rights reserved.
//

import Combine
import UIKit

import SnapKit

protocol FolderShareButtonDelegate: AnyObject {
  func didTapLeftButton()
  func didTapRightButton()
}

final class FolderShareButtonStackView: UIStackView {

  // MARK: Properties
  private var cancellable: Set<AnyCancellable> = []
  weak var delegate: FolderShareButtonDelegate?

  let leftButton: UIButton = {
    let button: UIButton = .init()
    button.backgroundColor = .t_ashBlue(weight: 100)
    button.setTitleColor(.t_ashBlue(), for: .normal)
    button.titleLabel?.font = .t_B(15)
    button.cornerRadius(radius: 15)
    return button
  }()

  let rightButton: UIButton = {
    let button: UIButton = .init()
    button.backgroundColor = .t_blue()
    button.setTitleColor(.white, for: .normal)
    button.titleLabel?.font = .t_B(15)
    button.cornerRadius(radius: 15)
    return button
  }()

  // MARK: Initializer
  init() {
    super.init(frame: .zero)

    setupViews()
    bindAction()
  }

  required init(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  func setupStackView(viewMode: FolderDetailViewMode) {
    switch viewMode {
    case .ownerFirstEnter:
      rightButton.setTitle("공유하기", for: .normal)
      leftButton.alpha = 0
      rightButton.alpha = 1
    case .owner:
      leftButton.setTitle("공유 중단", for: .normal)
      rightButton.setTitle("공유하기", for: .normal)
      leftButton.alpha = 1
      rightButton.alpha = 1
    case .subscriberFirstEnter:
      rightButton.setTitle("구독하기", for: .normal)
      leftButton.alpha = 0
      rightButton.alpha = 1
    case .subscriber:
      leftButton.setTitle("구독 취소", for: .normal)
      leftButton.alpha = 1
      rightButton.alpha = 0
    }
  }
}

// MARK: - Extension
private extension FolderShareButtonStackView {
  func setupViews() {
    spacing = 100
    distribution = .fillEqually
    backgroundColor = .clear
    addArrangedSubview(leftButton)
    addArrangedSubview(rightButton)
  }

  func bindAction() {
    leftButton.tapPublisher
      .withUnretained(self)
      .sink(receiveValue: { owner, _ in
        owner.delegate?.didTapLeftButton()
      })
      .store(in: &cancellable)

    rightButton.tapPublisher
      .withUnretained(self)
      .sink(receiveValue: { owner, _ in
        owner.delegate?.didTapRightButton()
      })
      .store(in: &cancellable)
  }
}
