//
//  PwPageViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/28/24.
//

import UIKit

class PwPageViewController: UIViewController {
    @IBOutlet weak var certifyButton: UIButton!
    @IBOutlet weak var firstLineView: UIView!
    @IBOutlet weak var secondLineView: UIView!
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var certNumTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setButton()
    }
    
    private func setButton() {
        certifyButton.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        certifyButton.layer.masksToBounds = false
        certifyButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        certifyButton.layer.shadowOpacity = 0.25
        certifyButton.layer.shadowRadius = 0
    }

    // 아이디 TextField 터치 시 밑줄 색상 변경
    @IBAction func IdEditBegin(_ sender: Any) {
        firstLineView.backgroundColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
    }
    @IBAction func IdEditEnd(_ sender: Any) {
        firstLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
    }
    
    // 인증번호 TextField 터치 시 밑줄 색상 변경
    @IBAction func CertNumEditBegin(_ sender: Any) {
        secondLineView.backgroundColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
    }
    @IBAction func CertNumEditEnd(_ sender: Any) {
        secondLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
    }
    
}
