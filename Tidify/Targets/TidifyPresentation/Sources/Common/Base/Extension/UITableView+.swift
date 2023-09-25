//
//  UITableView+.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

// MARK: - UITableView Extension
public extension UITableView {
  func t_registerCellClass(cellType: UITableViewCell.Type) {
    let identifier: String = "\(cellType)"
    register(cellType, forCellReuseIdentifier: identifier)
  }

  func t_registerCellClasses(_ cellTypes: [UITableViewCell.Type]) {
    cellTypes.forEach {
      let identifier: String = "\($0)"
      register($0, forCellReuseIdentifier: identifier)
    }
  }

  func t_registerHeaderFooterClass(viewType: UITableViewHeaderFooterView.Type) {
    let identifier: String = "\(viewType)"
    register(viewType, forHeaderFooterViewReuseIdentifier: identifier)
  }

  // swiftlint:disable force_cast
  func t_dequeueReusableCell<T: UITableViewCell>(cellType: T.Type = T.self, indexPath: IndexPath) -> T {
    return dequeueReusableCell(withIdentifier: "\(cellType)", for: indexPath) as! T
  }

  func t_dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(viewType: T.Type = T.self) -> T {
    return dequeueReusableHeaderFooterView(withIdentifier: "\(viewType)") as! T
  }
}
