//
//  FaceData.swift
//  Thinking Mirror
//
//  Created by 안정흠 on 2022/03/27.
//

struct FaceData: Codable {
    let info: FaceInfo
    let faces: [FaceFaces]
}

struct FaceInfo: Codable {
    let faceCount: Int
}

struct FaceFaces: Codable {
    let gender: Gender
    let age: Age
    let emotion: Emotion
}

struct Gender: Codable {
    let value: String
    let confidence: Double
}
struct Age: Codable {
    let value: String
    let confidence: Double
}
struct Emotion: Codable {
    let value: String
    let confidence: Double
}
