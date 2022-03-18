//
//  SearchViewModel.swift
//  Tidify
//
//  Created by Ian on 2022/03/12.
//

import RxCocoa
import RxSwift

final class SearchViewModel: ViewModelType {
  enum SearchViewMode {
    case history
    case search
  }

  let searchViewModeRelay = BehaviorRelay<SearchViewMode>(value: .history)

  struct Input {
    let eraseAllHistoryButtonTap: Observable<Void>
    let beginTextFieldEdit: Observable<Void>
    let endTextFieldEdit: Observable<Void>
  }

  struct Output {
    let didChangedSearchViewMode: Driver<Void>
    let didTapEraseAllHistoryButton: Observable<Void>
    let textFieldControlEvent: Observable<Void>
  }

  func transform(_ input: Input) -> Output {
    let didChangedSearchViewMode = searchViewModeRelay
      .asDriver()
      .distinctUntilChanged()
      .map { _ in }

    let didBeginTextFieldEditing = input.beginTextFieldEdit
      .do(onNext: { [weak self] in
        self?.searchViewModeRelay.accept(.history)
      })

    let didEndTextFieldEditing = input.endTextFieldEdit
      .do(onNext: { [weak self] in
        self?.searchViewModeRelay.accept(.search)
      })

    let didTapEraseAllHistoryButton = input.eraseAllHistoryButtonTap

          return Output(
            didChangedSearchViewMode: didChangedSearchViewMode,
            didTapEraseAllHistoryButton: didTapEraseAllHistoryButton,
            textFieldControlEvent: Observable.merge(didBeginTextFieldEditing,
                                                    didEndTextFieldEditing))
    }
}
