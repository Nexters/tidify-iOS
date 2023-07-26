//
//  SettingRepository.swift
//  TidifyDomain
//
//  Created by 한상진 on 2023/05/05.
//  Copyright © 2023 Tidify. All rights reserved.
//

public protocol SettingRepository: AnyObject {
  func signOut() async throws
}
