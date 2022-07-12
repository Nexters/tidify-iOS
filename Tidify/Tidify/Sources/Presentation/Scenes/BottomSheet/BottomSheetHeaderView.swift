//
//  BottomSheetHeaderView.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/10.
//

import RxCocoa
import RxSwift
import UIKit

final class BottomSheetHeaderView: UIView {

  // MARK: - Constants

  static let superViewToTitleHorizontalSpacing: CGFloat = 32
  static let closeToSuperViewHorizontalSpacing: CGFloat = 31

  // MARK: - Properties

  private weak var titleLabel: UILabel!
  private weak var closeButton: UIButton!

  private let disposeBag = DisposeBag()

  // MARK: - Initialize

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
    setupLayoutConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Methods

  func setBottomSheetHeader(_ title: String, closeButonTapObserver: AnyObserver<Void>) {
    self.titleLabel.text = title

    closeButton.rx.tap.asDriver()
      .drive(onNext: { _ in
        closeButonTapObserver.onNext(())
      })
      .disposed(by: disposeBag)
  }
}

private extension BottomSheetHeaderView {
  func setupViews() {
    self.backgroundColor = .white

    titleLabel = UILabel().then {
      $0.font = .t_B(28)
      $0.textColor = .black
      addSubview($0)
    }

    closeButton = UIButton().then {
      $0.setImage(R.image.bottomSheet_close(), for: .normal)
      addSubview($0)
    }
  }

  func setupLayoutConstraints() {
    titleLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(Self.superViewToTitleHorizontalSpacing)
      $0.centerY.equalToSuperview()
    }

    closeButton.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.trailing.equalToSuperview().inset(Self.closeToSuperViewHorizontalSpacing)
    }
  }
}
