//
//  BottomSheetTableViewCell.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/10.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class BottomSheetTableViewCell: UITableViewCell {

    // MARK: - Constants

    static let superViewToImageViewHorizontalSpacing: CGFloat = 20
    static let imageViewToLabelHorizontalSpacing: CGFloat = 12
    static let cellHeight: CGFloat = 56

    // MARK: - Properties

    private weak var checkStatusImageView: UIImageView!
    private weak var tagLabel: UILabel!

    private var disposeBag = DisposeBag()

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

    override func prepareForReuse() {
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        checkStatusImageView.image = selected ? R.image.bottomSheet_ico_checked() : R.image.bottomSheet_ico_unChecked()
    }

    func setTag(_ tag: String) {
        self.tagLabel.text = tag
    }
}

private extension BottomSheetTableViewCell {
    func setupViews() {
        self.checkStatusImageView = UIImageView().then {
            $0.image = R.image.bottomSheet_ico_unChecked()
            contentView.addSubview($0)
        }

        self.tagLabel = UILabel().then {
            $0.font = .t_SB(16)
            $0.textColor = .black
            contentView.addSubview($0)
        }
    }

    func setupLayoutConstraints() {
        checkStatusImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Self.superViewToImageViewHorizontalSpacing)
            $0.centerY.equalToSuperview()
        }

        tagLabel.snp.makeConstraints {
            $0.leading.equalTo(checkStatusImageView.snp.trailing).offset(Self.imageViewToLabelHorizontalSpacing)
            $0.centerY.equalToSuperview()
        }
    }
}
