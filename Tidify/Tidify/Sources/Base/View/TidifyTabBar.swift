//
//  TidifyTabBar.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/16.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

protocol TidifyTabBarDelegate: AnyObject {
    func didSelectTab(_ item: TabBarItem)
}

class TidifyTabBar: UIView {

    // MARK: - Properties

    weak var delegate: TidifyTabBarDelegate?

    private weak var backgroundView: UIView!
    private weak var stackView: UIStackView!
    private weak var homeTabButton: UIButton!
    private weak var searchTabButton: UIButton!
    private weak var categoryTabButton: UIButton!

    private let disposeBag = DisposeBag()

    // MARK: - Initialize

    init() {
        super.init(frame: .zero)

        setupViews()
        setupLayoutConstraints()

        let didHomeTap = homeTabButton.rx.tap.asDriver()
            .do(onNext: { [weak self] _ in
                self?.delegate?.didSelectTab(.home)
            })
            .map { _ in TabBarItem.home }

        let didSearchTap = searchTabButton.rx.tap.asDriver()
            .do(onNext: { [weak self] _ in
                self?.delegate?.didSelectTab(.search)
            })
            .map { _ in TabBarItem.search }

        let didCategoryTap = categoryTabButton.rx.tap.asDriver()
            .do(onNext: { [weak self] _ in
                self?.delegate?.didSelectTab(.category)
            })
            .map { _ in TabBarItem.category }

        Driver.merge(didHomeTap, didSearchTap, didCategoryTap).startWith(.home)
            .drive(onNext: { [weak self] tab in
                self?.updateTabBar(tab)
            })
            .disposed(by: disposeBag)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension TidifyTabBar {
    func setupViews() {
        self.backgroundColor = .clear

        self.backgroundView = UIView().then {
            if !UIAccessibility.isReduceTransparencyEnabled {
                $0.backgroundColor = .clear

                let blurEffect = UIBlurEffect(style: .regular)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                blurEffectView.frame = $0.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                blurEffectView.layer.cornerRadius = 28
                blurEffectView.clipsToBounds = true

                $0.addSubview(blurEffectView)
            } else {
                $0.backgroundColor = .gray
            }

            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.7
            $0.layer.shadowOffset = CGSize(w: 0, h: 2)
            $0.layer.shadowRadius = 10

            self.addSubview($0)
        }

        self.stackView = UIStackView().then {
            $0.axis = .horizontal
            $0.alignment = .center
            $0.distribution = .fillEqually
            $0.contentMode = .scaleToFill

            backgroundView.addSubview($0)
        }

        self.homeTabButton = UIButton().then {
            $0.setImage(R.image.tabBar_icon_home_deSelected(), for: .normal)
            $0.setImage(R.image.tabBar_icon_home_selected(), for: .selected)
            self.stackView.addArrangedSubview($0)
        }

        self.searchTabButton = UIButton().then {
            $0.setImage(R.image.tabBar_icon_search_deSelected(), for: .normal)
            $0.setImage(R.image.tabBar_icon_search_selected(), for: .selected)
            self.stackView.addArrangedSubview($0)
        }

        self.categoryTabButton = UIButton().then {
            $0.setImage(R.image.tabBar_icon_category_deSelected(), for: .normal)
            $0.setImage(R.image.tabbar_icon_category_selected(), for: .selected)
            self.stackView.addArrangedSubview($0)
        }
    }

    func setupLayoutConstraints() {
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        backgroundView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }

    func updateTabBar(_ selectedItem: TabBarItem) {
        switch selectedItem {
        case .home:
            homeTabButton.isSelected = true
            searchTabButton.isSelected = false
            categoryTabButton.isSelected = false

        case .search:
            homeTabButton.isSelected = false
            searchTabButton.isSelected = true
            categoryTabButton.isSelected = false

        case .category:
            homeTabButton.isSelected = false
            searchTabButton.isSelected = false
            categoryTabButton.isSelected = true
        }
    }
}
