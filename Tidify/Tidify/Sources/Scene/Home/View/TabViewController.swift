//
//  TabViewController.swift
//  Tidify
//
//  Created by Manjong Han on 2021/07/17.
//

import RxSwift
import UIKit

class TabViewController: UIViewController {

    weak var coordinator: TabViewCoordinator?

    private var viewModel: TabViewViewModel!

    private weak var floatingBarBackground: UIView!
    private weak var floatingBarStackView: UIStackView!
    private weak var homeTabButton: UIButton!
    private weak var registerTabButton: UIButton!

    private let disposeBag = DisposeBag()

    private var footerHeight: CGFloat = 50

    private let tabButtonTap = PublishSubject<Int>()

    init(viewModel: TabViewViewModel) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupViews()
        setupLayoutConstraints()

        let input = TabViewViewModel.Input(tabButtonTap: tabButtonTap.asObservable())
        let output = viewModel.transfrom(input)

        homeTabButton.rx.tap.bind { [weak self] in
            self?.tabButtonTap.onNext(TabViewCoordinator.HOME_VIEW_TAB_INDEX)
        }
        .disposed(by: disposeBag)

        registerTabButton.rx.tap.bind { [weak self] in
            self?.tabButtonTap.onNext(TabViewCoordinator.REGISTER_VIEW_TAB_INDEX)
        }
        .disposed(by: disposeBag)

        output.tabButtonTap
            .drive(onNext: { [weak self] selectedIndex in

                self?.homeTabButton.isSelected = false
                self?.registerTabButton.isSelected = false

                if let previousIndex = self?.viewModel.previousIndex {
                    self?.removeFromTab(previousIndex: previousIndex)
                }

                if let selectedIndex = self?.viewModel.selectedIndex {
                    self?.showOnTab(selectedIndex: selectedIndex)
                }
            })
            .disposed(by: disposeBag)

    }

    func removeFromTab(previousIndex: Int) {
        let currentViewController = self.coordinator?.getChildViewController(index: previousIndex)

        currentViewController?.willMove(toParent: nil)
        currentViewController?.view.removeFromSuperview()
        currentViewController?.removeFromParent()

        self.homeTabButton.isSelected = false
        self.registerTabButton.isSelected = false
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

        if selectedIndex == TabViewCoordinator.HOME_VIEW_TAB_INDEX {
            self.homeTabButton.isSelected = true
        }

        if selectedIndex == TabViewCoordinator.REGISTER_VIEW_TAB_INDEX {
            self.registerTabButton.isSelected = true
        }
    }
}

private extension TabViewController {

    func setupViews() {
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

            self.floatingBarBackground.addSubview($0)
        }

        self.homeTabButton = UIButton().then {
            $0.setTitle("홈", for: .normal)
            $0.setTitleColor(.black, for: .normal)

            self.floatingBarStackView.addArrangedSubview($0)
        }

        self.registerTabButton = UIButton().then {
            $0.setTitle("추가", for: .normal)
            $0.setTitleColor(.black, for: .normal)

            self.floatingBarStackView.addArrangedSubview($0)
        }
    }

    func setupLayoutConstraints() {
        floatingBarBackground.snp.makeConstraints {
            $0.height.equalTo(40)
            $0.left.equalToSuperview().offset(80)
            $0.right.equalToSuperview().offset(-80)
            $0.bottom.equalToSuperview().offset(-80)
        }
    }
}
