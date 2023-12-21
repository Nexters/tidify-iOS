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

protocol BookmarkCellDelegate: AnyObject {
  func didTapStarButton(bookmarkID: Int)
}

final class BookmarkCell: UITableViewCell {

  // MARK: - Properties
  private let bookmarkImageView: UIImageView = {
    let imageView: UIImageView = .init(image: .symbolImage)
    imageView.contentMode = .scaleAspectFit
    imageView.cornerRadius(radius: 4)
    return imageView
  }()

  private let bookmarkNameLabel: UILabel = {
    let label: UILabel = .init()
    label.font = .t_B(15)
    label.textColor = .t_ashBlue(weight: 800)
    return label
  }()

  private lazy var starButton: UIButton = {
    let button: UIButton = .init()
    button.addTarget(self, action: #selector(didTapStarButton), for: .touchUpInside)
    return button
  }()

  weak var delegate: BookmarkCellDelegate?
  private var bookmark: Bookmark?

  // MARK: Initializer
  override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
    super.init(style: style, reuseIdentifier: reuseIdentifier)

    setupUI()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    bookmarkImageView.image = .symbolImage
    starButton.setImage(.init(named: "starOffIcon"), for: .normal)
    bookmark = nil
    delegate = nil
  }

  // MARK: - Methods
  func configure(bookmark: Bookmark) {
    self.bookmark = bookmark
    updateUI(bookmark: bookmark)
  }
}

private extension BookmarkCell {
  func updateUI(bookmark: Bookmark) {
    var bookmarkName: String = bookmark.name

    OpenGraph.fetch(url: bookmark.url) { [weak self] result in
      switch result {
      case .success(let openGraph):
        if bookmark.name.isEmpty {
          bookmarkName = openGraph[.title] ?? ""
        }

        if let urlString = openGraph[.image] {
          DispatchQueue.main.async { [weak self] in
            self?.bookmarkImageView.setImage(with: urlString)
          }
        }
      case .failure(let error):
        DispatchQueue.main.async {
          self?.bookmarkImageView.image = .symbolImage
        }
        print("❌ \(#file) - \(#line): \(#function) - Fail: \(error.localizedDescription)")
      }
    }

    bookmarkNameLabel.text = bookmarkName
    starButton.setImage(.init(named: bookmark.star ? "starOnIcon" : "starOffIcon"), for: .normal)
  }

  func setupUI() {
    backgroundColor = .white
    selectionStyle = .none
    contentView.addSubview(bookmarkImageView)
    contentView.addSubview(bookmarkNameLabel)
    contentView.addSubview(starButton)

    bookmarkImageView.snp.makeConstraints {
      $0.top.bottom.equalToSuperview().inset(10)
      $0.leading.equalToSuperview().offset(20)
      $0.width.equalTo(bookmarkImageView.snp.height)
    }

    starButton.snp.makeConstraints {
      $0.top.trailing.bottom.equalToSuperview().inset(20)
      $0.width.equalTo(starButton.snp.height)
    }

    bookmarkNameLabel.snp.makeConstraints {
      $0.leading.equalTo(bookmarkImageView.snp.trailing).offset(20)
      $0.trailing.lessThanOrEqualTo(starButton.snp.trailing).inset(80)
      $0.centerY.equalTo(bookmarkImageView)
    }
  }

  @objc func didTapStarButton() {
    bookmark?.star.toggle()

    guard let bookmark = bookmark else {
      return
    }

    starButton.setImage(.init(named: bookmark.star ? "starOnIcon" : "starOffIcon"), for: .normal)
    delegate?.didTapStarButton(bookmarkID: bookmark.id)
  }
}
