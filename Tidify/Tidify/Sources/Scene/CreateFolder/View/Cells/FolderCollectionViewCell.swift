//
//  FolderCollectionViewCell.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/21.
//

import SnapKit
import Then
import UIKit

class FolderCollectionViewCell: UICollectionViewCell {

    // MARK: - Constants

    static let width: CGFloat = 335
    static let height: CGFloat = 56
    static let folderColorViewWidth: CGFloat = 16
    static let colorViewToNameHorizontalSpacing: CGFloat = 20

    // MARK: - Properties

    private weak var folderColorView: UIView!
    private weak var folderNameLabel: UILabel!

    private var folder: Folder?

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)

        setupViews()
        setupLayoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setFolder(_ folder: Folder) {
        self.folder = folder

        folderNameLabel.text = folder.name
        folderColorView.backgroundColor = UIColor(hexString: folder.color)
    }
}

private extension FolderCollectionViewCell {
    func setupViews() {
        self.folderColorView = UIView().then {
            $0.t_cornerRadius([.topLeft, .bottomLeft], radius: 8)
            contentView.addSubview($0)
        }

        self.folderNameLabel = UILabel().then {
            $0.font = .t_B(16)
            contentView.addSubview($0)
        }
    }

    func setupLayoutConstraints() {
        folderColorView.snp.makeConstraints {
            $0.leading.top.bottom.equalToSuperview()
            $0.width.equalTo(Self.folderColorViewWidth)
        }

        folderNameLabel.snp.makeConstraints {
            $0.leading.equalTo(folderColorView).offset(Self.colorViewToNameHorizontalSpacing)
            $0.centerY.equalToSuperview()
        }
    }
}
