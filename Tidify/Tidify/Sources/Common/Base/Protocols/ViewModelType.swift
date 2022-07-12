//
//  ViewModelType.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/27.
//

import Foundation

protocol ViewModelType {

  // MARK: - Structure TYpe

  associatedtype Input
  associatedtype Output

  // MARK: - Methods

  func transform(_ input: Input) -> Output
}
