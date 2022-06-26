//
//  WebViewModel.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/11.
//

import Foundation

final class WebViewViewModel: ViewModelType {

  // MARK: - Properties
  var bookMarkURLString: String = ""

  init(_ urlString: String) {
    self.bookMarkURLString = urlString
  }

  struct Input {

  }

  struct Output {

  }

  // MARK: - Methods

  func transform(_ input: Input) -> Output {
    return Output()
  }
}
