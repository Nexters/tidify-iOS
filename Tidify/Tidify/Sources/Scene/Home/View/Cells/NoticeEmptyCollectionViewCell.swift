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

    func setNoticeTitle(_ title: String) {
        self.titleLabel.text = title
    }
}

private extension NoticeEmptyCollectionViewCell {
    func setupViews() {
        contentView.backgroundColor = .white

        let titleLabel = UILabel().then {
            $0.textColor = .t_indigo2()
            $0.font = .t_B(16)
            $0.textAlignment = .center
            contentView.addSubview($0)
        }
        self.titleLabel = titleLabel
    }

    func setupLayoutConstraints() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(28)
            $0.leading.trailing.equalToSuperview()
        }
    }
}
