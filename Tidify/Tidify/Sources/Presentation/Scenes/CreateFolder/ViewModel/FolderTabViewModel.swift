//
//  FolderTabViewModel.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/21.
//

import Foundation
import RxCocoa
import RxSwift

final class FolderTabViewModel: ViewModelType {

  // MARK: - Properties

  struct Input {
  }

  struct Output {
    let didReceiveFolders: Driver<Void>
  }

  let lastIndexSubject = PublishSubject<Int>()
  var lastIndex: Int = 0

  var folderListRelay: BehaviorRelay<[Folder]> = BehaviorRelay<[Folder]>(value: [
    Folder(name: "테스트폴더0", color: "#ff9500"),
    Folder(name: "테스트폴더1", color: "#ff2d54"),
    Folder(name: "테스트폴더2", color: "#ff9500"),
    Folder(name: "테스트폴더3", color: "#ff2d54"),
    Folder(name: "테스트폴더4", color: "#ff9500"),
    Folder(name: "테스트폴더5", color: "#ff2d54"),
    Folder(name: "테스트폴더6", color: "#ff9500"),
    Folder(name: "테스트폴더7", color: "#ff2d54"),
    Folder(name: "테스트폴더8", color: "#ff9500"),
    Folder(name: "테스트폴더9", color: "#ff2d54"),
    Folder(name: "테스트폴더10", color: "#ff9500")
  ])

  func transform(_ input: Input) -> Output {

    // 폴더 리스트 가져오기
    let didReceiveFolders = Driver.just(())

    return Output(didReceiveFolders: didReceiveFolders)
  }
}
