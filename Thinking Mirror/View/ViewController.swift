//
//  ViewController.swift
//  Thinking Mirror
//
//  Created by 안정흠 on 2022/03/08.
//

import UIKit

enum PickerMode {
    case camera
    case album
}

class ViewController: UIViewController {
    
    @IBOutlet weak var apiListStack: UIStackView!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var celebDetectButton: UIButton!
    @IBOutlet weak var faceDetectButton: UIButton!
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showApiList(_ sender: Any) {
        blurAnimation(alpha: 1, duration: 0.3)
    }
    //닮은 연예인 API 호출, 뷰 이동
    @IBAction func celebDetectCall(_ sender: Any) {
        blurAnimation(alpha: 0, duration: 0.3)
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "CelebResultViewController") as? CelebResultViewController else { return }
        vc.image = imageView.image
        navigationController?.pushViewController(vc, animated: true)
    }
    //추정 나이 API 호출, 뷰 이동
    @IBAction func faceDetectCall(_ sender: Any) {
        blurAnimation(alpha: 0, duration: 0.3)
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "FaceResultViewController") as? FaceResultViewController else { return }
        vc.image = imageView.image
        navigationController?.pushViewController(vc, animated: true)
    }
    //이미지 업로드 버튼
    @IBAction func tapSendImage(_ sender: Any) {
        let alert = UIAlertController()
        //사진 찍어서 넘길 때 보이지 않는 이슈 때문에 임시 주석
        //        alert.addAction(UIAlertAction(title: "카메라", style: .default, handler: {[weak self] _ in
        //            let pickerTemp = self?.configurePicker(pickermode: .camera)
        //            if let picker = pickerTemp {
        //                self?.present(picker, animated: true, completion: nil)
        //            }
        //        }))
        alert.addAction(UIAlertAction(title: "앨범", style: .default, handler: {[weak self] _ in
            let pickerTemp = self?.configurePicker(pickermode: .album)
            if let picker = pickerTemp {
                self?.present(picker, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    //사진 업로드 방법
    private func configurePicker(pickermode: PickerMode) -> UIImagePickerController {
        let picker = UIImagePickerController()
        switch(pickermode) {
        case .camera:
            picker.sourceType = .camera
            picker.cameraFlashMode = .off
        case .album:
            picker.sourceType = .photoLibrary
        }
        picker.delegate = self
        return picker
    }
    // API 선택 화면 Animation
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        blurAnimation(alpha: 0, duration: 0.3)
    }
    
    private func blurAnimation(alpha: CGFloat, duration: TimeInterval) {
        UIView.animate(withDuration: duration) { //Duration에 따라 점차 애니매이션 적용됨.
            self.blurView.alpha = alpha
            self.apiListStack.alpha = alpha
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[.originalImage] as? UIImage {
            //선택된 이미지를 불러와서 표시
            imageView.image = image
            sendButton.isHidden = false
        }
        picker.dismiss(animated: true, completion: nil)
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        // camera화면에서 cancel을 눌렀을 때 발생하는 함수
        picker.dismiss(animated: true, completion: nil)
    }
}
