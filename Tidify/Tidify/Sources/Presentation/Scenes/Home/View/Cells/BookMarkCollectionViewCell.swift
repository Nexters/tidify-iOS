//
//  BookMarkCollectionViewCell.swift
//  Tidify
//
//  Created by 한상진 on 2022/03/23.
//

import UIKit

import Kingfisher
import RxCocoa
import RxSwift

final class BookMarkCollectionViewCell: UICollectionViewCell {

  // MARK: - Constants

  static let width: CGFloat = 335
  static let height: CGFloat = 56
  static let swipedPositionX: CGFloat = 191

  // MARK: - Properties

  private weak var thumbnailImageView: UIImageView!
  private weak var bookMarkImageView: UIImageView!
  private weak var bookMarkNameLabel: UILabel!
  weak var editButton: UIButton!
  weak var deleteButton: UIButton!
  weak var swipeView: UIStackView!
  weak var panGestureRecognizer: UIPanGestureRecognizer!
  var isSwiped = BehaviorRelay<Bool>(value: false)

  private var disposeBag = DisposeBag()
  private var buttonTag: Int?
  private var bookMark: BookMark?

  // MARK: - Initialize
  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
    setupLayoutConstraints()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func layoutSubviews() {
    super.layoutSubviews()

    if panGestureRecognizer.state == .changed { dragSwipeView() }
  }

  override func prepareForReuse() {
    super.prepareForReuse()

    t_initSwipeView(swipeView: swipeView, width: Self.width, isSwiped: isSwiped)
    disposeBag = DisposeBag()
  }
}

extension BookMarkCollectionViewCell {
  func setFolder(
    _ bookMark: BookMark,
    buttonTag: Int,
    lastIndexObserver: AnyObserver<Int>
  ) {
    self.bookMark = bookMark
    self.buttonTag = buttonTag
    self.editButton.tag = buttonTag
    self.deleteButton.tag = buttonTag

    bookMarkNameLabel.text = bookMark.title

    guard let urlString = bookMark.urlString else { return }
    let url = URL(string: urlString)
    thumbnailImageView.kf.setImage(with: url)

    panGestureRecognizer.rx.event
      .asDriver()
      .filter { $0.state == .began }
      .drive(onNext: { [weak self] _ in
        guard let self = self, let tag = self.buttonTag else { return }
        lastIndexObserver.onNext(tag)
      })
      .disposed(by: disposeBag)
  }
}

extension BookMarkCollectionViewCell: UIGestureRecognizerDelegate {
  func gestureRecognizer(
    _ gestureRecognizer: UIGestureRecognizer,
    shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
  ) -> Bool { return true }
}

private extension BookMarkCollectionViewCell {
  func setupViews() {
    t_cornerRadius(radius: 8)
    layer.borderWidth = 1
    layer.borderColor = UIColor(hexString: "3C3C43").withAlphaComponent(0.08).cgColor

    panGestureRecognizer = UIPanGestureRecognizer(
      target: self,
      action: #selector(onPan)
    ).then {
      $0.delegate = self
      addGestureRecognizer($0)
    }

    editButton = UIButton().then {
      $0.setTitle(R.string.localizable.mainCellEditTitle(), for: .normal)
      $0.setTitleColor(UIColor.t_indigo00(), for: .normal)
      $0.titleLabel?.font = UIFont.t_SB(14)
      $0.layer.borderWidth = 1
      $0.layer.borderColor = UIColor(hexString: "3C3C43").withAlphaComponent(0.08).cgColor
    }

    deleteButton = UIButton().then {
      $0.setTitle(R.string.localizable.mainCellDeleteTitle(), for: .normal)
      $0.setTitleColor(.white, for: .normal)
      $0.titleLabel?.font = UIFont.t_SB(14)
      $0.backgroundColor = .red
    }

    swipeView = UIStackView().then {
      $0.axis = .horizontal
      $0.t_cornerRadius([.topRight, .bottomRight], radius: 8)
      $0.alignment = .fill
      $0.distribution = .fillEqually
      $0.addArrangedSubview(editButton)
      $0.addArrangedSubview(deleteButton)
      $0.frame = CGRect(x: Self.width, y: 0, width: 144, height: Self.height)
      contentView.addSubview($0)
    }

    bookMarkNameLabel = UILabel().then {
      $0.font = .t_B(16)
      contentView.addSubview($0)
    }

    bookMarkImageView = UIImageView().then {
      $0.image = R.image.bookMark_default_Image()
      contentView.addSubview($0)
    }

    thumbnailImageView = UIImageView().then {
      $0.t_cornerRadius(radius: 4)
      bookMarkImageView.addSubview($0)
    }
  }

  func setupLayoutConstraints() {
    bookMarkImageView.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(10)
      $0.top.bottom.equalToSuperview().inset(8)
      $0.width.equalTo(40)
    }

    bookMarkNameLabel.snp.makeConstraints {
      $0.leading.equalTo(bookMarkImageView.snp.trailing).offset(16)
      $0.centerY.equalToSuperview()
    }

    thumbnailImageView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }
  }

  func dragSwipeView() {
    if swipeView.frame.origin.x < Self.width - swipeView.frame.width { return }

    let p = panGestureRecognizer.translation(in: self)
    swipeView.frame.origin.x = isSwiped.value ? p.x + Self.swipedPositionX : p.x + Self.width
  }

  @objc
  func onPan() {
    t_panSwipeAction(
      panGestureRecognizer,
      swipeView: swipeView,
      isSwiped: isSwiped,
      width: Self.width,
      disposeBag: disposeBag
    )
  }
}
