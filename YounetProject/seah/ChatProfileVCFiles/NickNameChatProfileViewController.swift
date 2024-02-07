//
//  NameChatProfileViewController.swift
//  YounetProject
//
//  Created by 김세아 on 2/6/24.
//

import UIKit

class NickNameChatProfileViewController: UIViewController {
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var preferNationButton: UIButton!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var firstLineView: UIView!
    @IBOutlet weak var textLimitLabel: UILabel!
    @IBOutlet weak var selfExplainTextView: UITextView!
    @IBOutlet weak var secondLineView: UIView!
    
    let textViewSample = "100자 이하의 소개글"
    let imgPicker = UIImagePickerController()
    let maxTextCount = 100
    let simpleData = UserDefaults.standard
    let imageData = ImageFileManager.shared
    var imageControllerCheck = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyboard()
        setKeyboardObserver()
        setTextViewPlaceholder()
        setDefaultData()
        
        imgPicker.delegate = self
        nicknameTextField.delegate = self
        selfExplainTextView.delegate = self
        selfExplainTextView.isScrollEnabled = false
    }
    
    @IBAction func profileImageBtnDidtap(_ sender: UIButton) {
        imgPicker.sourceType = .photoLibrary
        present(imgPicker, animated: false, completion: nil)
    }
    
    // 관심국가 선택 팝업 및 데이터 저장
    @IBAction func nationBtnDidtap(_ sender: Any) {
        let nationSelectionVC = NationSelectionVC.present(parent: self)
        nationSelectionVC.onDismissed = { [weak self] () in
            if nationSelectionVC.selectedCountry?.korName != nil {
                self?.preferNationButton.setTitle(nationSelectionVC.selectedCountry?.korName, for:.normal)
                self?.preferNationButton.setImage(UIImage(named: nationSelectionVC.selectedCountry!.engName), for: .normal)
        
                UserDefaults.standard.setValue(nationSelectionVC.selectedCountry?.korName, forKey: "preferNation_temp")
                UserDefaults.standard.setValue(nationSelectionVC.selectedCountry!.engName, forKey: "preferNationImage_temp")
            }
        }
    }
    
    @IBAction func nickNameTfEditBegin(_ sender: Any) {
        firstLineView.backgroundColor = #colorLiteral(red: 0.3058094382, green: 0.4039391279, blue: 0.9215484262, alpha: 1)
    }
    
    @IBAction func nickNameTfEditEnd(_ sender: Any) {
        firstLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
    }

    private func setDefaultData() {
        if imageData.getSavedImage(named: "profileImage") != nil {
            profileImage.setImage(imageData.getSavedImage(named: "profileImage"), for: .normal)
        }
        imageControllerCheck = 0
        
        simpleData.string(forKey: "nickname") != nil ? (nicknameTextField.placeholder = simpleData.string(forKey: "nickname")) : (nicknameTextField.placeholder = "10자 이하의 닉네임")
        selfExplainTextView.text = textViewSample
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
    
    @IBAction func confirmButtonDidtap(_ sender: UIButton) {
        // 확인 버튼 누를 때: 일반 data 저장
        imageControllerCheck != 0 ? (imageData.saveImage(image: profileImage.currentImage!, name: "profileImage") { onSuccess in return } ) : nil
        
        nicknameTextField.text != "" ? simpleData.setValue(nicknameTextField.text, forKey: "nickname") : nil
        selfExplainTextView.text != textViewSample ? simpleData.setValue(selfExplainTextView.text, forKey: "selfExplain") : nil
        
        // 임시 data 저장 후 삭제
        if simpleData.value(forKey: "preferNation_temp") != nil {
            simpleData.setValue(simpleData.value(forKey: "preferNation_temp"), forKey: "preferNation")
            simpleData.removeObject(forKey: "preferNation_temp")
        }
        if simpleData.value(forKey: "preferNationImage_temp") != nil {
            simpleData.setValue(simpleData.value(forKey: "preferNationImage_temp"), forKey: "preferNationImage")
            simpleData.removeObject(forKey: "preferNationImage_temp")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonDidtap(_ sender: UIButton) {
        // 뒤로가기 누를 때: 저장된 임시 data 삭제
        (simpleData.value(forKey: "preferNation_temp") != nil) ? (simpleData.removeObject(forKey: "preferNation_temp")) : nil
        (simpleData.value(forKey: "preferNationImage_temp") != nil) ? (simpleData.removeObject(forKey: "preferNationImage_temp")) : nil
        
        dismiss(animated: true, completion: nil)
    }
}

extension NickNameChatProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            profileImage.setImage(image, for: .normal)
            imageControllerCheck = 1
        }
        dismiss(animated: true, completion: nil)
    }
}

extension NickNameChatProfileViewController : UITextViewDelegate, UITextFieldDelegate {
    // textView 편집 시작
    func textViewDidBeginEditing(_ textView: UITextView) {
        setTextViewPlaceholder()
        secondLineView.backgroundColor = #colorLiteral(red: 0.3058094382, green: 0.4039391279, blue: 0.9215484262, alpha: 1)
    }
    // textView 편집 끝
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            setTextViewPlaceholder()
        }
        secondLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
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
    
    // nickName TextField 글자 수 10자로 제한
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 백스페이스 처리
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard textField.text!.count < 10 else { return false }
        return true
    }
    
}

