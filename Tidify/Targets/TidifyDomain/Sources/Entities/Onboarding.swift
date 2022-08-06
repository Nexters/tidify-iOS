//
//  Onboarding.swift
//  TidifyDomain
//
//  Created by Ian on 2022/08/06.
//  Copyright © 2022 Tidify. All rights reserved.
//

import UIKit

public struct Onboarding {
  public private(set) var image: UIImage
  public private(set) var buttonTitle: String

  public init(image: UIImage, buttonTitle: String) {
    self.image = image
    self.buttonTitle = buttonTitle
  }
}
