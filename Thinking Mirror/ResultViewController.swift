//
//  ResultViewController.swift
//  Thinking Mirror
//
//  Created by 안정흠 on 2022/03/12.
//

import UIKit
import Alamofire

class ResultViewController: ViewController {
    
    @IBOutlet weak var ConfidenceLabel: UILabel!
    @IBOutlet weak var CelebLabel: UILabel!
    @IBOutlet weak var resultView: UIImageView!
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if image == nil {
            resultView.image = UIImage(systemName: "x.circle.fill")
            let alert = UIAlertController(title: "Error", message: "이미지가 없습니다.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
            return
        }
        resultView.image = image
        callImageApi(image: image!, completionHandler: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case let .success(result):
                let index = result.info.faceCount
                self.configureLabel(celeb: result.faces[index-1].celebrity.value, confidence: result.faces[index-1].celebrity.confidence)
            case let .failure(error):
                debugPrint("failure <\(error.asAFError.debugDescription)>")
            }
        })
        
    }
    
    func configureLabel(celeb: String, confidence: Double){
        CelebLabel.text = celeb
        ConfidenceLabel.text = "\(confidence*100)%"
    }
    
    func callImageApi(image: UIImage, completionHandler: @escaping (Result<CelebrityData, Error>)->Void ) {
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
        }, to: simillarDetectURL, method: .post, headers: headers)
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
