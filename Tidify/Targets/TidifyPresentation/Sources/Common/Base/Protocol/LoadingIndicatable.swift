//
//  LoadingIndicatable.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/12/06.
//  Copyright © 2023 Tidify. All rights reserved.
//

import UIKit

protocol LoadingIndicatable {
  var indicatorView: UIActivityIndicatorView { get set }
}

extension LoadingIndicatable where Self: UIViewController {
  func setIndicatorView(isLoading: Bool) {
    if isLoading {
      indicatorView.startAnimating()
    } else {
      indicatorView.isHidden = true
    }
  }
}
