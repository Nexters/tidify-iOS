//
//  BookMarkTableViewCell.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import RxCocoa
import RxSwift
import UIKit
import SnapKit
import Then

class BookMarkTableViewCell: UITableViewCell {
    private weak var thumbnailImageView: UIImageView!
    private weak var titleLabel: UILabel!

    private var bookMark: BookMark?
    private var disposeBag = DisposeBag()

    static let cellHeight: CGFloat = 72

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupLayoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func prepareForReuse() {
        disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setBookMark(_ bookMark: BookMark) {
        self.bookMark = bookMark
        titleLabel.text = bookMark.title
        // 이미지 처리 필요
    }
}

private extension BookMarkTableViewCell {
    static let topBottomPadding: CGFloat = 7
    static let sidePadding: CGFloat = 12
    static let thumbnailImageWidth: CGFloat = 48

    func setupViews() {
        contentView.backgroundColor = .white

        let thumbnailImageView = UIImageView().then {
            $0.layer.cornerRadius = Self.thumbnailImageWidth / 4
            $0.backgroundColor = .systemGray
            $0.contentMode = .scaleAspectFill
            contentView.addSubview($0)
        }
        self.thumbnailImageView = thumbnailImageView

        let titleLabel = UILabel().then {
            $0.numberOfLines = 0
            contentView.addSubview($0)
        }
        self.titleLabel = titleLabel
    }

    func setupLayoutConstraints() {
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Self.sidePadding)
            $0.size.equalTo(CGSize(w: Self.thumbnailImageWidth, h: Self.thumbnailImageWidth))
            $0.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(Self.sidePadding)
            $0.top.bottom.equalTo(thumbnailImageView)
            $0.trailing.equalToSuperview().offset(-20)
        }
    }
}
