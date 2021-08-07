//
//  NoticeEmptyCollectionViewCell.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/07.
//

import SnapKit
import Then
import UIKit

class NoticeEmptyCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    private weak var titleLabel: UILabel!

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupLayoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NoticeEmptyCollectionViewCell {
    func setupViews() {
        let titleLabel = UILabel().then {
            $0.text = R.string.localizable.mainNoticeEmptyTitle()
            $0.textColor = .lightGray
            $0.font = .t_R(16)
            contentView.addSubview($0)
        }
        self.titleLabel = titleLabel
    }

    func setupLayoutConstraints() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
