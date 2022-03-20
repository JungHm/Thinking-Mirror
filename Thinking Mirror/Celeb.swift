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
//    let size: Size
    let faceCount: Int
}

//struct Size: Codable {
//    let width: Int
//    let height: Int
//}

struct Faces: Codable {
    let celebrity: Celebrity
}

struct Celebrity: Codable {
    let value: String
    let confidence: Double
}
