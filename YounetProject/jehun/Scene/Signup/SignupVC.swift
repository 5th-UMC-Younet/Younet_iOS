//
//  SignupVC.swift
//  YounetProject
//
//  Created by 김제훈 on 1/5/24.
//

import UIKit
import Combine

class SignupVC: UIViewController
{
    @IBOutlet var nameInputComponent: SignupInputComponent!
    @IBOutlet var nicknameInputComponent: SignupInputComponent!
    @IBOutlet var idInputComponent: SignupInputComponent!
    @IBOutlet var pwInputComponent: SignupInputComponent!
    @IBOutlet var pwCheckInputComponent: SignupInputComponent!
    
    @IBOutlet var emailInputComponent: SignupEmailComponent!

    @IBOutlet var signupBtn: UIButton!
    @IBOutlet var contentView: UIView!
    
    @IBOutlet var agreementStackView: UIStackView!
    @IBOutlet var agreementErrorLabel: UILabel!
    
    var subscriptions : Set<AnyCancellable> = Set()
    
    var agreementStatus: Bool = false {
        didSet {
            agreementErrorLabel.isHidden = agreementStatus
        }
    }
    
    lazy var signupBtnBottomConstraint: NSLayoutConstraint? = nil
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        config()
        dump(signupBtnBottomConstraint)
        
        handleKeyboardShowAndHide(signupBtnBottomConstraint, bottomPadding: 56, subscriptions: &subscriptions)
    }
    
    //MARK: - Handle keyboard
//    @objc
//    private func handleKeyboard(_ sender: Notification) {
//        print(#fileID, #function, #line, "- sender: \(sender.userInfo)")
//        
//    }
    
    @objc
    private func signupBtnClicked(_ sender: UIButton)
    {
        let isAvailable = isSignupAvailable()
        
        if (isAvailable)
        {
            let popup = DefaultPopup.present(parent: self, contentStr: "회원가입이 완료되었습니다.", btnTitleStr: "로그인")
            popup.onDismissed = {
                //로그인 화면으로 화면 전환
            }
        }
        else
        {
            
        }
    }
    
    @objc
    private func agreeBtnClicked(_ sender: UITapGestureRecognizer) {
        agreementStatus = !agreementStatus
        
        let image = agreementStatus ? UIImage(named: "check-circle") : UIImage(named: "uncheck-circle")
        
        
        
        if let stackView = sender.view as? UIStackView,
           let stackIamgeView = stackView.arrangedSubviews[1] as? UIImageView {
            stackIamgeView.image = image
        }
        
    }
    
    private func isSignupAvailable() -> Bool
    {
        // not valid components
        let invalidComponentList : [Any] = [nameInputComponent,
                                    nicknameInputComponent,
                                            idInputComponent,
                                    emailInputComponent,
                                    pwInputComponent,
                                    pwCheckInputComponent,
                                    agreementStatus
                                    
        ]
            .compactMap{ $0 }.filter{
                if let component = $0 as? SignupInputComponent {
                    return component.validStatus == false
                }
                
                if let component = $0 as? SignupEmailComponent {
                    return component.validStatus == false
                }
                
                if let agreementStatus = $0 as? Bool {
                    return agreementStatus == false
                }
                
                return false
            }
        
        
        invalidComponentList.forEach{
            if let component = $0 as? SignupInputComponent {
                component.configAccordingToValidation(false)
                return
            }
            
            if let component = $0 as? SignupEmailComponent {
                component.configEmailComponentWhenSignupInvalid()
                return
            }
            
            if let agreementStatus = $0 as? Bool {
                if (agreementErrorLabel.isHidden)
                {
                    agreementErrorLabel.isHidden = false
                }
                return
            }
            
        }
        
        
        if let firstComponent = invalidComponentList.first as? SignupInputComponent {
            firstComponent.setTFFocus()
        }
        
        if let firstComponent = invalidComponentList.first as? SignupEmailComponent {
            firstComponent.setTFFocus()
        }
        
        
        
        print(#fileID, #function, #line, "- invalidComponentList: \(invalidComponentList)")
        
        
        return [nameInputComponent.validStatus,
                nicknameInputComponent.validStatus,
                idInputComponent.validStatus,
                pwInputComponent.validStatus,
                pwCheckInputComponent.validStatus,
                emailInputComponent.validStatus,
                agreementStatus].allSatisfy{ $0 == true }
    }
}

//MARK: - SignupInputComponentDelegate
extension SignupVC: SignupInputComponentDelegate
{
    func inputValidation(_ component: SignupInputComponent, inputStr: String)
    {
        var result = false
        
        switch (component)
        {
        case nameInputComponent:
            result = nameValidation(inputStr)
        case nicknameInputComponent:
            result = nicknameValidation(inputStr)
        case idInputComponent:
            result = idValidation(inputStr)
        case pwInputComponent:
            result = pwValidation(inputStr)
        case pwCheckInputComponent:
            result = pwCheckValidation(inputStr)
        default:
            break
        }
        
        component.configAccordingToValidation(result)
    }
}

//MARK: - Configuration Helper Function
extension SignupVC
{
    private func config()
    {
        //SignupBtn
        signupBtn.addTarget(self, action: #selector(signupBtnClicked(_:)), for: .touchUpInside)
        signupBtn.layer.masksToBounds = true
        signupBtn.layer.cornerRadius = 10
        //AgreementBtn
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(agreeBtnClicked))
        
        agreementStackView.addGestureRecognizer(tapGesture)
        
        //InputComponent
        configSignupInputComponent(nameInputComponent)
        configSignupInputComponent(nicknameInputComponent)
        configSignupInputComponent(idInputComponent)
        configSignupInputComponent(pwInputComponent)
        configSignupInputComponent(pwCheckInputComponent)
        
        
        //do when keyboard popup
        for constraint in contentView.constraints
        {
            print(#fileID, #function, #line, "- \(constraint)")
            if (constraint.identifier == "signupBtnBottomConstraint")
            {
                signupBtnBottomConstraint = constraint
            }
        }
    }
    
    /// IsNotValid일때 컴포넌트 설정
    public static func configComponentWhenIsNotValid(textField: UITextField, statusLabel: UILabel, msg: String)
    {
        statusLabel.isHidden = false
        statusLabel.text = msg
        textField.layer.borderColor = UIColor.systemRed.cgColor
    }
    
    /// IsValid일때 컴포넌트 설정
    public static func configComponentWhenIsValid(textField: UITextField, statusLabel: UILabel)
    {
        statusLabel.isHidden = true
        textField.layer.borderColor = UIColor.systemGreen.cgColor
    }
    
    private func configSignupInputComponent(_ component: SignupInputComponent)
    {
        component.delegate = self
        if ((component == pwInputComponent) || (component == pwCheckInputComponent))
        {
            component.configPwInputComponent()
        }
        
    }
}

//MARK: - Validation Helper Function
extension SignupVC
{
    private func nameValidation(_ inputStr: String) -> Bool
    {
        return inputStr.count > 0
    }
    private func nicknameValidation(_ inputStr: String) -> Bool
    {
        return inputStr.count > 0
    }
    private func idValidation(_ inputStr: String) -> Bool
    {
        //id 중복 체크 추가 필요
        return idInputComponent.customTextField.getFieldContentString().count > 0
    }
    private func pwValidation(_ inputStr: String) -> Bool
    {
        let regex = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}"
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regex)
        let isValid = predicate.evaluate(with: inputStr)
        
        return isValid
    }
    private func pwCheckValidation(_ inputStr: String) -> Bool
    {
        let inputPw = pwInputComponent.customTextField.getFieldContentString()
        return (inputStr == inputPw) && pwValidation(inputPw)
    }
}


