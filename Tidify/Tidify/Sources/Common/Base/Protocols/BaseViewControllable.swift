//
//  BaseViewControllable.swift
//  Tidify
//
//  Created by Ian on 2022/03/24.
//

import RxSwift

protocol BaseViewControllable {
  var disposeBag: DisposeBag { get set }

  func setupViews()
  func setupLayoutConstraints()
  func bindOutput()
}
