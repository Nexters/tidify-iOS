//
//  DefaultTableViewCell.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/27.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class DefaultTableViewCell: UITableViewCell {

    // MARK: - Constants

    static let SidePadding: CGFloat = 15

    // MARK: - Properties

    private weak var titleLabel: UILabel!

    // MARK: - Initialize

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        setupViews()
        setupLayoutConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Methods

    private func setupViews() {
        self.contentView.backgroundColor = .white

        let titleLabel = UILabel().then {
            $0.textColor = .black
            $0.font = .t_R(15)
            contentView.addSubview($0)
        }
        self.titleLabel = titleLabel
    }

    private func setupLayoutConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Self.SidePadding)
        }
    }

    func setCell(_ title: String, isHeader: Bool, showDisclosure: Bool) {
        self.titleLabel.text = title
        self.titleLabel.font = isHeader ? .t_B(16) : .t_R(16)
        self.accessoryType = showDisclosure ? .disclosureIndicator : .none
    }
}
