//
//  FaceData.swift
//  Thinking Mirror
//
//  Created by 안정흠 on 2022/03/27.
//

import Foundation

struct FaceData: Codable {
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

