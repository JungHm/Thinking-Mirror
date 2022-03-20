//
//  ResultViewController.swift
//  Thinking Mirror
//
//  Created by 안정흠 on 2022/03/12.
//

import UIKit
import Alamofire

class ResultViewController: ViewController {
    var imageData: UIImage? //api 파라미터 데이터
    
    override func viewDidLoad() {
        super.viewDidLoad()
        callImageApi(image: imageData!)
    }
    
    func callImageApi(image: UIImage) {
        //post에 multipart로 헤더를 보내야해서 배웠던 거로는 안될 듯 더 찾아보자
        let simillarDetectURL = "https://openapi.naver.com/v1/vision/celebrity"
        let faceDetectURL = "https://openapi.naver.com/v1/vision/face"
        let boundary = UUID().uuidString
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data; boundary=\(boundary)",
            "X-Naver-Client-Id": "icqYQWDsFHfhnzJcr4TE",
            "X-Naver-Client-Secret": "tEc_NLXvko"
        ]

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image.jpegData(compressionQuality: 1.0)!, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
//            multipartFormData.append(Data("form-data".utf8), withName: "Content-Disposition")
//            multipartFormData.append(Data("image".utf8), withName: "name")
//            multipartFormData.append(Data("file.jpg".utf8), withName: "filename")
//            multipartFormData.append(Data("image/jpeg".utf8), withName: "Content-Type")

        }, to: simillarDetectURL, method: .post, headers: headers)
            .validate()
            .responseData(completionHandler: { response in
                print(data)
            })
    }
}
