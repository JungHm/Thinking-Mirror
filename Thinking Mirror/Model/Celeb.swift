//
//  Celeb.swift
//  Thinking Mirror
//
//  Created by 안정흠 on 2022/03/20.
//

import Foundation

struct CelebrityData: Codable {
    let info: Info
    let faces: [Faces]
}

struct Info: Codable {
    let faceCount: Int
}

struct Faces: Codable {
    let celebrity: Celebrity
}

struct Celebrity: Codable {
    let value: String
    let confidence: Double
}
