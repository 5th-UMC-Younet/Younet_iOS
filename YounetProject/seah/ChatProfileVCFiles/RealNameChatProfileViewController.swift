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
    @IBOutlet weak var nameLabel: UILabel!
    
    @IBOutlet weak var univButton: UIButton!
    @IBOutlet weak var nationButton: UIButton!
    @IBOutlet weak var exUnivButton: UIButton!
    
    @IBOutlet weak var mainStackView: UIStackView!
    @IBOutlet weak var subStackView: UIStackView!
    
    var textViewSample = "100자 이하의 소개글"
    let imgPicker = UIImagePickerController()
    let maxTextCount = 100
    var imageControllerCheck = 0
    
    var imgSaved = UIImage(named: "ProfileDefault")
    var profileTextSaved = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setKeyboard()
        setDefaultData()
        setTextViewPlaceholder()
        
        imgPicker.delegate = self
        selfExplainTextView.delegate = self
        selfExplainTextView.isScrollEnabled = false
        
        let screenHeight = UIScreen.main.bounds.size.height
        if screenHeight < 700 {
            mainStackView.spacing = 45
            subStackView.spacing = 30
        }
    
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
        //optional binding으로 userId 가져오기
        let userIdInt: Int? = UserDefaults.standard.integer(forKey: "myUserId")
        var myUserId = 1
        if let userId = userIdInt {
            myUserId = userId
        }
        
        // 실명 프로필 연결
        RealNameProfileService.shared.RealNameProfile(userId: myUserId){ (networkResult) -> (Void) in
            switch networkResult {
            case .success(let result):
                if let realNameData = result as? RealNameProfileData {
                    // 이름 및 프로필 소개글 설정
                    self.nameLabel.text = realNameData.name
                    realNameData.profileText == nil ? nil : (self.textViewSample = realNameData.profileText!)
                    self.selfExplainTextView.text = self.textViewSample
                    
                    // 본교 설정
                    realNameData.mainSkl == nil ? (self.univButton.setTitle("본교", for: .disabled)) : (self.univButton.setTitle(realNameData.mainSkl, for: .disabled))
                    
                    if realNameData.hostContr != nil {
                        self.nationButton.setTitle(realNameData.hostContr, for: .normal)
                        if let index = NationSelectionVC().countryList.firstIndex(where: {$0.korName == realNameData.hostContr}) {
                            self.nationButton.setImage(UIImage(named: NationSelectionVC().countryList[index].engName), for: .disabled)
                        }
                    }
                    realNameData.hostSkl == nil ? (self.univButton.setTitle("파견교", for: .disabled)) : (self.exUnivButton.setTitle(realNameData.hostSkl, for: .disabled))
                    
                    if realNameData.profilePicture != nil {
                        // url로부터 프로필 이미지 받아오기
                        let url = URL(string: realNameData.profilePicture!)
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
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    // 본인인증 버튼 연결
    @IBAction func selfIdentificationButtonDidtap(_ sender: Any) {
        let storyboard = UIStoryboard(name: "IdentificationVC", bundle: .main)
        guard let identificationVC = storyboard.instantiateViewController(withIdentifier: "IdentificationVC") as? IdentificationVC else { return }
        //identificationVC.setLeftBarButtonForNum = 1
        present(identificationVC, animated: true)
        
    }
    
    @IBAction func confirmButtonDidtap(_ sender: UIButton) {
        imgSaved = profileImage.currentImage
        
        if selfExplainTextView.text != textViewSample {
            profileTextSaved = selfExplainTextView.text
        } else {
            profileTextSaved = textViewSample
        }
        
        editRealNameProfileService().editRealNameProfileService(profilePicture: imgSaved!, profileText: profileTextSaved) { (networkResult) -> (Void) in
            switch networkResult {
            case .success:
                print("데이터 저장 성공")
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
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func backButtonDidtap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
}

extension RealNameChatProfileViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            let resizedImage = image.resize(newWidth: 400)
            profileImage.setImage(resizedImage, for: .normal)
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
