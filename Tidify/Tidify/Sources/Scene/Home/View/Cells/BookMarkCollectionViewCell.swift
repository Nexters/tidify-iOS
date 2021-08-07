//
//  BookMarkCollectionViewCell.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/04.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class BookMarkCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    private weak var ogImageView: UIImageView!
    private weak var titleLabel: UILabel!
    private weak var deleteButton: UIButton!
    private weak var editButton: UIButton!
    private weak var rightArrowImageView: UIImageView!
    private weak var tagLabel: UILabel!

    private var bookMark: BookMark?
    private var disposeBag = DisposeBag()

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

    override func prepareForReuse() {
        super.prepareForReuse()

        self.disposeBag = DisposeBag()
    }

    func setBookMark(_ bookMark: BookMark) {
        self.bookMark = bookMark

        self.titleLabel.text = bookMark.title
    }
}

private extension BookMarkCollectionViewCell {
    static let placeHolderImage = R.image.tidify_logo()!
    static let sidePadding: CGFloat = 20
    static let ogImageWidth: CGFloat = 40

    func setupViews() {
        let ogImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.image = Self.placeHolderImage
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.cornerRadius = 4
            contentView.addSubview($0)
        }
        self.ogImageView = ogImageView

        let titleLabel = UILabel().then {
            $0.font = UIFont.t_B(20)
            $0.textColor = .black
            contentView.addSubview($0)
        }
        self.titleLabel = titleLabel

        let deleteButton = UIButton().then {
            $0.setImage(R.image.content_delete_img(), for: .normal)
            $0.backgroundColor = .clear
            contentView.addSubview($0)
        }
        self.deleteButton = deleteButton

        let rightArrowImageView = UIImageView().then {
            $0.image = R.image.arrowRight()
            $0.backgroundColor = .clear
            contentView.addSubview($0)
        }
        self.rightArrowImageView = rightArrowImageView

        let tagLabel = UILabel().then {
            $0.text = R.string.localizable.mainContentTagPlaceHolder()
            $0.font = .t_R(12)
            $0.textColor = .lightGray
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.cornerRadius = 4
            contentView.addSubview($0)
        }
        self.tagLabel = tagLabel
    }

    func setupLayoutConstraints() {
        ogImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Self.sidePadding)
            $0.top.equalToSuperview().offset(40)
            $0.size.equalTo(CGSize(w: Self.ogImageWidth, h: Self.ogImageWidth))
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(ogImageView)
            $0.leading.equalTo(ogImageView.snp.trailing).offset(Self.sidePadding)
            $0.width.equalTo(220)
        }

        rightArrowImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel)
            $0.trailing.equalToSuperview().inset(Self.sidePadding)
        }

        deleteButton.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Self.sidePadding)
            $0.top.equalTo(ogImageView.snp.bottom).offset(24)
        }

        editButton.snp.makeConstraints {
            $0.centerY.equalTo(deleteButton)
            $0.leading.equalTo(deleteButton.snp.trailing).offset(30)
        }
    }
}
