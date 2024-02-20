//
//  FolderCategoryButton.swift
//  TidifyPresentation
//
//  Created by 한상진 on 2024/02/21.
//  Copyright © 2024 Tidify. All rights reserved.
//

import Combine
import TidifyDomain
import UIKit

final class FolderCategoryButton: UIButton {

  // MARK: Properties
  private let category: FolderCategory

  private var title: String {
    switch category {
    case .normal: return "폴더"
    case .subscribe: return "구독"
    case .share: return "공유중"
    }
  }

  var tapPublisherWithCategory: AnyPublisher<FolderCategory, Never> {
    tapPublisher
      .withUnretained(self)
      .map { (owner, _) in owner.category }
      .eraseToAnyPublisher()
  }

  // MARK: Initializer
  init(category: FolderCategory) {
    self.category = category
    super.init(frame: .zero)

    setTitleColor(.t_ashBlue(weight: category == .normal ? 800 : 300), for: .normal)
    titleLabel?.font = .t_EB(22)
    setTitle(title, for: .normal)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
}
