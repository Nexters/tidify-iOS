//
//  SettingSectionHeaderView.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/10/22.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

final class SettingSectionHeaderView: UIView {

  // MARK: - Properties
  private let titleLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .t_EB(20)
    label.textColor = .black
    return label
  }()

  init(section: SettingViewController.Sections) {
    titleLabel.text = section.sectionTitle
    super.init(frame: .zero)

    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension SettingSectionHeaderView {
  func setupUI() {
    backgroundColor = .white
    addSubview(titleLabel)

    cornerRadius([.topLeft, .topRight], radius: 15)

    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }
  }
}
