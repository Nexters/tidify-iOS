//
//  FolderCollectionViewCell.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/21.
//

import RxSwift
import SnapKit
import Then
import UIKit
import RxRelay

final class FolderCollectionViewCell: UICollectionViewCell {

    // MARK: - Constants

    static let width: CGFloat = 335
    static let height: CGFloat = 56
    static let folderColorViewWidth: CGFloat = 16
    static let colorViewToNameHorizontalSpacing: CGFloat = 24
    static let swipedPositionX: CGFloat = 191

    // MARK: - Properties

    private weak var folderColorView: UIView!
    private weak var folderNameLabel: UILabel!
    var editButton: UIButton!
    var deleteButton: UIButton!
    private var swipeView: UIStackView!
    private var panGestureRecognizer: UIPanGestureRecognizer!
    private var isSwiped = false

    private var disposeBag = DisposeBag()
    private var buttonTag: Int?
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

    override func layoutSubviews() {
        super.layoutSubviews()

        if panGestureRecognizer.state == .changed { dragSwipeView() }
    }

    override func prepareForReuse() {
        super.prepareForReuse()

        initSwipeView()
        disposeBag = DisposeBag()
    }
}

extension FolderCollectionViewCell: UIGestureRecognizerDelegate {
    func setFolder(
        _ folder: Folder,
        buttonTag: Int,
        lastIndexObserver: AnyObserver<Int>
    ) {
        self.folder = folder
        self.buttonTag = buttonTag
        self.editButton.tag = buttonTag
        self.deleteButton.tag = buttonTag

        folderNameLabel.text = folder.name
        folderColorView.backgroundColor = UIColor(hexString: folder.color)

        panGestureRecognizer.rx.event
            .asDriver()
            .filter { $0.state == .began }
            .drive(onNext: { [weak self] _ in
                guard let self = self, let tag = self.buttonTag else { return }
                lastIndexObserver.onNext(tag)
            })
            .disposed(by: disposeBag)
    }

    func initSwipeView() {
        swipeView.frame.origin.x = Self.width
        isSwiped = false
    }

    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer
    ) -> Bool { return true }
}

private extension FolderCollectionViewCell {
    func setupViews() {
        t_cornerRadius(radius: 8)
        layer.borderWidth = 1
        layer.borderColor = UIColor(hexString: "3C3C43").withAlphaComponent(0.08).cgColor

        self.panGestureRecognizer = UIPanGestureRecognizer(
            target: self,
            action: #selector(onPan(_:))
        ).then {
            $0.delegate = self
            addGestureRecognizer($0)
        }

        self.editButton = UIButton().then {
            $0.setTitle(R.string.localizable.mainCellEditTitle(), for: .normal)
            $0.setTitleColor(UIColor.t_indigo(), for: .normal)
            $0.titleLabel?.font = UIFont.t_SB(14)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor(hexString: "3C3C43").withAlphaComponent(0.08).cgColor
        }

        self.deleteButton = UIButton().then {
            $0.setTitle(R.string.localizable.mainCellDeleteTitle(), for: .normal)
            $0.setTitleColor(.white, for: .normal)
            $0.titleLabel?.font = UIFont.t_SB(14)
            $0.backgroundColor = .red
        }

        self.swipeView = UIStackView().then {
            $0.axis = .horizontal
            $0.t_cornerRadius([.topRight, .bottomRight], radius: 8)
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.addArrangedSubview(editButton)
            $0.addArrangedSubview(deleteButton)
            $0.frame = CGRect(x: Self.width, y: 0, width: 144, height: Self.height)
            contentView.addSubview($0)
        }

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
            $0.leading.equalTo(folderColorView.snp.trailing)
                .offset(Self.colorViewToNameHorizontalSpacing)
            $0.centerY.equalToSuperview()
        }
    }

    func dragSwipeView() {
        if swipeView.frame.origin.x < Self.width - swipeView.frame.width { return }

        let p = panGestureRecognizer.translation(in: self)
        swipeView.frame.origin.x = isSwiped ? p.x + Self.swipedPositionX : p.x + Self.width
    }

    @objc
    func onPan(_ panGestureRecognizer: UIPanGestureRecognizer) {
        panGestureRecognizer.rx.event
            .map { $0 .state }
            .bind { [weak self] in
                guard let self = self else { return }
                switch $0 {
                case .changed:
                    self.setNeedsLayout()
                case .ended:
                    if self.swipeView.center.x < 331 {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.swipeView.frame.origin.x = Self.width - self.swipeView.frame.width
                            self.layoutIfNeeded()
                        })
                        self.isSwiped = true
                    } else {
                        UIView.animate(withDuration: 0.3, animations: {
                            self.initSwipeView()
                        })
                    }
                case .possible: return
                case .began: return
                case .cancelled: return
                case .failed: return
                @unknown default: return
                }
            }
            .disposed(by: disposeBag)
    }
}
