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
    
    // MARK: Networking
    private func requestAPI(image: UIImage) {
        indicator.startAnimating()
        
        APIManager.sharedObject.celebrityAPI(uploadImage: image, completion: { result in
            self.indicator.stopAnimating()
            self.indicator.isHidden = true
            self.configureLabel(result: result)
        })
    }
    
    // MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let image = image else {
            resultView.image = UIImage(systemName: "x.circle.fill")
            errorAlert(message: "이미지가 없습니다..")
            return
        }
        requestAPI(image: image)
        resultView.image = image
    }
    
    // MARK: UI
    private func configureLabel(result: Response<CelebrityData>){
        if result.info.faceCount < 1 {
            errorAlert(message: "얼굴이 검출되지 않았습니다.")
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
