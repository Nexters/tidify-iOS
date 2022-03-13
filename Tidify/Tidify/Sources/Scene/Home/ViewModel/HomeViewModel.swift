//
//  HomeViewModel.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import RxCocoa
import RxSwift
import SwiftLinkPreview

protocol HomeViewModelDelegate: AnyObject {
    func pushRegisterView()
    func pushWebView(_ url: String)
}

class HomeViewModel: ViewModelType {

    // MARK: - Properties
    let imagePlaceholder = "https://via.placeholder.com/150"
    let swiftLinkPreview = SwiftLinkPreview()

    struct Input {
        let didSwipeBookMarkCell: Driver<BookMarkCellSwipeOption>
        let didTapCell: Driver<BookMark>
    }

    struct Output {
        let didReceiveBookMarks: Driver<Void>
        let didTapCell: Driver<Void>
    }

    weak var delegate: HomeViewModelDelegate?

    var bookMarkList: [BookMark] = []

    // MARK: - Methods

    func transform(_ input: Input) -> Output {
        let didReeceiveBookMakrs = Driver.just(())
            .flatMapLatest { _ -> Driver<[BookMark]> in
                return APIProvider.request(BookMarkAPI.getBookMarkList(id: 1))
                    .map(BookMarkListDTO.self)
                    .map { $0.bookMarks.map { $0.toEntity() } }
                    .t_asDriverSkipError()
            }
            .do(onNext: {
                self.bookMarkList = $0
            })
            .map { _ in }

        let didTapCell = input.didTapCell
            .do(onNext: { [weak self] in
                self?.delegate?.pushWebView($0.urlString ?? "")
            })
            .map { _ in }

        return Output(didReceiveBookMarks: didReeceiveBookMakrs,
                      didTapCell: didTapCell)
    }
}
