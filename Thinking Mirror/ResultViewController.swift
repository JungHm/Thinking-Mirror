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
        callImageApi(image: imageData!, completionHandler: { [weak self] result in
            //guard let self = self else {return}
            
            switch result {
            case let .success(result):
                let index = result.info.faceCount
                print(result.faces[index-1].celebrity.value)
                print(result.faces[index-1].celebrity.confidence)
                
            case let .failure(error):
                debugPrint("failure \(error)")
            }
            
        })
    }
    
    
    func callImageApi(image: UIImage, completionHandler: @escaping (Result<CelebrityData, Error>)->Void ) {
        //post에 multipart로 헤더를 보내야해서 배웠던 거로는 안될 듯 더 찾아보자
        let simillarDetectURL = "https://openapi.naver.com/v1/vision/celebrity"
        let faceDetectURL = "https://openapi.naver.com/v1/vision/face"
        let boundary = UUID().uuidString
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data; boundary=\(boundary)",
            "X-Naver-Client-Id": "icqYQWDsFHfhnzJcr4TE",
            "X-Naver-Client-Secret": "-"
        ]

        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(image.jpegData(compressionQuality: 1.0)!, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
        }, to: simillarDetectURL, method: .post, headers: headers)
            .validate()
            .responseData(completionHandler: { response in
                switch response.result {
                case let .success(data):
                    do{
                        let decoder = JSONDecoder()
                        let result: CelebrityData = try decoder.decode(CelebrityData.self, from: data)
                        completionHandler(.success(result))
                    }
                    catch{
                        completionHandler(.failure(error))
                    }
                case let .failure(error):
                    completionHandler(.failure(error))
                }
            })
    }
}
