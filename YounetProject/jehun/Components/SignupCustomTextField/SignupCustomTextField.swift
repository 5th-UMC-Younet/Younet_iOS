//
//  SignupCustomTextField.swift
//  YounetProject
//
//  Created by 김제훈 on 1/10/24.
//

import UIKit

class SignupCustomTextField: UIView {
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var validStatusImg: UIImageView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        config()
    }
    
    private func config() 
    {
        applyNib()
    }
     
    // getter
    func getFieldContentString() -> String 
    {
        return inputTextField.text ?? ""
    }
    
    func configAccordingToValidation(_ isValid: Bool)
    {
        if (isValid)
        {
            if (validStatusImg.isHidden) {
                validStatusImg.isHidden = false
                print(#fileID, #function, #line, "- 1")
            }
            self.layer.borderColor = UIColor.black.cgColor
        }
        else
        {
            if (!validStatusImg.isHidden) {
                validStatusImg.isHidden = true
            }
            self.layer.borderColor = UIColor.systemRed.cgColor
        }
    }
    
    func applyDelegate(_ delegate: UITextFieldDelegate)
    {
        inputTextField.delegate = delegate
    }
    
    private func applyNib(){
        print(#fileID, #function, #line, "- ")
        let nibName = String(describing: Self.self)
        let nib = Bundle.main.loadNibNamed(nibName, owner: self)
        guard let view = nib?.first as? UIView else {
            return
        }
        addSubview(view)
        view.backgroundColor = .clear
        view.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.topAnchor),
            view.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor),
        ])
    }

}
