//
//  SearchHistoryCell.swift
//  Tidify
//
//  Created by Ian on 2022/03/13.
//

import UIKit

final class SearchHistoryCell: UITableViewCell {
  
  // MARK: - Properties
  private weak var titleLabel: UILabel!
  
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
    
    titleLabel.text = nil
  }
  
  func configure(_ title: String) {
    self.titleLabel.text = title
  }
}

private extension SearchHistoryCell {
  func setupViews() {
    self.titleLabel = UILabel().then {
      $0.font = .t_R(16)
      $0.textColor = .black
      contentView.addSubview($0)
    }
    
    self.accessoryType = .disclosureIndicator
  }
  
  func setupLayoutConstraints() {
    titleLabel.snp.makeConstraints {
      $0.centerY.equalToSuperview()
      $0.leading.equalToSuperview().offset(20)
    }
  }
}
