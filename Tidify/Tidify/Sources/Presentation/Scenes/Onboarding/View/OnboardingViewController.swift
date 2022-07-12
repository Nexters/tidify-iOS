//
//  OnboardingViewController.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/29.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

final class OnboardingViewController: BaseViewController {

  // MARK: - Properties

  private weak var pageControl: UIPageControl!
  private (set) weak var collectionView: UICollectionView!
  private weak var nextButton: UIButton!

  private let viewModel: OnboardingViewModel!

  // MARK: - Initialize

  init(viewModel: OnboardingViewModel) {
    self.viewModel = viewModel

    super.init(nibName: nil, bundle: nil)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: - Overriding

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupViews() {
    view.backgroundColor = .white

    pageControl = .init().then {
      $0.currentPageIndicatorTintColor = .t_indigo00()
      $0.pageIndicatorTintColor = .systemGray
      $0.currentPage = 0
      $0.numberOfPages = viewModel.onboardingDataSource.count
      $0.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
      view.addSubview($0)
    }

    let flowLayout: UICollectionViewFlowLayout = .init().then {
      $0.scrollDirection = .horizontal
      $0.sectionInset = .zero
      $0.minimumLineSpacing = .zero
      $0.minimumInteritemSpacing = .zero
    }

    collectionView = .init(frame: .zero, collectionViewLayout: flowLayout).then {
      $0.isPagingEnabled = true
      $0.showsHorizontalScrollIndicator = false
      $0.t_registerCellClass(cellType: OnboardingCollectionViewCell.self)
      $0.backgroundColor = .white
      $0.rx.setDelegate(self).disposed(by: disposeBag)
      view.addSubview($0)
    }

    nextButton = .init().then {
      $0.backgroundColor = .t_tidiBlue00()
      $0.titleLabel?.font = .t_B(16)
      $0.t_cornerRadius(radius: 16)
      view.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
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

  override func bindOutput() -> Disposable {
    let input = OnboardingViewModel.Input(nextButtonTap: nextButton.rx.tap.asObservable())
    let output = viewModel.transform(input)

    return Disposables.create([
      output.didTapNextButton
        .t_asDriverSkipError()
        .drive(),

      output.content
        .t_asDriverSkipError()
        .drive(collectionView.rx.items(
          cellIdentifier: OnboardingCollectionViewCell.identifer,
          cellType: OnboardingCollectionViewCell.self)) { _, content, cell in
            cell.configure(content)
        },

      output.currentPage
        .do(onNext: { [weak self] in
          self?.collectionView.scrollToItem(
            at: .init(item: $0, section: 0),
            at: .centeredHorizontally,
            animated: true)

          self?.nextButton.setTitle(
            self?.viewModel.onboardingDataSource[$0].buttonTitle,
            for: .normal)
        })
        .bind(to: pageControl.rx.currentPage)
    ])
  }
}

extension OnboardingViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(_ collectionView: UICollectionView,
                      layout collectionViewLayout: UICollectionViewLayout,
                      sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(w: collectionView.frame.width, h: collectionView.frame.height - 100)
  }
}

// MARK: - Delegate

extension OnboardingViewController: UICollectionViewDelegate {
  func scrollViewWillEndDragging(_ scrollView: UIScrollView,
                                 withVelocity velocity: CGPoint,
                                 targetContentOffset: UnsafeMutablePointer<CGPoint>) {
    let pageIndex = Int(targetContentOffset.pointee.x / collectionView.frame.width)
    viewModel.currentPageRelay.accept(pageIndex)
  }
}
