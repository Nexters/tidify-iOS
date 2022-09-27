//
//  SearchHeaderView.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/09/27.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

import RxSwift

final class SearchHeaderView: UIView {

  // MARK: - Properties
  private let historyListGuideLabel: UILabel = .init()
  private let eraseAllButton: UIButton = .init()

  private let disposeBag: DisposeBag = .init()

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

extension SearchHeaderView {
  var eraseAllButtonTapObservable: Observable<Void> {
    eraseAllButton.rx.tap.asObservable()
  }
}

// MARK: - Private
private extension SearchHeaderView {
  func setupUI() {
    addSubview(historyListGuideLabel)
    addSubview(eraseAllButton)

    backgroundColor = .white
    historyListGuideLabel.do {
      $0.text = "최근 검색목록"
      $0.font = .t_SB(14)
      $0.textColor = .t_tidiBlue00()
    }

    eraseAllButton.do {
      $0.setTitle("모두 지우기", for: .normal)
      $0.setTitleColor(.secondaryLabel, for: .normal)
      $0.titleLabel?.font = .t_SB(14)
    }

    historyListGuideLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
    }

    eraseAllButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().offset(-20)
    }
  }
}
