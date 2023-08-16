//
//  UserRepository.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/07/27.
//  Copyright © 2023 Tidify. All rights reserved.
//

public protocol UserRepository: AnyObject {
  func appleLogin(token: String) async throws -> UserToken
  func kakaoLogin() async throws -> UserToken
  func signOut() async throws
}
