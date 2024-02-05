//
//  CustomTextField.swift
//  YounetProject
//
//  Created by 김세아 on 1/21/24.
//

import UIKit

class CustomTextField: UITextField {
    
    private func getKeyboardLanguage() -> String? {
        return "ko-KR"
    }
    
    override var textInputMode: UITextInputMode? {
        if let language = getKeyboardLanguage() {
            for inputMode in UITextInputMode.activeInputModes {
                if inputMode.primaryLanguage! == language {
                    return inputMode
                }
            }
        }
        return super.textInputMode
    }
}
