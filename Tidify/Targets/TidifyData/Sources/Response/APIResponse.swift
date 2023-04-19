//
//  APIResponse.swift
//  TidifyData
//
//  Created by Ian on 2022/09/04.
//  Copyright © 2022 Tidify. All rights reserved.
//

public struct APIResponse: Decodable {
  enum ResponseCode: String {
    case success = "200"
  }

  // MARK: - Properties
  let code: String
  let message: String

  var isSuccess: Bool {
    code == ResponseCode.success.rawValue
  }

  enum CodingKeys: String, CodingKey {
    case code, message
  }

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    code = try container.decode(String.self, forKey: .code)
    message = try container.decode(String.self, forKey: .message)
  }
}
