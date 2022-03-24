//
//  CreateFolderViewModel.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/21.
//

import Foundation
import RxCocoa
import RxSwift
import UIKit

class CreateFolderViewModel: ViewModelType {

  // MARK: - Properties

  let dataSource: [UIColor] = [UIColor.t_tidiBlue(),
                               UIColor.t_indigo(),
                               UIColor.t_tidiBlue2(),
                               UIColor.systemRed,
                               UIColor.systemOrange,
                               UIColor.systemYellow,
                               UIColor.systemPink,
                               UIColor.systemGreen,
                               UIColor.black,
                               UIColor.systemGray]

  struct Input {
    let folderNameText: Driver<String>
    let folderLabelColor: Driver<String>
    let saveButtonTap: Driver<Void>
  }

  struct Output {
    let didTapSaveButton: Driver<Void>
    let saveButtonStatus: Driver<Bool>
  }

  func transform(_ input: Input) -> Output {
    let folderNameAndColor = Driver.combineLatest(input.folderNameText,
                                                  input.folderLabelColor) { ($0, $1) }

    let didTapSaveButton = input.saveButtonTap
      .withLatestFrom(folderNameAndColor)
      .flatMapLatest { folderName, folderColor -> Driver<Void> in
        // 폴더 등록 API 호출
        return .just(())
      }

    let saveButtonStatus = folderNameAndColor.map {
      return !$0.isEmpty && !$1.isEmpty
    }.t_asDriverSkipError()

    return Output(didTapSaveButton: didTapSaveButton, saveButtonStatus: saveButtonStatus)
  }
}
