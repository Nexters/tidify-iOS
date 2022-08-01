//
//  OnboardingViewController.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/29.
//

import ReactorKit
import SnapKit
import Then
import UIKit

final class OnboardingViewController: UIViewController, View {

  // MARK: UI Components
  private var pageControl: UIPageControl = .init().then {
    $0.currentPageIndicatorTintColor = .t_indigo00()
    $0.pageIndicatorTintColor = .systemGray
    $0.currentPage = 0
    $0.numberOfPages = 4
    $0.transform = .init(scaleX: 2.0, y: 2.0)
  }

  private (set) lazy var collectionView: UICollectionView = .init(
    frame: .zero, collectionViewLayout: UICollectionViewFlowLayout().then {
    $0.scrollDirection = .horizontal
    $0.sectionInset = .zero
    $0.minimumLineSpacing = .zero
    $0.minimumInteritemSpacing = .zero
  }).then {
    $0.isPagingEnabled = true
    $0.showsHorizontalScrollIndicator = false
    $0.t_registerCellClass(cellType: OnboardingCollectionViewCell.self)
    $0.backgroundColor = .white
    $0.delegate = self
  }

  private var nextButton: UIButton = .init().then {
    $0.backgroundColor = .t_tidiBlue00()
    $0.titleLabel?.font = .t_B(16)
    $0.setTitleColor(.white, for: .normal)
    $0.titleLabel?.textColor = .white
    $0.t_cornerRadius(radius: 16)
  }

  var disposeBag: DisposeBag = .init()

  // MARK: - Methods
  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
  }

  func bind(reactor: OnboardingReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
}

private extension OnboardingViewController {
  typealias Action = OnboardingReactor.Action

  func setupUI() {
    view.backgroundColor = .white

    view.addSubview(pageControl)
    view.addSubview(collectionView)
    view.addSubview(nextButton)

    pageControl.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(38)
      $0.centerX.equalToSuperview()
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(pageControl.snp.bottom).offset(10)
      $0.leading.trailing.equalToSuperview()
      $0.bottom.equalToSuperview().offset(-140)
    }

    nextButton.snp.makeConstraints {
      $0.top.equalTo(collectionView.snp.bottom).offset(46)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().offset(-20)
      $0.bottom.equalToSuperview().offset(-40)
    }
  }

  func bindAction(reactor: OnboardingReactor) {
    nextButton.rx.tap
      .map { Action.showNextContent }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    collectionView.rx.willEndDragging
      .map { [weak self] (_, targetContentOffset: UnsafeMutablePointer<CGPoint>) in
        let index = self?.calculatePageIndex(targetOffset: targetContentOffset) ?? 0
        return Action.willEndDragging(index: index)
      }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindState(reactor: OnboardingReactor) {
    reactor.state
      .map { $0.contents }
      .bind(to: collectionView.rx.items(
        cellIdentifier: OnboardingCollectionViewCell.identifer, cellType: OnboardingCollectionViewCell.self)
      ) { _, contents, cell in
        cell.configure(contents)
      }
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.contentIndex }
      .do(onNext: { [weak self] index in
        let buttonTitle: String = reactor.initialState.contents[index].buttonTitle

        self?.collectionView.scrollToItem(
          at: .init(item: index, section: 0),
          at: .centeredHorizontally,
          animated: true)

        self?.nextButton.setTitle(buttonTitle, for: .normal)
      })
      .bind(to: pageControl.rx.currentPage)
      .disposed(by: disposeBag)
  }

  func calculatePageIndex(targetOffset: UnsafeMutablePointer<CGPoint>) -> Int {
    return Int(targetOffset.pointee.x / collectionView.frame.width)
  }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(w: collectionView.frame.width, h: collectionView.frame.height - 100)
  }
}
