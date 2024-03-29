//
//  UICollectionView+.swift
//  TidifyPresentation
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

// MARK: - UICollectionView Extension
public extension UICollectionView {
  func t_registerCellClass(cellType: UICollectionViewCell.Type) {
    let identifer: String = "\(cellType)"
    register(cellType, forCellWithReuseIdentifier: identifer)
  }

  func t_registerHeaderClass(viewType: UICollectionReusableView.Type) {
    let identifier: String = "\(viewType)"
    register(viewType, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: identifier)
  }

  func t_registerFooterClass(viewType: UICollectionReusableView.Type) {
    let identifier: String = "\(viewType)"
    register(viewType, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: identifier)
  }

  // swiftlint:disable force_cast
  func t_dequeueReusableCell<T: UICollectionViewCell>(cellType: T.Type = T.self, indexPath: IndexPath) -> T {
    return dequeueReusableCell(withReuseIdentifier: "\(cellType)", for: indexPath) as! T
  }

  func t_dequeueReusableHeader<T: UICollectionReusableView>(viewType: T.Type = T.self, indexPath: IndexPath) -> T {
    return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(viewType)", for: indexPath) as! T
  }

  func t_dequeueReusableFooter<T: UICollectionReusableView>(viewType: T.Type = T.self, indexPath: IndexPath) -> T {
    return dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: "\(viewType)", for: indexPath) as! T
  }
}
