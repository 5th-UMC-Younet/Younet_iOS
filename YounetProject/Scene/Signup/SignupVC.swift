//
//  SignupVC.swift
//  YounetProject
//
//  Created by 김제훈 on 1/5/24.
//

import UIKit



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
        
    }
    
    @objc
    private func signupBtnClicked(_ sender: UIButton)
    {
        let isAvailable = isSignupAvailable()
        
        if (isAvailable)
        {
            let alert = UIAlertController(title: "", message: "회원가입이 완료되었습니다.", preferredStyle: .alert)
            
            let confirmAction = UIAlertAction(title: NSLocalizedString("로그인", comment: "login action"), style: .default, handler: { [weak self]_ in
                self?.navigationController?.popViewController(animated: true)
            })
            
            alert.addAction(confirmAction)
            self.present(alert, animated: true)
        }
        else
        {
            
        }
    }
    
    @objc
    private func agreeBtnClicked(_ sender: UITapGestureRecognizer) {
        agreementStatus = !agreementStatus
        
        let image = agreementStatus ? UIImage(systemName: "checkmark.square.fill") : UIImage(systemName: "square")
        
        
        
        if let stackView = sender.view as? UIStackView,
           let stackIamgeView = stackView.arrangedSubviews.first as? UIImageView {
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

extension SignupVC: UITextFieldDelegate
{
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        signupBtnBottomConstraint?.constant = 356
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        signupBtnBottomConstraint?.constant = 56
    }
}

//MARK: - Configuration Helper Function
extension SignupVC
{
    private func config()
    {
        //SignupBtn
        signupBtn.addTarget(self, action: #selector(signupBtnClicked(_:)), for: .touchUpInside)
        //AgreementBtn
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(agreeBtnClicked))
        
        agreementStackView.addGestureRecognizer(tapGesture)
        
        //InputComponent
        configSignupInputComponent(nameInputComponent)
        configSignupInputComponent(nicknameInputComponent)
        configSignupInputComponent(idInputComponent)
        configSignupInputComponent(pwInputComponent)
        configSignupInputComponent(pwCheckInputComponent)
        
        //EmailInputComponent
        emailInputComponent.applyTFDelegate(self)
        
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
    
    /// SignupVC에서 공통적으로 사용하는 텍스트필드의 기본 보더 설정
    public static func configTextFieldBorder(_ view: UIView) {
        view.layer.cornerRadius = 6
        view.layer.borderWidth = 0.8
        view.layer.borderColor = UIColor.black.cgColor
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
        component.applyTFDelegate(self)
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
