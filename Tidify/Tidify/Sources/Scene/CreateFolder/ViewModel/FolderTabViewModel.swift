//
//  FolderTabViewModel.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/21.
//

import Foundation
import RxCocoa
import RxSwift

class FolderTabViewModel: ViewModelType {

    // MARK: - Properties

    struct Input {

    }

    struct Output {
        let didReceiveFolders: Driver<Void>
    }

    var folderList: [Folder] = []

    func transform(_ input: Input) -> Output {

        // 폴더 리스트 가져오기
        let didReceiveFolders = Driver.just(())

        return Output(didReceiveFolders: didReceiveFolders)
    }
}
