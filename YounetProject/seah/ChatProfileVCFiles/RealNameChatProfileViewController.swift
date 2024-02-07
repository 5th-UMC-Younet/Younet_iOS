//
//  NickNameChatProfileViewController.swift
//  YounetProject
//
//  Created by 김세아 on 2/6/24.
//

import UIKit

class RealNameChatProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var textLimitLabel: UILabel!
    @IBOutlet weak var selfExplainTextView: UITextView!
    @IBOutlet weak var underLineView: UIView!
    
    @IBOutlet weak var univButton: UIButton!
    @IBOutlet weak var nationButton: UIButton!
    @IBOutlet weak var exUnivButton: UIButton!
    
    let textViewSample = "100자 이하의 소개글"
    let imgPicker = UIImagePickerController()
    let maxTextCount = 100
    var imageControllerCheck = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyboard()
        setKeyboardObserver()
        setTextViewPlaceholder()
        setDefaultData()
        
        imgPicker.delegate = self
        selfExplainTextView.delegate = self
        selfExplainTextView.isScrollEnabled = false
    
    }

    @IBAction func profileImageBtnDidtap(_ sender: UIButton) {
        imgPicker.sourceType = .photoLibrary
        present(imgPicker, animated: false, completion: nil)
    }

    // textView placeholder
    private func setTextViewPlaceholder() {
        if selfExplainTextView.text == "" {
            selfExplainTextView.text = textViewSample
            selfExplainTextView.textColor = #colorLiteral(red: 0.7725487351, green: 0.7725491524, blue: 0.7803917527, alpha: 1)
        } else if selfExplainTextView.text == textViewSample {
            selfExplainTextView.text = ""
            selfExplainTextView.textColor = UIColor.black
        }
    }
    
    private func setDefaultData() {
        if ImageFileManager.shared.getSavedImage(named: "profileImage_realName") != nil {
            profileImage.setImage(ImageFileManager.shared.getSavedImage(named: "profileImage_realName"), for: .normal)
        }
        imageControllerCheck = 0
        
        // 서버에서 데이터 받아와서 본교, 유학국, 교환교 버튼 setTitle
    }
    
    @IBAction func confirmButtonDidtap(_ sender: UIButton) {
        imageControllerCheck != 0 ? (ImageFileManager.shared.saveImage(image: profileImage.currentImage!, name: "profileImage_realName") { onSuccess in return } ) : nil
        selfExplainTextView.text != textViewSample ? UserDefaults.standard.setValue(selfExplainTextView.text, forKey: "selfExplain_realName") : nil
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonDidtap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension RealNameChatProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            profileImage.setImage(image, for: .normal)
            imageControllerCheck = 1
        }
        dismiss(animated: true, completion: nil)
    }
}

extension RealNameChatProfileViewController : UITextViewDelegate {
    // textView 편집 시작
    func textViewDidBeginEditing(_ textView: UITextView) {
        setTextViewPlaceholder()
        underLineView.backgroundColor = #colorLiteral(red: 0.3058094382, green: 0.4039391279, blue: 0.9215484262, alpha: 1)
    }
    // textView 편집 끝
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            setTextViewPlaceholder()
        }
        underLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
    }
    
    // TextView 글자수 제한
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let currentText = selfExplainTextView.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        let changedText = currentText.replacingCharacters(in: stringRange, with: text)
        
        // 글자수에 맞춰 남은 글자수 label 변경
        if (maxTextCount - changedText.count) > 0 {
            textLimitLabel.text = "\(maxTextCount - changedText.count)"
        } else {
            textLimitLabel.text = "0"
        }
        return changedText.count <= maxTextCount
    }
    
    // 텍스트 길이에 맞춰서 textView 길이 늘리기
    func textViewDidChange(_ textView: UITextView) {
        let size = CGSize(width: view.frame.width, height: .infinity)
        let estimatedSize = textView.sizeThatFits(size)
        textView.constraints.forEach{ (constraint) in
            if constraint.firstAttribute == .height {
                constraint.constant = estimatedSize.height
            }
        }
    }
}
