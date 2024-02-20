//
//  SignupInputConponent.swift
//  YounetProject
//
//  Created by 김제훈 on 1/7/24.
//

import UIKit

@IBDesignable
class SignupInputComponent: UIStackView {
    @IBOutlet var inputTitleLabel: UILabel!
    @IBOutlet var customTextField: SignupCustomTextField!
    @IBOutlet var inputErrorLabel: UILabel!
    @IBOutlet var inputHairlineView: UIView!
    
    weak var delegate: SignupInputComponentDelegate? = nil
    
    var validStatus: Bool = false
    
    let onEditingColor = UIColor(red: 41/255, green: 29/255, blue: 137/255, alpha: 1)
    let onNotEditingColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
    let onInvalidColor = UIColor(red: 245/255, green: 86/255, blue: 78/255, alpha: 1)
    
    
    @IBInspectable
    var titleText: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.inputTitleLabel.text  = self.titleText
            }
        }
    }
    
    @IBInspectable
    var inputErrorMsg: String = "" {
        didSet {
            DispatchQueue.main.async {
                self.inputErrorLabel.text = self.inputErrorMsg
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        config()
    }
    
    func setTFFocus() {
        customTextField.inputTextField.becomeFirstResponder()
    }
    
    func configAccordingToValidation(_ isValid: Bool) {
        validStatus = isValid
        if (isValid)
        {
            inputHairlineView.backgroundColor = onEditingColor
            if (!inputErrorLabel.isHidden)
            {
                inputErrorLabel.isHidden = true
            }
        }
        else
        {
            inputErrorLabel.text = inputErrorMsg
            inputHairlineView.backgroundColor = onInvalidColor
            if (inputErrorLabel.isHidden)
            {
                inputErrorLabel.isHidden = false
            }
        }
        customTextField.configAccordingToValidation(isValid)
    }
    
    
    private func config()
    {
        applyNib()
        inputErrorLabel.isHidden = true
        customTextField.inputTextField.addTarget(self, action: #selector(inputEditingChanged(_:)), for: .editingChanged)
        customTextField.applyDelegate(self)
    }
    
    func configPwInputComponent()
    {
        customTextField.inputTextField.isSecureTextEntry = true
    }

    private func applyNib()
    {
        print(#fileID, #function, #line, "- ")
        let nibName = String(describing: Self.self)
        let nib = Bundle.main.loadNibNamed(nibName, owner: self)
        guard let view = nib?.first as? UIStackView else {
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
    
    @objc
    private func inputEditingChanged(_ sender: UITextField) 
    {
        delegate?.inputValidation(self, inputStr: sender.text ?? "")
    }
}

extension SignupInputComponent: UITextFieldDelegate 
{
    func textFieldDidBeginEditing(_ textField: UITextField) 
    {
        if (!(inputHairlineView.backgroundColor?.cgColor == onInvalidColor.cgColor))
        {
            inputHairlineView.backgroundColor = onEditingColor
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) 
    {
        if (inputHairlineView.backgroundColor?.cgColor == onEditingColor.cgColor)
        {
            inputHairlineView.backgroundColor = onNotEditingColor
        }
        
    }
}

protocol SignupInputComponentDelegate: NSObjectProtocol {
    /// Input Validation(이름, 닉네임, 전화번호, 비밀번호, 비밀번호 확인)
    func inputValidation(_ component: SignupInputComponent, inputStr: String)
}


