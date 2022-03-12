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

    static let sidePadding: CGFloat = 15

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
        self.backgroundColor = .clear

        self.titleLabel = UILabel().then {
            $0.textColor = .black
            $0.font = .t_R(15)
            contentView.addSubview($0)
        }
    }

    private func setupLayoutConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(Self.sidePadding)
        }
    }

    func setCell(_ title: String, isHeader: Bool, showDisclosure: Bool = false,
                 radiusEdges: [UIRectCorner] = [], radius: CGFloat = 0)
    {
        self.titleLabel.text = title
        self.titleLabel.font = isHeader ? .t_B(16) : .t_R(16)
        self.accessoryType = showDisclosure ? .disclosureIndicator : .none
        contentView.t_cornerRadius(radiusEdges, radius: radius)
    }
}
