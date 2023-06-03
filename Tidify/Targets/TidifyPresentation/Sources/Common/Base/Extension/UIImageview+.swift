//
//  UIImageview+.swift
//  TidifyPresentation
//
//  Created by 여정수 on 2023/05/20.
//  Copyright © 2023 Tidify. All rights reserved.
//

import UIKit

import Kingfisher

extension UIImageView {
  func setImage(with urlString: String) {
    ImageCache.default.retrieveImage(forKey: urlString) { result in
      switch result {
      case .success(let cacheResult):
        if let image = cacheResult.image {
          self.image = image
        } else {
          DispatchQueue.global(qos: .userInteractive).async { [weak self] in
            guard let url = URL(string: urlString), let _ = try? Data(contentsOf: url) else {
              DispatchQueue.main.async {
                self?.image = .symbolImage
              }
              return
            }

            let resource = ImageResource(downloadURL: url, cacheKey: urlString)
            DispatchQueue.main.async {
              self?.kf.setImage(with: resource)
            }
          }
        }

      case .failure:
        self.image = .symbolImage
      }
    }
  }
}
