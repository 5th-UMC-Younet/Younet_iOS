//
//  UIVieweExtension.swift
//  YounetProject
//
//  Created by 김세아 on 1/6/24.
//

import UIKit

extension UIView {
    // 모서리 둥글게
    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        } set {
            layer.cornerRadius = newValue
            layer.masksToBounds = true
        }
    }
    
    // launchScreen 이후 재생될 Gif의 위치 설정
    func pinEdgesToSuperView() {
           guard let superView = superview else { return }
           translatesAutoresizingMaskIntoConstraints = false
           topAnchor.constraint(equalTo: superView.topAnchor).isActive = true
           leftAnchor.constraint(equalTo: superView.leftAnchor).isActive = true
           bottomAnchor.constraint(equalTo: superView.bottomAnchor).isActive = true
           rightAnchor.constraint(equalTo: superView.rightAnchor).isActive = true
       }
    
}
