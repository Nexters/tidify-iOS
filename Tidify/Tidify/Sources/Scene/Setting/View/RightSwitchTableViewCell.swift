//
//  RightSwitchTableViewCell.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/27.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class RightSwitchTableViewCell: UITableViewCell {

    // MARK: - Properties

    private weak var switchView: UISwitch!

    private var disposeBag = DisposeBag()

    var isOn: Bool = false {
        didSet {
            switchView.isOn = isOn
        }
    }

    // MARK: - Initialize

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupLayoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    func setRightSwitchCell(switchTapObserver: AnyObserver<Void>) {
        switchView.t_addTap().rx.event.asDriver()
            .drive(onNext: { _ in
                switchTapObserver.onNext(())
            })
            .disposed(by: disposeBag)
    }

    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }

    private func setupViews() {
        contentView.isUserInteractionEnabled = true

        let switchView = UISwitch().then {
            $0.onTintColor = .t_tidiBlue()
            $0.isEnabled = true
            contentView.addSubview($0)
        }
        self.switchView = switchView
    }

    private func setupLayoutConstraints() {
        switchView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(Self.SidePadding)
        }
    }

    // MARK: - Constants

    static let SidePadding: CGFloat = 15
}
