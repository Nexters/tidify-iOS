//
//  Environment.swift
//  Tidify
//
//  Created by 여정수 on 2021/07/10.
//

import Foundation

class Environment {

    // MARK: - Properties

    static let shared = Environment()

    let baseURL: String = "https://tidify.herokuapp.com"

    var authorization: String = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpZCI6MiwiZW1haWwiOiJkdXdqZHRuMTFAbmF2ZXIuY29tIiwibmFtZSI6Ilx1YzVlY1x1YzgxNVx1YzIxOCIsInByb2ZpbGVfaW1nIjoiaHR0cDovL2sua2FrYW9jZG4ubmV0L2RuL2JuM3ZUNC9idHEybHFXWW1Zdy84SHc3T3o3SFlmOFA0ckFrSmhINzcwL2ltZ182NDB4NjQwLmpwZyIsInNuc190eXBlIjoia2FrYW8ifQ.BNXBq2-6ucYjJd-qWdX5nVhi3tDvkql-jTCfHBJvs-c"

    private init() { }
}
