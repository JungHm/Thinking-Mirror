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
    
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func CallApi(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "ResultViewController") as? ResultViewController else { return }
        //image data 전송 해야함
        vc.image = imageView.image!
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func tapSendImage(_ sender: Any) {
        let alert = UIAlertController()
        alert.addAction(UIAlertAction(title: "카메라", style: .default, handler: {[weak self] _ in
            let pickerTemp = self?.configurePicker(pickermode: .camera)
            if let picker = pickerTemp {
                self?.present(picker, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "앨범", style: .default, handler: {[weak self] _ in
            let pickerTemp = self?.configurePicker(pickermode: .album)
            if let picker = pickerTemp {
                self?.present(picker, animated: true, completion: nil)
            }
        }))
        alert.addAction(UIAlertAction(title: "취소", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
        
        
    }
    
    func configurePicker(pickermode: PickerMode) -> UIImagePickerController {
        let picker = UIImagePickerController()
        switch(pickermode) {
        case .camera:
            picker.sourceType = .camera
        case .album:
            picker.sourceType = .photoLibrary
        }
        picker.delegate = self
        return picker
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
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {// camera화면에서 cancel을 눌렀을 때 발생하는 함수
        picker.dismiss(animated: true, completion: nil)
    }
}
