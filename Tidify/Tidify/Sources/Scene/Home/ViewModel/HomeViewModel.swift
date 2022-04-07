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
    let didTapCell: Driver<BookMark>
  }

  struct Output {
    let didReceiveBookMarks: Driver<Void>
    let didTapCell: Driver<Void>
  }

  weak var delegate: HomeViewModelDelegate?

  var bookMarkListRelay = BehaviorRelay<[BookMark]>(value: [
    BookMark(
      createdAt: "createdAt",
      updatedAt: "updatedAt",
      id: 0,
      memberId: 0,
      urlString: "https://www.google.com/",
      title: "구글",
      tag: "tag"),
    BookMark(
      createdAt: "createdAt222",
      updatedAt: "updatedAt222",
      id: 0,
      memberId: 0,
      urlString: "https://www.naver.com/",
      title: "네이버",
      tag: "tag222"),
    BookMark(
      createdAt: "createdAt222",
      updatedAt: "updatedAt222",
      id: 0,
      memberId: 0,
      urlString: "https://picsum.photos/200/300",
      title: "테스트북마크",
      tag: "tag222")
  ])

  let lastIndexSubject = PublishSubject<Int>()
  var lastIndex: Int = 0

  // MARK: - Methods

  func transform(_ input: Input) -> Output {
    //TODO: 서버 연동 후 수정 예정
    let didReceiveBookMarks = Driver.just(())
//      .flatMapLatest { _ -> Driver<[BookMark]> in
//        return APIProvider.request(BookMarkAPI.getBookMarkList(id: 1))
//          .map(BookMarkListDTO.self)
//          .map { $0.bookMarks.map { $0.toEntity() } }
//          .t_asDriverSkipError()
//      }
//      .do(onNext: {
//        self.bookMarkList = $0
//      })
//        .map { _ in }

    let didTapCell = input.didTapCell
      .do(onNext: { [weak self] in
        self?.delegate?.pushWebView($0.urlString ?? "")
      })
        .map { _ in }

    return Output(didReceiveBookMarks: didReceiveBookMarks,
                  didTapCell: didTapCell)
  }
}
