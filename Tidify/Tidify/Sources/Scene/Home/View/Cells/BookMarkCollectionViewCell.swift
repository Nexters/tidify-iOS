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

    // MARK: - Constants

    static let cellHeight: CGFloat = 128

    // MARK: - Properties

    private weak var iconImageView: UIImageView!
    private weak var titleLabel: UILabel!
    private weak var tagLabel: UILabel!
    private weak var editButton: UIButton!

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

        self.iconImageView.image = nil
        self.disposeBag = DisposeBag()
    }

    func setBookMark(_ bookMark: BookMark) {
        self.bookMark = bookMark

        self.titleLabel.text = bookMark.title
        self.tagLabel.text = bookMark.tag
    }
}

private extension BookMarkCollectionViewCell {
    static let placeHolderImage = R.image.tidify_logo()!
    static let sidePadding: CGFloat = 20
    static let iconImageWidth: CGFloat = 52

    func setupViews() {
        self.iconImageView = UIImageView().then {
            $0.contentMode = .scaleAspectFill
            $0.image = Self.placeHolderImage
            $0.backgroundColor = .clear
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.cornerRadius = 4
            contentView.addSubview($0)
        }

        self.titleLabel = UILabel().then {
            $0.font = .t_B(20)
            $0.textColor = .black
            contentView.addSubview($0)
        }

        self.tagLabel = UILabel().then {
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.lightGray.cgColor
            $0.layer.cornerRadius = 4
            $0.text = "contained tag name"
            $0.font = .t_R(12)
            $0.backgroundColor = .clear
            contentView.addSubview($0)
        }

        self.editButton = UIButton().then {
            $0.setImage(R.image.home_icon_cell_edit(), for: .normal)
            $0.backgroundColor = .clear
            contentView.addSubview($0)
        }
    }

    func setupLayoutConstraints() {
        iconImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().offset(Self.sidePadding)
            $0.top.equalToSuperview().offset(16)
            $0.size.equalTo(CGSize(w: Self.iconImageWidth, h: Self.iconImageWidth))
        }

        titleLabel.snp.makeConstraints {
            $0.centerY.equalTo(iconImageView)
            $0.leading.equalTo(iconImageView.snp.trailing).offset(Self.sidePadding)
            $0.width.equalTo(220)
        }

        tagLabel.snp.makeConstraints {
            $0.leading.equalTo(iconImageView)
            $0.top.equalTo(iconImageView.snp.bottom).offset(18)
        }

        editButton.snp.makeConstraints {
            $0.centerY.equalTo(tagLabel)
            $0.trailing.equalToSuperview().inset(34)
        }
    }
}
