//
//  SearchHistoryHeaderView.swift
//  Tidify
//
//  Created by Ian on 2022/03/13.
//

import UIKit

import RxSwift

final class SearchHistoryHeaderView: UIView {
  private weak var historyListGuideLabel: UILabel!
  private weak var eraseAllButton: UIButton!

  private let disposeBag = DisposeBag()

  init(eraseAllButtonTapObserver: AnyObserver<Void>) {
    super.init(frame: .zero)

    setupViews()
    setupLayoutConstraints()

    eraseAllButton.rx.tap
      .subscribe(onNext: {
        eraseAllButtonTapObserver.onNext(())
      })
      .disposed(by: disposeBag)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}

private extension SearchHistoryHeaderView {
  func setupViews() {
    backgroundColor = .white

    self.historyListGuideLabel = UILabel().then {
      $0.text = R.string.localizable.settingHistoryListGuideTitle()
      $0.font = .t_SB(14)
      $0.textColor = .t_tidiBlue()
      addSubview($0)
    }

    self.eraseAllButton = UIButton().then {
      $0.setTitle(R.string.localizable.settingHistoryEraseAllButtonTitle(), for: .normal)
      $0.setTitleColor(.secondaryLabel, for: .normal)
      $0.titleLabel?.font = .t_SB(14)
      addSubview($0)
    }
  }

  func setupLayoutConstraints() {
    let sidePadding: CGFloat = 20

    historyListGuideLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(sidePadding)
    }

    eraseAllButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(sidePadding)
    }
  }
}
