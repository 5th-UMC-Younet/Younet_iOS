//
//  MyPageProfileEditViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/20/24.
//

import UIKit

class MyPageProfileEditViewController: UIViewController{
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var preferNationButton: UIButton!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var firstLineView: UIView!
    @IBOutlet weak var textLimitLabel: UILabel!
    @IBOutlet weak var selfExplainTextView: UITextView!
    @IBOutlet weak var secondLineView: UIView!
    @IBOutlet weak var mainStackView: UIStackView!
    
    var textViewSample = "100자 이하의 소개글"
    let imgPicker = UIImagePickerController()
    var imageControllerCheck = 0
    let maxTextCount = 100
    
    let simpleData = UserDefaults.standard
    let imageData = ImageFileManager.shared
    
    var imgSaved = UIImage(named: "ProfileDefault")
    var nicknameSaved = ""
    var nameSaved = ""
    var likeCntrSaved = ""
    var profileTextSaved = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyboard()
        setTextViewPlaceholder()
        setDefaultData()
        
        print("\(profileImage.currentImage!)")
        
        imgPicker.delegate = self
        nicknameTextField.delegate = self
        selfExplainTextView.delegate = self
        selfExplainTextView.isScrollEnabled = false
        
        let screenHeight = UIScreen.main.bounds.size.height
        if screenHeight < 700 {
            mainStackView.spacing = 50
        }
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
                
                self?.likeCntrSaved = nationSelectionVC.selectedCountry!.korName
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
    
    // MARK: - 서버에서 데이터 받아오기
    private func setDefaultData() {
        MyPageProfileEditService.shared.MyPageEdit { (networkResult) -> (Void) in
            switch networkResult {
            case .success(let result):
                if let myPageData = result as? MyPageEditUserData {
                    // 이름 및 닉네임, 소개글 세팅
                    self.usernameLabel.text = myPageData.name
                    if myPageData.nickname != "" {
                        self.nicknameTextField.placeholder = myPageData.nickname
                        self.nicknameSaved = myPageData.nickname!
                    } else {
                        self.nicknameTextField.placeholder = "10자 이하의 닉네임"
                    }
                    myPageData.profileText == nil ? nil : (self.textViewSample = myPageData.profileText!)
                    self.selfExplainTextView.text = self.textViewSample
                    
                    
                    // 관심 국가명 및 이미지 세팅
                    if myPageData.likeCntr != nil {
                        self.preferNationButton.setTitle(myPageData.likeCntr, for: .normal)
                        if let index = NationSelectionVC().countryList.firstIndex(where: {$0.korName == myPageData.likeCntr}) {
                            self.preferNationButton.setImage(UIImage(named: NationSelectionVC().countryList[index].engName), for: .normal)
                        }
                    }
                
                    if myPageData.profilePicture != nil {
                        // url로부터 프로필 이미지 받아오기
                        let url = URL(string: myPageData.profilePicture!)
                        DispatchQueue.global().async { [weak self] in
                            if let data = try? Data(contentsOf: url!) {
                                if let image = UIImage(data: data) {
                                    DispatchQueue.main.async {
                                        self?.profileImage.setImage(image, for: .normal)
                                    }
                                }
                            }
                        }
                    }
                }
            case .requestErr:
                print("400 Error")
                self.dismiss(animated: true, completion: nil)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
        
    }
    
    // MARK: - 확인 버튼: 프로필 수정 후 저장
    @IBAction func confirmButtonDidtap(_ sender: UIButton) {
        imgSaved = profileImage.currentImage
        if nicknameTextField.text != "" {
            nicknameSaved = nicknameTextField.text!
        }
        if selfExplainTextView.text != textViewSample {
            profileTextSaved = selfExplainTextView.text
        } else{
            profileTextSaved = textViewSample
        }
        
        MyPageProfileEditService.shared.MyPageEditPatch(profilePicture: imgSaved!, name: usernameLabel.text!, nickname: nicknameSaved, likeCntr: likeCntrSaved, profileText: profileTextSaved) { (networkResult) -> (Void) in
            switch networkResult {
            case .success:
                print("데이터 저장 성공")
                // 임시 data 저장 후 삭제
                if self.simpleData.value(forKey: "preferNationImage_temp") != nil {
                    self.simpleData.setValue(self.simpleData.value(forKey: "preferNationImage_temp"), forKey: "preferNationImage")
                    self.simpleData.removeObject(forKey: "preferNationImage_temp")
                }
                self.dismiss(animated: true, completion: nil)
            case .requestErr:
                self.dismiss(animated: true, completion: nil)
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    @IBAction func backButtonDidtap(_ sender: UIButton) {
        // 뒤로가기 누를 때: 저장된 임시 data 삭제
        (simpleData.value(forKey: "preferNationImage_temp") != nil) ? (simpleData.removeObject(forKey: "preferNationImage_temp")) : nil
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - 갤러리에서 이미지 가져오기
extension MyPageProfileEditViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let resizedImage = image.resize(newWidth: 300)
            profileImage.setImage(resizedImage, for: .normal)
        }
        dismiss(animated: true, completion: nil)
    }
}

extension MyPageProfileEditViewController : UITextViewDelegate, UITextFieldDelegate {
    // textView 편집 시작
    func textViewDidBeginEditing(_ textView: UITextView) {
        setTextViewPlaceholder()
        secondLineView.backgroundColor = #colorLiteral(red: 0.3058094382, green: 0.4039391279, blue: 0.9215484262, alpha: 1)
        
        UIView.animate(withDuration: 0.3) {
            self.view.window?.frame.origin.y -= 120
        }
    }
    // textView 편집 끝
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text == "" {
            setTextViewPlaceholder()
        }
        secondLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
        
        UIView.animate(withDuration: 0.3) {
        self.view.window?.frame.origin.y += 120
        }
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
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.selfExplainTextView.becomeFirstResponder()
        return true
    }
    
}

