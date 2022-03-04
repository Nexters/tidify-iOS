//
//  BookMarkTableViewCell.swift
//  Tidify
//
//  Created by Ian on 2022/03/03.
//

import UIKit

enum BookMarkCellSwipeOption {
    case edit(_ bookMark: BookMark)
    case delete(_ bookMark: BookMark)
}

final class BookMarkTableViewCell: UITableViewCell {

    // MARK: - Properties
    private weak var iconImageView: UIImageView!
    private weak var titleLabel: UILabel!

    // MARK: - Initializer
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupLayoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        self.iconImageView.image = nil
    }

    // MARK: - Methods
    func configure(_ bookMark: BookMark) {
        // 모델 재정의 후 수정
//        self.iconImageView.image
        self.titleLabel.text = bookMark.title
    }
}

private extension BookMarkTableViewCell {
    func setupViews() {
        self.iconImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.image = R.image.tidify_logo()!
            $0.backgroundColor = .clear
            contentView.addSubview($0)
        }

        self.titleLabel = UILabel().then {
            $0.font = .t_EB(16)
            $0.textColor = .black
            contentView.addSubview($0)
        }
    }

    func setupLayoutConstraints() {
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(10)
            $0.top.equalToSuperview().offset(8)
            $0.bottom.equalToSuperview().offset(8)
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView.snp.bottom).offset(16)
            $0.centerY.equalTo(iconImageView)
        }
    }
}
