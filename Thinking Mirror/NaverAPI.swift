//
//  NaverAPI.swift
//  Thinking Mirror
//
//  Created by 안정흠 on 2022/03/23.
//

import Alamofire
import Foundation

class APIManager {
    static var sharedObject = APIManager()
    
    private let headers: HTTPHeaders = [
        "Content-type": "multipart/form-data",
        "X-Naver-Client-Id": "icqYQWDsFHfhnzJcr4TE",
        "X-Naver-Client-Secret": "tEc_NLXvko"
    ]
    
    func CelebAPI(uploadImage: UIImage,completion: @escaping (Result<CelebrityData, Error>)->Void ) {
        let url = "https://openapi.naver.com/v1/vision/celebrity"
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(uploadImage.jpegData(compressionQuality: 1.0)!, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: url, method: .post, headers: headers).responseData(completionHandler: { response in
            switch response.result {// response.result를 써야 Result<value, error> type을 사용할 수 있다.
            case let .success(data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(CelebrityData.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    
    func faceAPI(uploadImage: UIImage,completion: @escaping (Result<FaceData, Error>)->Void ){
        let url = "https://openapi.naver.com/v1/vision/face"
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(uploadImage.jpegData(compressionQuality: 1.0)!, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: url, method: .post, headers: headers).responseData(completionHandler: { response in
            switch response.result {// response.result를 써야 Result<value, error> type을 사용할 수 있다.
            case let .success(data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(FaceData.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
    // 한 번에 처리하고 싶은데 decode&Result에 들어갈 data type을 어떻게 해야할 지 모르겠다.
    // template로 하더라도 유추할 수 있는 부분이 없움... 파라미터에 따로 넘겨줘야하나?
    // enum option으로 api선택을 하고 그거에 맞게 넘기면 되지 않을까?
    func CFGAPI<T: Decodable>(url: String, uploadImage: UIImage,completion: @escaping (Result<T, Error>)->Void ) {
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(uploadImage.jpegData(compressionQuality: 1.0)!, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: url, method: .post, headers: headers).responseData(completionHandler: { response in
            switch response.result {// response.result를 써야 Result<value, error> type을 사용할 수 있다.
            case let .success(data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(T.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        })
    }
}
