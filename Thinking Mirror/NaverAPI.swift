//
//  NaverAPI.swift
//  Thinking Mirror
//
//  Created by 안정흠 on 2022/03/23.
//

import Alamofire

class APIManager {
    static var sharedObject = APIManager()
    
    private let simillarDetectURL = "https://openapi.naver.com/v1/vision/celebrity"
    private let faceDetectURL = "https://openapi.naver.com/v1/vision/face"
    private let headers: HTTPHeaders = [
        "Content-type": "multipart/form-data",
        "X-Naver-Client-Id": "icqYQWDsFHfhnzJcr4TE",
        "X-Naver-Client-Secret": "tEc_NLXvko"
    ]
    
    func faceDetectAPI() -> CelebrityData?{
        return nil
    }
}

//struct NaverAPI {
//
//
//    AF.upload(multipartFormData: { multipartFormData in
//        multipartFormData.append(image.jpegData(compressionQuality: 1.0)!, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
//    }, to: simillarDetectURL, method: .post, headers: headers)
//        .responseData(completionHandler: { response in
//            switch response.result {
//            case let .success(data):
//                do{
//                    let decoder = JSONDecoder()
//                    let result: CelebrityData = try decoder.decode(CelebrityData.self, from: data)
//                    completionHandler(.success(result))
//                }
//                catch{
//                    completionHandler(.failure(error))
//                }
//            case let .failure(error):
//                completionHandler(.failure(error))
//            }
//        })
//}
