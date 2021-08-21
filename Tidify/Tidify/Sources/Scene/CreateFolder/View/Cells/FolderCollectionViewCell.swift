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

    // MARK: - Properties

    private var folder: Folder?

    // MARK: - Initialize
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setFolder(_ folder: Folder) {
        self.folder = folder
    }
}
