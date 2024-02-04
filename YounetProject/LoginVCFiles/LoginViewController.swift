//
//  LoginViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/7/24.
//

import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboard()
    }
    
    @IBAction func joinBtnDidtap(_ sender: UIButton) {
        // 회원가입 VC 연결
    }
    
    @IBAction func loginBtnDidTap(_ sender: UIButton) {
        // 로그인 인증
        if (idTextField.text == "") && (pwTextField.text == "") {
            let presentedPopup = PopupViewController.present(parent: self)
            presentedPopup.labelText = "\n비밀번호가 틀렸거나\n존재하지 않는 아이디입니다.\n"
        } else {
            let nextSB = UIStoryboard(name: "MyPage", bundle: nil)
            guard let nextVC = nextSB.instantiateViewController(withIdentifier: "TabBarVC") as? UITabBarController else { return }
            nextVC.modalPresentationStyle = .fullScreen
            nextVC.modalTransitionStyle = .crossDissolve
            self.present(nextVC, animated: true, completion: nil)
        }
    }
}

