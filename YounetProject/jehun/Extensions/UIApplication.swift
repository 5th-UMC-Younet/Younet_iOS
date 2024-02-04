//
//  UIApplication.swift
//  YounetProject
//
//  Created by 김제훈 on 1/14/24.
//

import UIKit

extension UIApplication 
{
    var rootVC: UIViewController? {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let rootVC : UIViewController? = windowScene?.windows.filter({
            $0.isKeyWindow
        }).first?.rootViewController
        return rootVC
    }
    
}

