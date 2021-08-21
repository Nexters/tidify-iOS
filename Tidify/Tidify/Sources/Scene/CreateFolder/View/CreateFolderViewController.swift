//
//  CreateFolderViewController.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/21.
//

import RxCocoa
import RxSwift
import SnapKit
import Then
import UIKit

class CreateFolderViewController: BaseViewController {

    // MARK: - Properties

    weak var coordinator: CreateFolderCoordinator?
    private let viewModel: CreateFolderViewModel
    private let disposeBag = DisposeBag()

    // MARK: - Initialize

    init(viewModel: CreateFolderViewModel, leftButton: UIButton) {
        self.viewModel = viewModel

        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Override

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override func setupViews() {

    }

    override func setupLayoutConstraints() {

    }
}
