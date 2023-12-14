//
//  SearchTableViewHeaderView.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/12/15.
//  Copyright © 2023 Tidify. All rights reserved.
//

import UIKit

protocol EraseHistoryButtonDelegate: AnyObject {
  func didTapEraseButton()
}

final class SearchTableViewHeaderView: UIView {

  // MARK: Properties
  weak var delegate: EraseHistoryButtonDelegate?

  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .t_EB(20)
    label.textColor = .black
    label.text = "검색기록"
    return label
  }()

  private lazy var eraseButton: UIButton = {
    let button: UIButton = .init()
    button.setTitleColor(.t_gray(weight: 500), for: .normal)
    button.setTitle("모두 지우기", for: .normal)
    button.titleLabel?.font = .t_B(14)
    button.addTarget(self, action: #selector(didTapEraseButton), for: .touchUpInside)
    return button
  }()

  init() {
    super.init(frame: .zero)

    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension SearchTableViewHeaderView {
  func setupUI() {
    backgroundColor = .white
    addSubview(titleLabel)
    addSubview(eraseButton)

    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }

    eraseButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().inset(20)
      $0.centerY.equalToSuperview()
    }
  }

  @objc func didTapEraseButton() {
    delegate?.didTapEraseButton()
  }
}
