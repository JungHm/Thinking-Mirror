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
    
    private let simillarDetectURL = "https://openapi.naver.com/v1/vision/celebrity"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating() //API 응답 받기 전 까지 indicator 실행
        if image == nil { //넘어온 이미지가 없다면 예외처리.
            resultView.image = UIImage(systemName: "x.circle.fill")
            errorAlert(message: "이미지가 없습니다..")
            return
        }
        resultView.image = image //이미지 넘겨받고 API 호출
        
        APIManager.sharedObject.CelebAPI(uploadImage: image!, completion: { [weak self] result in
            
            switch result {
            case let .success(result):
                self?.configureLabel(result: result)
            case let .failure(error):
                self?.errorAlert(message: error.localizedDescription)
            }
        })
    }
    
    private func configureLabel(result: CelebrityData){
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
    
    private func errorAlert(message: String) { //Exception 설명 Alert
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
}
