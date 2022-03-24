//
//  ResultViewController.swift
//  Thinking Mirror
//
//  Created by 안정흠 on 2022/03/12.
//

import UIKit
import Alamofire

class CelebResultViewController: UIViewController {
    
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    @IBOutlet weak var ConfidenceLabel: UILabel!
    @IBOutlet weak var CelebLabel: UILabel!
    @IBOutlet weak var resultView: UIImageView!
    var image:UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating() //API 응답 받기 전 까지 indicator 실행
        if image == nil { //넘어온 이미지가 없다면 예외처리.
            resultView.image = UIImage(systemName: "x.circle.fill")
            errorAlert(message: "이미지가 없습니다..")
            return
        }
        resultView.image = image //이미지 넘겨받고 API 호출
        callImageApi(image: image!, completionHandler: { [weak self] result in
            guard let self = self else {return}
            switch result {
            case let .success(result):
                self.configureLabel(result: result)
            case let .failure(error):
                self.errorAlert(message: error.localizedDescription)
            }
        })
        
    }
    
    func configureLabel(result: CelebrityData){
        if result.info.faceCount < 1 {
            errorAlert(message: "얼굴이 검출되지 않았습니다.")
            indicator.stopAnimating()
            return
        }
        
        CelebLabel.text = result.faces[0].celebrity.value
        ConfidenceLabel.text = "\(result.faces[0].celebrity.confidence*100)%"
        
        indicator.stopAnimating()
        indicator.isHidden = true
        CelebLabel.isHidden = false
        ConfidenceLabel.isHidden = false
        
    }
    
    func errorAlert(message: String) { //Exception 설명 Alert
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func callImageApi(image: UIImage, completionHandler: @escaping (Result<CelebrityData, Error>)->Void ) {
        let simillarDetectURL = "https://openapi.naver.com/v1/vision/celebrity"
        let faceDetectURL = "https://openapi.naver.com/v1/vision/face"
        //boundary 꼭 필요없음. Alamofire에서 기본적으로 찍혀서 나옴
        let headers: HTTPHeaders = [
            "Content-type": "multipart/form-data",
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
