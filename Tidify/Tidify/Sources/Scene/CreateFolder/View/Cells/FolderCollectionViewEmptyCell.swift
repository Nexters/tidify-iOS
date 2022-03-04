//
//  FolderCollectionViewEmptyCell.swift
//  Tidify
//
//  Created by 한상진 on 2022/03/04.
//

import UIKit

class FolderCollectionViewEmptyCell: UICollectionViewCell {

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

private extension FolderCollectionViewEmptyCell {
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
