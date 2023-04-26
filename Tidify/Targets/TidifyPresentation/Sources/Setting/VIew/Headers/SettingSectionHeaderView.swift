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
  private let titleLabel: UILabel = .init()

  private let section: SettingReactor.Sections

  init(section: SettingReactor.Sections) {
    self.section = section
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

    if section == .dataManaging {
      cornerRadius([.topLeft, .topRight], radius: 16)
    }

    titleLabel.do {
      $0.text = section.sectionTitle
      $0.font = .t_EB(18)
    }

    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }
  }
}
