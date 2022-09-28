//
//  ApiData.swift
//  Thinking Mirror
//
//  Created by 안정흠 on 2022/09/28.
//

import Foundation

struct Response<T: Codable>: Codable {
    let info: Info
    let faces: [T]
}

struct Info: Codable {
    let faceCount: Int
}
