//
//  UITextField+Extension.swift
//  YounetProject
//
//  Created by 김제훈 on 1/22/24.
//

import UIKit
extension UITextField {
    
    enum Direction {
        case Left
        case Right
    }
    
    // add image to textfield
    func withImage(direction: Direction, image: UIImage, colorSeparator: UIColor, colorBorder: UIColor, height: CGFloat = 35){
        let mainView = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: height))
        mainView.layer.cornerRadius = 5
        
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 50, height: height))
        view.backgroundColor = .clear
        view.clipsToBounds = true
        view.layer.cornerRadius = 5
        view.layer.borderWidth = CGFloat(0.5)
        view.layer.borderColor = colorBorder.cgColor
        mainView.addSubview(view)
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.frame = CGRect(x: 12.0, y: 10.0, width: 24.0, height: 24.0)
//        imageView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(imageView)
//        NSLayoutConstraint.activate([
//            imageView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            imageView.widthAnchor.constraint(equalToConstant: 24),
//            imageView.heightAnchor.constraint(equalToConstant: 24),
//            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
//        ])
        
        let seperatorView = UIView()
        seperatorView.backgroundColor = colorSeparator
        mainView.addSubview(seperatorView)
        
        if(Direction.Left == direction){ // image left
            seperatorView.frame = CGRect(x: 45, y: 0, width: 5, height: height)
            self.leftViewMode = .always
            self.leftView = mainView
        } else { // image right
            seperatorView.frame = CGRect(x: 0, y: 0, width: 5, height: height)
            self.rightViewMode = .always
            self.rightView = mainView
        }
        
        self.layer.borderColor = colorBorder.cgColor
        self.layer.borderWidth = CGFloat(0.5)
        self.layer.cornerRadius = 5
    }
    
}
//usage example
//if let myImage = UIImage(named: "my_image"){
//    textfield.withImage(direction: .Left, image: myImage, colorSeparator: UIColor.orange, colorBorder: UIColor.black)
//}
