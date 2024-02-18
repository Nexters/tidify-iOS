//
//  AppScheme.swift
//  TidifyPresentation
//
//  Created by 여정수 on 2/18/24.
//  Copyright © 2024 Tidify. All rights reserved.
//

import Foundation

public enum AppScheme {
  case shareFolder(id: Int)
}

extension AppScheme {
  public static func handleScheme(_ url: URL) {
    guard let queryItem = URLComponents(string: url.absoluteString)?.queryItems?.first else {
      return
    }

    switch queryItem.name {
    case "folderID":
      if let stringID = queryItem.value, let id = Int(stringID) {
        // TODO: FolderDetailCoordinator에서 folderID를 받는 인터페이스가 구현되면 마저 연결한다.
        print(id)
      }
    default:
      return
    }
  }

  private static var baseScheme: String {
    return "tidify"
  }

  public static func isOwnScheme(_ url: URL) -> Bool {
    url.scheme == Self.baseScheme
  }

  private var host: String {
    switch self {
    case .shareFolder:
      return "shareFolder?"
    }
  }

  var fullScheme: String {
    switch self {
    case .shareFolder(let id):
      return Self.baseScheme + "://" + host + "folderID=" + "\(id)"
    }
  }
}
