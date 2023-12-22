//
//  OnboardingViewController.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import Combine
import TidifyDomain
import UIKit

import SnapKit

final class OnboardingViewController: UIViewController {
  weak var coordinator: DefaultOnboardingCoordinator?
  private let contents: [Onboarding] = [
    .init(imageName: "onboardingImage_0", buttonTitle: "다음"),
    .init(imageName: "onboardingImage_1", buttonTitle: "다음"),
    .init(imageName: "onboardingImage_2", buttonTitle: "간편한 북마킹 시작")
  ]
  private var contentIndex: Int = 0
  private var cancellable: Set<AnyCancellable> = []

  // MARK: UI Components
  private let pageControl: UIPageControl = {
    let pageConrol: UIPageControl = .init()
    pageConrol.currentPageIndicatorTintColor = .t_blue()
    pageConrol.pageIndicatorTintColor = .systemGray
    pageConrol.currentPage = 0
    pageConrol.numberOfPages = 3
    pageConrol.transform = .init(scaleX: 2.0, y: 2.0)
    return pageConrol
  }()

  private lazy var collectionView: UICollectionView = {
    let flowLayout: UICollectionViewFlowLayout = .init()
    flowLayout.scrollDirection = .horizontal
    flowLayout.sectionInset = .zero
    flowLayout.minimumLineSpacing = .zero
    flowLayout.minimumInteritemSpacing = .zero
    flowLayout.itemSize = UICollectionViewFlowLayout.automaticSize

    let collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: flowLayout)
    collectionView.isPagingEnabled = true
    collectionView.showsHorizontalScrollIndicator = false
    collectionView.t_registerCellClass(cellType: OnboardingCollectionViewCell.self)
    collectionView.backgroundColor = .white
    collectionView.delegate = self
    collectionView.dataSource = self
    return collectionView
  }()

  private let nextButton: UIButton = {
    let button: UIButton = .init()
    button.backgroundColor = .t_blue()
    button.titleLabel?.font = .t_B(16)
    button.setTitleColor(.white, for: .normal)
    button.cornerRadius(radius: 16)
    return button
  }()

  // MARK: Initializer
  override func viewDidLoad() {
    super.viewDidLoad()

    setupUI()
    setContent()
    bindAction()
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    coordinator?.didFinish()
  }
}

private extension OnboardingViewController {
  func setupUI() {
    view.backgroundColor = .white
    navigationController?.navigationBar.isHidden = true
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

  func bindAction() {
    nextButton.tapPublisher
      .sink(receiveValue: { [weak self] in
        self?.didTapNextButton()
        self?.setContent()
      })
      .store(in: &cancellable)
  }

  func didTapNextButton() {
    if contentIndex == contents.count - 1 {
      coordinator?.showNextScene()
    } else {
      contentIndex += 1
    }
  }

  func setContent() {
    let buttonTitle: String = contents[contentIndex].buttonTitle

    collectionView.scrollToItem(
      at: .init(item: contentIndex, section: 0),
      at: .centeredHorizontally,
      animated: true)
    pageControl.currentPage = contentIndex
    nextButton.setTitle(buttonTitle, for: .normal)
  }

  func calculatePageIndex(targetOffset: UnsafeMutablePointer<CGPoint>) -> Int {
    return Int(targetOffset.pointee.x / collectionView.frame.width)
  }
}

extension OnboardingViewController: UICollectionViewDataSource {
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return contents.count
  }

  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    guard let content = contents[safe: indexPath.row] else {
      return .init()
    }

    let cell: OnboardingCollectionViewCell = collectionView.t_dequeueReusableCell(indexPath: indexPath)
    cell.configure(content)

    return cell
  }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout, UICollectionViewDelegate {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath) -> CGSize {
      return .init(w: collectionView.frame.width, h: collectionView.frame.height - 100)
    }

  func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    contentIndex = calculatePageIndex(targetOffset: targetContentOffset)
    setContent()
  }
}
