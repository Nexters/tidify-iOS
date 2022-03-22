//
//  AccountSectionHeaderView.swift
//  Tidify
//
//  Created by Ian on 2022/03/13.
//

import UIKit

final class AccountSectionHeaderView: UIView {

  // MARK: - Properties
  private weak var titleLabel: UILabel!

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
    setupLayoutConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension AccountSectionHeaderView {
  func setupViews() {
    backgroundColor = .white

    self.titleLabel = UILabel().then {
      $0.text = R.string.localizable.settingNavigationTitle()
      $0.font = .t_EB(32)
      addSubview($0)
    }
  }

  func setupLayoutConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.centerY.equalToSuperview()
    }
  }
}
