//
//  SettingCell.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/10/22.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

final class SettingCell: UITableViewCell {

  // MARK: - Properties
  private let titleLabel: UILabel = .init()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods
  func configure(title: String) {
    if title == "앱 버전" {
      DispatchQueue.main.async { [weak self] in
        self?.titleLabel.font = .systemFont(ofSize: 12)
        self?.titleLabel.textColor = .lightGray
        self?.titleLabel.text = title + " " + (self?.fetchAppVersionInfo() ?? "")
      }
    }

    titleLabel.text = title
  }
}

// MARK: - Private
private extension SettingCell {
  func setupUI() {
    selectionStyle = .none
    backgroundColor = .white

    contentView.addSubview(titleLabel)

    titleLabel.do {
      $0.font = .systemFont(ofSize: 16)
    }

    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }
  }

  func fetchAppVersionInfo() -> String {
    guard let dictionary = Bundle.main.infoDictionary,
          let version = dictionary["CFBundleShortVersionString"] as? String,
          let build = dictionary["CFBundleVersion"] as? String else { return "" }

    let versionAndBuildString: String = "\(version).\(build)"
    return versionAndBuildString
  }
}
