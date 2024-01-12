//
//  SignupEmailComponent.swift
//  YounetProject
//
//  Created by 김제훈 on 1/8/24.
//

import UIKit

/// 인증번호가 일치하지 않으면 재전송으로 바꿔야 하나?
class SignupEmailComponent: UIStackView {
    @IBOutlet var emailInputTitleLabel: UILabel!
    @IBOutlet var emailInputBtn: UIButton!
    @IBOutlet var emailInputCustomTF: SignupCustomTextField!
    @IBOutlet var emailConfirmBtn: UIButton!
    @IBOutlet var emailConfirmCustomTF: SignupCustomTextField!
    @IBOutlet var emailConfirmComponent: UIStackView!
    
    @IBOutlet var emailInputStatusLabel: UILabel!
    @IBOutlet var emailConfirmStatusLabel: UILabel!
    
    let emailInputNotValidText: String = "이메일 주소를 올바르게 입력해주세요."
    let emailConfirmNotValidText: String = "인증번호가 일치하지 않습니다."
    
    private var emailInputValid: Bool = false
    private var emailConfirmValid: Bool = false
    
    
    var validStatus: Bool {
        get {
            return emailInputValid && emailConfirmValid
        }
    }
    var popupInputBtnClicked: (() -> Void)? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        config()
    }
    
    private func config()
    {
        applyNib()
        emailConfirmComponent.isHidden = true
        
        emailInputCustomTF.inputTextField.addTarget(self, action: #selector(emailInputTFEditingChanged(_:)), for: .editingChanged)
        emailInputBtn.addTarget(self, action: #selector(emailInputBtnClicked(_:)), for: .touchUpInside)
        emailConfirmBtn.addTarget(self, action: #selector(emailConfirmBtnClicked(_:)), for: .touchUpInside)
    }
    
    func setTFFocus() {
        print(#fileID, #function, #line, "- SETFOCUS")
        if (!emailInputValid)
        {
            emailInputCustomTF.inputTextField.becomeFirstResponder()
            return
        }
        
        emailConfirmCustomTF.inputTextField.becomeFirstResponder()
    }
    
    func configEmailComponentWhenSignupInvalid() {
        configEmailInputAccordingToValidation(emailInputValid)
        if(!emailConfirmComponent.isHidden)
        {
            configEmailConfirmAccordingToValidation(emailConfirmValid)
        }
        
    }
    
    func configEmailInputAccordingToValidation(_ isValid: Bool)
    {
        emailInputValid = isValid
        if (isValid)
        {
            if (!emailInputBtn.isEnabled)
            {
                emailInputBtn.isEnabled = true
            }
            if (!emailInputStatusLabel.isHidden)
            {
                emailInputStatusLabel.isHidden = true
            }
        }
        else
        {
            if (emailInputBtn.isEnabled)
            {
                emailInputBtn.isEnabled = false
            }
            if (emailInputStatusLabel.isHidden)
            {
                emailInputStatusLabel.isHidden = false
            }
        }
        emailInputCustomTF.configAccordingToValidation(isValid)
    }
    
    func configEmailConfirmAccordingToValidation(_ isValid: Bool)
    {
        emailConfirmValid = isValid
        if (isValid)
        {
            emailInputCustomTF.backgroundColor = UIColor.systemGray4
            emailInputCustomTF.inputTextField.isEnabled = false
            emailInputBtn.isEnabled = false
            
            emailConfirmCustomTF.backgroundColor = UIColor.systemGray4
            emailConfirmCustomTF.inputTextField.isEnabled = false
            emailConfirmBtn.isEnabled = false
        }
        else
        {
            if (emailConfirmStatusLabel.isHidden)
            {
                emailConfirmStatusLabel.isHidden = false
            }
        }
        emailConfirmCustomTF.configAccordingToValidation(isValid)
    }
    
    @objc
    func emailInputTFEditingChanged(_ sender: UITextField)
    {
        let isValid = emailValidation(emailInputCustomTF.getFieldContentString())
        configEmailInputAccordingToValidation(isValid)
    }
    
    /// 이메일 인증 요청, 일치하지 않을 시, 재전송
    /// 이메일 인증 요청이 완료되었다는 팝업
    @objc
    func emailInputBtnClicked(_ sender: UIButton)
    {
        /// 이메일 인증 요청
        
        ///이메일 요청완료 팝업
        if (emailConfirmComponent.isHidden)
        {
            emailConfirmComponent.isHidden = false
        }
        
        var popupMsg = ""
        //처음 인증번호 전송
        if (emailInputBtn.titleLabel?.text == "인증")
        {
            popupMsg = "입력하신 이메일로\n인증 번호가 전송되었습니다."
            emailInputBtn.setTitle("재전송", for: .normal)
            emailConfirmBtn.isEnabled = true
        }
        else //재전송
        {
            popupMsg = "입력하신 이메일로\n인증 번호가 재전송되었습니다.\n재전송은 1회까지 가능합니다."
            emailInputBtn.isEnabled = false
        }
        
        let alert = UIAlertController(title: "", message: popupMsg, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: NSLocalizedString("닫기", comment: "Close action"), style: .default, handler: { [weak self]_ in
            self?.emailConfirmCustomTF.inputTextField.becomeFirstResponder()
        }))
        
        UIApplication.shared.topViewController()?.present(alert, animated: true)
    }
    
    ///Validation 완료 시 TF가 회색으로 변하고 입력 불가
    @objc
    func emailConfirmBtnClicked(_ sender: UIButton)
    {
        let isValid = emailConfirmValidation()
        
        configEmailConfirmAccordingToValidation(isValid)
    }
    
    func applyTFDelegate(_ delegate: UITextFieldDelegate)
    {
        emailInputCustomTF.applyTFDelegate(delegate)
        emailConfirmCustomTF.applyTFDelegate(delegate)
    }
    
    private func applyNib(){
        print(#fileID, #function, #line, "- ")
        let nibName = String(describing: Self.self)
        let nib = Bundle.main.loadNibNamed(nibName, owner: self)
        guard let view = nib?.first as? UIView else {
            return
        }
        addSubview(view)
        view.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }

}

//MARK: - Validation Helper Function
extension SignupEmailComponent
{
    private func emailValidation(_ inputStr: String) -> Bool {
        let regex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: inputStr)
        
        return isValid
    }
    
    private func emailConfirmValidation() -> Bool {
        return true
    }
}


//UIApplication.shared.topViewController()
// UIApplication 익스텐션
extension UIApplication {
    
    func topViewController() -> UIViewController? {
       // 애플리케이션 에서 키윈도우로 제일 아래 뷰컨트롤러를 찾고
       // 해당 뷰컨트롤러를 기점으로 최상단의 뷰컨트롤러를 찾아서 반환
        
        let scenes = UIApplication.shared.connectedScenes
        let windowScenes = scenes.first as? UIWindowScene
        return  windowScenes?.windows
                  .filter { $0.isKeyWindow }
                  .first?.rootViewController?
                  .topViewController()
    }
}

// UIViewController 익스텐션
extension UIViewController {
    func topViewController() -> UIViewController {
        // 프리젠트 방식의 뷰컨트롤러가 있다면
        if let presented = self.presentedViewController {
            // 해당 뷰컨트롤러에서 재귀 (자기 자신의 메소드를 실행)
            return presented.topViewController()
        }
        // 자기 자신이 네비게이션 컨트롤러 라면
        if let navigation = self as? UINavigationController {
            // 네비게이션 컨트롤러에서 보이는 컨트롤러에서 재귀 (자기 자신의 메소드를 실행)
            return navigation.visibleViewController?.topViewController() ?? navigation
        }
        // 최상단이 탭바 컨트롤러 라면
        if let tab = self as? UITabBarController {
            // 선택된 뷰컨트롤러에서 재귀 (자기 자신의 메소드를 실행)
            return tab.selectedViewController?.topViewController() ?? tab
        }
        // 재귀를 타다가 최상단 뷰컨트롤러를 반환
        return self
    }
}
