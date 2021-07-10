//
//  UITableView+.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation
import UIKit

public extension UITableView {
    func t_registerCellClass(cellType: UITableViewCell.Type) {
        let identifier: String = "\(cellType)"
        register(cellType, forCellReuseIdentifier: identifier)
    }

    func t_registerHeaderFooterClass(viewType: UITableViewHeaderFooterView.Type) {
        let identifier: String = "\(viewType)"
        register(viewType, forHeaderFooterViewReuseIdentifier: identifier)
    }

    func t_dequeueReusableCell<T: UITableViewCell>(cellType: T.Type = T.self, indexPath: IndexPath) -> T {
        return dequeueReusableCell(withIdentifier: "\(cellType)", for: indexPath) as! T
    }

    func t_dequeueReusableHeaderFooterView<T: UITableViewHeaderFooterView>(viewType: T.Type = T.self) -> T {
        return dequeueReusableHeaderFooterView(withIdentifier: "\(viewType)") as! T
    }
}
