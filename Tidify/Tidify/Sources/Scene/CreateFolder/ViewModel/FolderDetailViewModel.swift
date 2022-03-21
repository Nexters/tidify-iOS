//
//  FolderDetailViewModel.swift
//  Tidify
//
//  Created by 한상진 on 2022/03/21.
//

import RxCocoa
import RxSwift

class FolderDetailViewModel: ViewModelType {

  // MARK: - Properties

  struct Input {
  }

  struct Output {
    let didReceiveBookMarks: Driver<Void>
  }

  let lastIndexSubject = PublishSubject<Int>()
  var lastIndex: Int = 0

  var bookMarkList: BehaviorRelay<[BookMark]> = BehaviorRelay<[BookMark]>(value: [
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
      tag: "tag222")
  ])

  func transform(_ input: Input) -> Output {

      // 폴더 리스트 가져오기
      let didReceiveBookMarks = Driver.just(())

      return Output(didReceiveBookMarks: didReceiveBookMarks)
  }
}
