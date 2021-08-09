//
//  TabViewController.swift
//  Tidify
//
//  Created by Manjong Han on 2021/07/17.
//

import RxSwift
import UIKit

class TabViewController: BaseViewController {

    // MARK: - Properties

    weak var coordinator: TabViewCoordinator?

    private var viewModel: TabViewViewModel!

    private weak var floatingBarBackground: UIView!
    private weak var floatingBarStackView: UIStackView!
    private weak var homeTabButton: UIButton!
    private weak var searchTabButton: UIButton!
    private weak var categoryTabButton: UIButton!

    private let disposeBag = DisposeBag()

    private let tabButtonTap = PublishSubject<Int>()

    // MARK: - Initialize

    init(viewModel: TabViewViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(showTabBar),
                                               name: NSNotification.Name(rawValue: TabBarManager.ManagerBehavior.show.rawValue), object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(hideTabBar),
                                               name: NSNotification.Name(rawValue: TabBarManager.ManagerBehavior.hide.rawValue), object: nil)

        let input = TabViewViewModel.Input(tabButtonTap: tabButtonTap.asObservable())
        let output = viewModel.transform(input)

        homeTabButton.rx.tap.bind { [weak self] in
            self?.tabButtonTap.onNext(TabBarIndex.Home.rawValue)
        }
        .disposed(by: disposeBag)

        searchTabButton.rx.tap.bind { [weak self] in
            self?.tabButtonTap.onNext(TabBarIndex.Search.rawValue)
        }
        .disposed(by: disposeBag)

        categoryTabButton.rx.tap.bind { [weak self] in
            // TODO: category 페이지 생성 후 변경 필요
//            self?.tabButtonTap.onNext(TabBarIndex.Category.rawValue)
            self?.tabButtonTap.onNext(TabBarIndex.Search.rawValue)
        }
        .disposed(by: disposeBag)

        output.tabButtonTap
            .drive(onNext: { [weak self] selectedIndex in

                self?.homeTabButton.isSelected = false
                self?.searchTabButton.isSelected = false

                if let previousIndex = self?.viewModel.previousIndex {
                    self?.coordinator?.hide(previousIndex: previousIndex)
                }

                if let selectedIndex = self?.viewModel.selectedIndex {
                    self?.coordinator?.show(selectedIndex: selectedIndex)
                }
            })
            .disposed(by: disposeBag)
    }

    override func setupViews() {
        view.backgroundColor = .white

        self.floatingBarBackground = UIView().then {

            if !UIAccessibility.isReduceTransparencyEnabled {
                $0.backgroundColor = .clear

                let blurEffect = UIBlurEffect(style: .regular)
                let blurEffectView = UIVisualEffectView(effect: blurEffect)
                //always fill the view
                blurEffectView.frame = $0.bounds
                blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]

                blurEffectView.layer.cornerRadius = 16
                blurEffectView.clipsToBounds = true

                $0.addSubview(blurEffectView)
            } else {
                $0.backgroundColor = .gray
            }

            $0.layer.shadowColor = UIColor.black.cgColor
            $0.layer.shadowOpacity = 0.7
            $0.layer.shadowOffset = CGSize(w: 0, h: 3)
            $0.layer.shadowRadius = 10

            view.addSubview($0)
        }

        self.floatingBarStackView = UIStackView().then {
            $0.axis = .horizontal
            $0.spacing = 10
            $0.alignment = .fill
            $0.distribution = .fillEqually
            $0.contentMode = .scaleToFill
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.autoresizesSubviews = true
            $0.layer.cornerRadius = 25

            self.floatingBarBackground.addSubview($0)
        }

        self.homeTabButton = UIButton().then {
            $0.setImage(R.image.tabBar_icon_home_deSelected(), for: .normal)
            $0.setImage(R.image.tabBar_icon_home_selected(), for: .selected)
            self.floatingBarStackView.addArrangedSubview($0)
        }

        self.searchTabButton = UIButton().then {
            $0.setImage(R.image.tabBar_icon_search_deSelected(), for: .normal)
            $0.setImage(R.image.tabBar_icon_search_selected(), for: .selected)
            self.floatingBarStackView.addArrangedSubview($0)
        }

        self.categoryTabButton = UIButton().then {
            $0.setImage(R.image.tabbar_icon_category_deSelected(), for: .normal)
            $0.setImage(R.image.tabBar_icon_category_selected(), for: .selected)
            self.floatingBarStackView.addArrangedSubview($0)
        }
    }

    override func setupLayoutConstraints() {
        floatingBarBackground.snp.makeConstraints {
            $0.height.equalTo(50)
            $0.left.equalToSuperview().offset(80)
            $0.right.equalToSuperview().offset(-80)
            $0.bottom.equalToSuperview().offset(-80)
        }
    }
}

extension TabViewController {
    func removeFromTab(previousIndex: Int) {
        let currentViewController = self.coordinator?.getChildViewController(index: previousIndex)

        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()

        self.homeTabButton.isSelected = false
        self.searchTabButton.isSelected = false
    }

    func showOnTab(selectedIndex: Int) {
        if let selectedViewController = self.coordinator?.getChildViewController(index: selectedIndex) {
            selectedViewController.view.frame = self.view.frame
            selectedViewController.didMove(toParent: self)

            self.addChild(selectedViewController)
            self.view.addSubview(selectedViewController.view)

            if let floatingBarBackground = self.floatingBarBackground {
                self.view.bringSubviewToFront(floatingBarBackground)
            }
        }

        switch selectedIndex {
        case TabBarIndex.Home.rawValue:
            self.homeTabButton.isSelected = true
        case TabBarIndex.Search.rawValue:
            self.searchTabButton.isSelected = true
        case TabBarIndex.Category.rawValue:
            self.categoryTabButton.isSelected = true
        default:
            return
        }
    }

    @objc
    func showTabBar() {
        DispatchQueue.main.async { [weak self] in
            self?.floatingBarStackView.isHidden = false
            self?.floatingBarBackground.isHidden = false
        }
    }

    @objc
    func hideTabBar() {
        DispatchQueue.main.async { [weak self] in
            self?.floatingBarStackView.isHidden = true
            self?.floatingBarBackground.isHidden = true
        }
    }
}
