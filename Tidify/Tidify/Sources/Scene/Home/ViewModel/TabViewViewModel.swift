//
//  TabViewViewModel.swift
//  Tidify
//
//  Created by Manjong Han on 2021/07/17.
//

import Foundation
import RxCocoa
import RxSwift

final class TabViewViewModel: ViewModelType {

  // MARK: - Properties

  var selectedIndex: Int = 0
  var previousIndex: Int = 0

  struct Input {
    let tabButtonTap: Observable<Int>
  }

  struct Output {
    let tabButtonTap: Driver<Int>
  }

  // MARK: - Methods

  func transform(_ input: Input) -> Output {

    let tabButtonTap = input.tabButtonTap
      .do(onNext: { [weak self] index in
        self?.previousIndex = self?.selectedIndex ?? 0
        self?.selectedIndex = index
      })
        .t_asDriverSkipError()

        return Output(tabButtonTap: tabButtonTap)
        }
}
