//
//  DefaultResponse.swift
//  TidifyData
//
//  Created by 한상진 on 2022/11/07.
//  Copyright © 2022 Tidify. All rights reserved.
//

struct DefaultResponse: Decodable {
  let apiResponse: APIResponse
  
  enum CodingKeys: String, CodingKey {
    case apiResponse = "api_response"
  }
}
