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
    
    let faceDetectURL = "https://openapi.naver.com/v1/vision/face"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        indicator.startAnimating()
    }
}
