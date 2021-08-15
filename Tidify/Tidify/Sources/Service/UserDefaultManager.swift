//
//  UserDefaultManager.swift
//  Tidify
//
//  Created by 여정수 on 2021/08/15.
//

import Foundation
import UIKit

enum UserDefaultManager: String {

    // MARK: - Keys

    case userImageData = "User.image.data"
    case userNameString = "User.name.string"

    // MARK: - Methods

    static func getProfileImage() -> UIImage? {
        guard let data = UserDefaults.standard.data(forKey: Self.userImageData.rawValue) else {
            return nil
        }

        return UIImage(data: data)
    }
}
