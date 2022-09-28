//
//  NaverAPI.swift
//  Thinking Mirror
//
//  Created by 안정흠 on 2022/03/23.
//
import Foundation
import Alamofire

class APIManager {
    static var sharedObject = APIManager()
    
    private let headers: HTTPHeaders = [
        "Content-type": "multipart/form-data",
        "X-Naver-Client-Id": "icqYQWDsFHfhnzJcr4TE",
        "X-Naver-Client-Secret": "tEc_NLXvko"
    ]
    // 유명인 닮은꼴 검출
    func celebrityAPI(uploadImage: UIImage, completion: @escaping (Response<CelebrityData>)->Void ) {
        let url = APIInfo.hostInfo + APIList.celebrity
        
        uploadRequest(url: url, uploadImage: uploadImage).responseData(completionHandler: { response in
            switch response.result {// response.result를 써야 Result<value, error> type을 사용할 수 있다.
            case let .success(data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(Response<CelebrityData>.self, from: data)
                    completion(result)
                } catch {
                    //이건 몰까...
                    print("\(#file.split(separator: "/").last!)-\(#function)[\(#line)]")
                }
            case let .failure(error):
                print("\(error) \(#file.split(separator: "/").last!)-\(#function)[\(#line)]")
            }
        })
    }
    // 나이 성별 검출
    func faceAPI(uploadImage: UIImage, completion: @escaping (Response<FaceData>)->Void ){
        let url = APIInfo.hostInfo + APIList.face
        
        uploadRequest(url: url, uploadImage: uploadImage).responseData(completionHandler: { response in
            switch response.result {
            case let .success(data):
                do {
                    let decoder = JSONDecoder()
                    let result = try decoder.decode(Response<FaceData>.self, from: data)
                    completion(result)
                } catch {
                    print("\(#file.split(separator: "/").last!)-\(#function)[\(#line)]")
                }
            case let .failure(error):
                print("\(error) \(#file.split(separator: "/").last!)-\(#function)[\(#line)]")
            }
        })
    }
    // 한 번에 처리하고 싶은데 decode&Result에 들어갈 data type을 어떻게 해야할 지 모르겠다.
    // template로 하더라도 유추할 수 있는 부분이 없움... 파라미터에 따로 넘겨줘야하나?
    // enum option으로 api선택을 하고 그거에 맞게 넘기면 되지 않을까?
    func allAPI<T: Decodable>(url: String, uploadImage: UIImage, completion: @escaping (Response<T>)->Void) {
        
    }
}

extension APIManager {
    private func uploadRequest(url: String, uploadImage: UIImage) -> UploadRequest {
            return AF.upload(multipartFormData: { multipartFormData in
                multipartFormData.append(uploadImage.jpegData(compressionQuality: 1.0)!, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
            }, to: url, method: .post, headers: headers)
    }
}
