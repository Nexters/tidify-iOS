//
//  BookMarkTableViewCell.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class BookMarkTableViewCell: UITableViewCell {
    private weak var containerView: UIView!
    private weak var thumbnailImageView: UIImageView!
    private weak var titleLabel: UILabel!
    private weak var descriptionLabel: UILabel!

    private var bookMark: BookMark?
    private var disposeBag = DisposeBag()

    static let cellHeight: CGFloat = 80

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
        super.prepareForReuse()

        disposeBag = DisposeBag()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setBookMark(_ bookMark: BookMark) {
        self.bookMark = bookMark
        titleLabel.text = bookMark.title
        descriptionLabel.text = "Apple SD Gothic Neo"
        // 이미지 처리 필요
    }
}

private extension BookMarkTableViewCell {
    static let topBottomPadding: CGFloat = 12
    static let superViewToThumbnailImageHorizontalSpacing: CGFloat = 12
    static let thumbnailImageWidth: CGFloat = 56
    static let thumbnailImageToLabelHorizontalSpacing: CGFloat = 16
    static let superViewToLabelHorizontalSpacingWhenNonImage: CGFloat = 20

    func setupViews() {
        contentView.backgroundColor = .white

        let containerView = UIView().then {
            $0.backgroundColor = .white
            $0.layer.cornerRadius = 10
            $0.frame = CGRect(x: 0, y: 0, width: 335, height: 104)
            contentView.addSubview($0)
        }
        self.containerView = containerView

        let thumbnailImageView = UIImageView().then {
            $0.layer.cornerRadius = Self.thumbnailImageWidth / 4
            $0.image = R.image.opengraph_img()
            $0.contentMode = .scaleAspectFill
            containerView.addSubview($0)
        }
        self.thumbnailImageView = thumbnailImageView

        let titleLabel = UILabel().then {
            $0.numberOfLines = 1
            $0.font = .t_B(20)
            containerView.addSubview($0)
        }
        self.titleLabel = titleLabel

        let descriptionLabel = UILabel().then {
            $0.numberOfLines = 1
            $0.font = .t_R(12)
            containerView.addSubview($0)
        }
        self.descriptionLabel = descriptionLabel
    }

    func setupLayoutConstraints() {
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.bottom.equalToSuperview()
            $0.leading.equalToSuperview().offset(20)
            $0.trailing.equalToSuperview().offset(-20)
        }

        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Self.superViewToThumbnailImageHorizontalSpacing)
            $0.size.equalTo(CGSize(w: Self.thumbnailImageWidth, h: Self.thumbnailImageWidth))
            $0.centerY.equalToSuperview()
        }

        titleLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Self.superViewToThumbnailImageHorizontalSpacing + Self.thumbnailImageWidth + Self.thumbnailImageToLabelHorizontalSpacing)
            $0.top.equalTo(thumbnailImageView).offset(5)
            $0.trailing.equalToSuperview().offset(-20)
        }

        descriptionLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Self.superViewToThumbnailImageHorizontalSpacing + Self.thumbnailImageWidth + Self.thumbnailImageToLabelHorizontalSpacing)
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.trailing.equalTo(titleLabel)
        }

        // openGraph 이미지가 없을 경우를 대응한 제약사항 업데이트
//        titleLabel.snp.updateConstraints {
//            $0.leading.equalToSuperview().offset(Self.superViewToLabelHorizontalSpacingWhenNonImage)
//        }
//
//        descriptionLabel.snp.updateConstraints {
//            $0.leading.equalToSuperview().offset(Self.superViewToLabelHorizontalSpacingWhenNonImage)
//        }
    }
}
