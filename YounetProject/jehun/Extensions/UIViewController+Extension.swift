//
//  UIViewController+Extension.swift
//  YounetProject
//
//  Created by 김제훈 on 1/14/24.
//

import UIKit
import Combine

extension UIViewController {
    //Handling Keyboard Show and Hide
    func handleKeyboardShowAndHide(_ constraint: NSLayoutConstraint? = nil,
                                   bottomPadding: CGFloat = 0,
                                   subscriptions: inout Set<AnyCancellable>){
        
        NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillShowNotification, object: nil)
            .compactMap{ $0.userInfo }
            .sink { userInfo in
                print(#fileID, #function, #line, "- userInfo: \(userInfo)")
                
                let keyboardSize = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect ?? .zero
                let animDuration = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? CGFloat ?? 0.0
                
                let animOption = userInfo["UIKeyboardAnimationCurveUserInfoKey"] as? UInt ?? 0
                let animationOptions = UIView.AnimationOptions(rawValue: animOption)
                UIView.animate(withDuration: animDuration,
                               delay: 0,
                               options: animationOptions,
                               animations: {
                    
                    if constraint == nil {
                        if self.view.frame.origin.y == 0 {
                            self.view.frame.origin.y -= keyboardSize.height
                            self.view.layoutIfNeeded()
                        }
                        return
                    }
                    
                    constraint?.constant = (keyboardSize.height + bottomPadding)
                    self.view.layoutIfNeeded()
                })
            }.store(in: &subscriptions)
        
       NotificationCenter.default
            .publisher(for: UIResponder.keyboardWillHideNotification, object: nil)
            .compactMap{ $0.userInfo }
            .sink { userInfo in
                print(#fileID, #function, #line, "- userInfo: \(userInfo)")
                
                let keyboardSize = userInfo["UIKeyboardFrameEndUserInfoKey"] as? CGRect ?? .zero
                let animDuration = userInfo["UIKeyboardAnimationDurationUserInfoKey"] as? CGFloat ?? 0.0
                
                let animOption = userInfo["UIKeyboardAnimationCurveUserInfoKey"] as? UInt ?? 0
                let animationOptions = UIView.AnimationOptions(rawValue: animOption)
                UIView.animate(withDuration: animDuration,
                               delay: 0,
                               options: animationOptions,
                               animations: {
                    if constraint == nil {
                        if self.view.frame.origin.y != 0 {
                            self.view.frame.origin.y = 0
                            self.view.layoutIfNeeded()
                        }
                        return
                    }
                    constraint?.constant = 0
                    self.view.layoutIfNeeded()
                })
            }.store(in: &subscriptions)
    }
    
    
}
