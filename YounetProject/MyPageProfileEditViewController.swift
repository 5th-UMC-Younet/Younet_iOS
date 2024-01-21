//
//  MyPageProfileEditViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/20/24.
//

import UIKit

class MyPageProfileEditViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var profileImage: UIButton!
    @IBOutlet weak var preferNationButton: UIButton!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    let location = ["🇩🇰 덴마크", "🇩🇪 독일", "🇺🇸 미국", "🇧🇪 벨기에", "🇧🇷 브라질", "🇸🇪 스웨덴", "🇨🇭 스위스", "🇪🇸 스페인", "🇦🇹 오스트리아", "🇮🇹 이탈리아", "🇯🇵 일본", "🇨🇳 중국", "🇨🇦 캐나다", "🇫🇷 프랑스", "🇫🇮 핀란드", "🇦🇺 호주", "🇲🇽 멕시코", "🇳🇱 네덜란드"]
    let pickerView: UIPickerView = UIPickerView()
    var focusedRow: Int = 0
    let imgPicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        preferNationButton.layer.borderWidth = 0.3
        preferNationButton.layer.borderColor = UIColor.lightGray.cgColor
        
        nameTextField.delegate = self
        nameTextField.tag = 0
        phoneNumberTextField.tag = 1
        setKeyboard()
        
        imgPicker.delegate = self
    }
    
    @IBAction func profileImageBtnDidtap(_ sender: UIButton) {
        openLibrary()
    }
    
    @IBAction func nationBtnDidtap(_ sender: Any) {
        let titleText: String = "관심 국가를 선택해주세요"
        let attributeString = NSMutableAttributedString(string: titleText)
        attributeString.addAttribute(.font, value: UIFont(name: "Inter-Bold", size: 18)!, range: (titleText as NSString).range(of: "관심 국가"))
        attributeString.addAttribute(.font, value: UIFont(name: "Inter-Regular", size: 18)!, range: (titleText as NSString).range(of: "를 선택해주세요"))
        
        let alert = UIAlertController(title: "\n\(titleText)", message: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        alert.setValue(attributeString, forKey: "attributedTitle")
        
        let alertAction = UIAlertAction(title: "확인", style: .default) { _ in
            self.preferNationButton.setTitle("\(self.location[self.focusedRow])", for: .normal)
        }
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(alertAction)
        alert.view.subviews.first?.subviews.first?.subviews.first?.backgroundColor = UIColor(named: "PickerViewColorSet")
        
        pickerView.frame = CGRect(x: 35, y: 53, width: 200, height: 240)
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.setValue(UIColor.white, forKey: "backgroundColor")
        pickerView.cornerRadius = 8
        
        alert.view.addSubview(pickerView)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func backButtonDidtap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    // UITextField Return Key 대응
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let nextField = textField.superview?.viewWithTag(textField.tag + 1) as? UITextField {
            nextField.becomeFirstResponder()
        } else {
            // 없다면 키보드 내리기
            textField.resignFirstResponder()
        }
        return false
    }
    
    @IBAction func phoneNumberTfEdited(_ sender: Any) {
        var stringWithHypen: String = phoneNumberTextField.text ?? ""
        
        if phoneNumberTextField.text?.count == 11 {
            // 전화번호 형식으로 하이픈(-) 추가
            stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.startIndex, offsetBy: 3))
            stringWithHypen.insert("-", at: stringWithHypen.index(stringWithHypen.endIndex, offsetBy: -4))
        } else {
            // 11자리수가 아닐 경우 하이픈 제거
            stringWithHypen = phoneNumberTextField.text?.components(separatedBy: ["-"]).joined() ?? ""
        }
        phoneNumberTextField.text = stringWithHypen
    }
    
    func openLibrary(){
        imgPicker.sourceType = .photoLibrary
        present(imgPicker, animated: false, completion: nil)
    }
    
}

extension MyPageProfileEditViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    // pickerView에 담긴 아이템의 컴포넌트 수. 선택 wheel 수
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    // 전체 아이템 수
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return location.count
    }
    // 아이템명
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return location[row]
    }
    // 특정 아이템 선택 시 행위
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        focusedRow = row
    }
    // 각 아이템 칸의 세로 길이
    func pickerView(_ pickerView: UIPickerView, rowHeightForComponent component: Int) -> CGFloat {
        return 30
    }
 
    // 아이템 label 폰트 설정
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
        var label = UILabel()
        if let v = view {
            label = v as! UILabel
        }

        label.font = UIFont (name: "Inter-Regular", size: 15)
        label.text = location[row]
        label.textAlignment = .center
        
        return label
    }
}

extension MyPageProfileEditViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            // 서버에 이미지 전송 후 다시 받아와서 버튼 이미지 설정하는 코드 작성 (이미지 Resize 필요)
            profileImage.setImage(image, for: .normal)
        }
        dismiss(animated: true, completion: nil) // 창 닫기
    }
}
