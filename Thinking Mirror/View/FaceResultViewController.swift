//
//  FaceResultViewController.swift
//  Thinking Mirror
//
//  Created by 안정흠 on 2022/03/23.
//

import UIKit

class FaceResultViewController: UIViewController {
    
    @IBOutlet weak var emotionLabel: UILabel!
    @IBOutlet weak var ageLabel: UILabel!
    @IBOutlet weak var genderLabel: UILabel!
    
    @IBOutlet weak var resultImage: UIImageView!
    @IBOutlet weak var indicator: UIActivityIndicatorView!
    
    private let faceDetectURL = "https://openapi.naver.com/v1/vision/face"
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
        resultImage.image = image
        APIManager.sharedObject.faceAPI(uploadImage: image!, completion: { [weak self] result in
            switch result {
            case let .success(result):
                self?.configureLabel(result: result)
            case let .failure(error):
                self?.errorAlert(message: error.localizedDescription)
            }
        })
    }
    
    private func configureLabel(result: FaceData){
        if result.info.faceCount < 1 {
            errorAlert(message: "얼굴이 검출되지 않았습니다.")
            indicator.stopAnimating()
            return
        }
        
        emotionLabel.text = result.faces[0].emotion.value
        ageLabel.text = result.faces[0].age.value
        genderLabel.text = result.faces[0].gender.value
        
        indicator.stopAnimating()
        indicator.isHidden = true
        
        emotionLabel.isHidden = false
        ageLabel.isHidden = false
        genderLabel.isHidden = false
    }
    
    private func errorAlert(message: String) { //Exception 설명 Alert
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
