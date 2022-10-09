//
//  APIResponse.swift
//  TidifyData
//
//  Created by Ian on 2022/09/04.
//  Copyright © 2022 Tidify. All rights reserved.
//

public struct APIResponse: Decodable {

  // MARK: - Properties
  let code: String
  let message: String

  enum CodingKeys: String, CodingKey {
    case code = "result_code"
    case message = "result_message"
  }
}