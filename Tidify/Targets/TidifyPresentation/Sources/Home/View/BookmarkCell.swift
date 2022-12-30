//
//  BookmarkCell.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/24.
//  Copyright © 2022 Tidify. All rights reserved.
//

import TidifyDomain
import UIKit

import Kingfisher
import OpenGraph

final class BookmarkCell: UITableViewCell {

  // MARK: - Properties
  private let thumbnailImageView: UIImageView = .init()
  private let bookmarkImageView: UIImageView = .init()
  private let bookmarkNameLabel: UILabel = .init()
  private let editButton: UIButton = .init()

  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    thumbnailImageView.image = nil
    bookmarkImageView.image = nil
  }
  
  override func layoutSubviews() {
    super.layoutSubviews()
    setupPadding()
  }

  // MARK: - Methods
  func configure(bookmark: Bookmark) {
    updateUI(bookmark: bookmark)
  }
}

private extension BookmarkCell {
  func updateUI(bookmark: Bookmark) {
    var bookmarkName: String = bookmark.title

    OpenGraph.fetch(url: bookmark.url) { [weak self] result in
      switch result {
      case .success(let openGraph):
        if let imageURL = URL(string: openGraph[.image] ?? "") {
          DispatchQueue.main.async {
            self?.bookmarkImageView.kf.setImage(with: imageURL)
          }
        }

        if bookmark.title.isEmpty {
          bookmarkName = openGraph[.title] ?? ""
        }

      case .failure(let error):
        DispatchQueue.main.async {
          self?.bookmarkImageView.image = .init(named: "icon_symbol")
        }
        print("❌ \(#file) - \(#line): \(#function) - Fail: \(error.localizedDescription)")
      }
    }

    bookmarkNameLabel.text = bookmarkName
  }

  func setupUI() {
    backgroundColor = .white
    selectionStyle = .none

    contentView.cornerRadius(radius: 8)
    contentView.layer.borderWidth = 1
    contentView.layer.borderColor = UIColor.t_background().cgColor

    bookmarkNameLabel.do {
      $0.font = .t_B(16)
      contentView.addSubview($0)
    }

    bookmarkImageView.do {
      $0.image = .init(named: "icon_symbol")
      $0.contentMode = .scaleAspectFit
      $0.cornerRadius(radius: 4)
      contentView.addSubview($0)
    }

    thumbnailImageView.do {
      $0.cornerRadius(radius: 4)
      bookmarkImageView.addSubview($0)
    }

    bookmarkImageView.snp.makeConstraints {
      $0.top.equalToSuperview().offset(8)
      $0.leading.equalToSuperview().offset(10)
      $0.bottom.equalToSuperview().offset(-8)
      $0.width.equalTo(40)
    }

    bookmarkNameLabel.snp.makeConstraints {
      $0.leading.equalTo(bookmarkImageView.snp.trailing).offset(16)
      $0.trailing.lessThanOrEqualToSuperview().offset(-10)
      $0.centerY.equalTo(bookmarkImageView)
    }
  }
  
  func setupPadding() {
    contentView.frame = contentView.frame.inset(
      by: UIEdgeInsets(
        top: 0,
        left: 0,
        bottom: 20,
        right: 0
      )
    )
  }
}
