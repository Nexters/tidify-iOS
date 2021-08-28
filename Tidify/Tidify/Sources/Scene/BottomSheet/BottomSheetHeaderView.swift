//
//  BottomSheetHeaderView.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/10.
//

import RxCocoa
import RxSwift
import UIKit

class BottomSheetHeaderView: UIView {

    // MARK: - Constants

    static let superViewToTitleHorizontalSpacing: CGFloat = 42
    static let closeToSuperViewHorizontalSpacing: CGFloat = 20

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

        let titleLabel = UILabel()
        titleLabel.font = .t_B(28)
        titleLabel.textColor = .black
        addSubview(titleLabel)
        self.titleLabel = titleLabel

        let closeButton = UIButton()
        closeButton.setImage(R.image.bottomSheet_close(), for: .normal)
        addSubview(closeButton)
        self.closeButton = closeButton
    }

    func setupLayoutConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(Self.superViewToTitleHorizontalSpacing)
            make.centerY.equalToSuperview()
        }

        closeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Self.closeToSuperViewHorizontalSpacing)
        }
    }
}
