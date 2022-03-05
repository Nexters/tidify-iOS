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

class OnboardingViewController: BaseViewController {

    // MARK: - Constants

    static let sidePadding: CGFloat = 40

    // MARK: - Properties

    private weak var pageControl: UIPageControl!
    private weak var collectionView: UICollectionView!
    private weak var nextButton: UIButton!

    private let viewModel: OnboardingViewModel!
    private let disposeBag = DisposeBag()
    private let currentPageRelay = BehaviorRelay<Int>(value: 0)

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

        let input = OnboardingViewModel.Input(nextButtonTap: nextButton.rx.tap.asDriver(),
                                              currentPage: currentPageRelay.asDriver())

        let output = viewModel.transform(input)

        currentPageRelay.asDriver()
            .do(onNext: { [weak self] index in
                guard let onboarding = self?.viewModel.onboardingDataSource[safe: index] else {
                    return
                }
                self?.pageControl.currentPage = index
                self?.nextButton.setTitle(onboarding.buttonTitle, for: .normal)
            })
            .drive(onNext: { [weak self] index in
                self?.collectionView.scrollToItem(at: IndexPath(item: index, section: 0),
                                                  at: .centeredHorizontally, animated: true)
            })
            .disposed(by: disposeBag)

        output.didTapNextButton
            .drive(onNext: { [weak self] _ in
                guard let strongSelf = self else {
                    return
                }

                let currentIndex = strongSelf.currentPageRelay.value
                self?.currentPageRelay.accept(currentIndex + 1)
            })
            .disposed(by: disposeBag)
    }

    override func setupViews() {
        self.pageControl = UIPageControl().then {
            $0.currentPageIndicatorTintColor = .t_indigo()
            $0.pageIndicatorTintColor = .systemGray
            $0.currentPage = 0
            $0.numberOfPages = viewModel.onboardingDataSource.count
            $0.transform = CGAffineTransform(scaleX: 2.0, y: 2.0)
            view.addSubview($0)
        }

        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.scrollDirection = .horizontal
        flowLayout.sectionInset = .zero
        flowLayout.minimumLineSpacing = .zero
        flowLayout.minimumInteritemSpacing = .zero

        self.collectionView = UICollectionView(frame: .zero,
                                               collectionViewLayout: flowLayout).then {
            $0.delegate = self
            $0.dataSource = self
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.t_registerCellClass(cellType: OnboardingCollectionViewCell.self)
            $0.backgroundColor = .white
            view.addSubview($0)
        }

        self.nextButton = UIButton().then {
            $0.backgroundColor = .t_tidiBlue()
            $0.titleLabel?.font = .t_B(16)
            $0.t_cornerRadius(radius: 16)
            view.addSubview($0)
        }
    }

    override func setupLayoutConstraints() {
        pageControl.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(38)
            $0.leading.equalToSuperview().offset(Self.sidePadding)
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
}

// MARK: - DataSource

extension OnboardingViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return viewModel.onboardingDataSource.count
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let onboarding = viewModel.onboardingDataSource[safe: indexPath.item] else {
            return UICollectionViewCell()
        }
        let cell = collectionView.t_dequeueReusableCell(cellType: OnboardingCollectionViewCell.self,
                                                        indexPath: indexPath)
        cell.setOnboarding(onboarding)

        return cell
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

        currentPageRelay.accept(pageIndex)
    }
}
