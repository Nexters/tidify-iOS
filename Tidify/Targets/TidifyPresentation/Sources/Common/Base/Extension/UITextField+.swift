//
//  UITextField+.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2023/11/22.
//  Copyright © 2023 Tidify. All rights reserved.
//

import Combine
import UIKit

extension UITextField {
  var publisher: AnyPublisher<String, Never> {
    NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: self)
      .compactMap { $0.object as? UITextField }
      .map { $0.text ?? "" }
      .eraseToAnyPublisher()
  }
}
