//
//  LoginViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/7/24.
//

import UIKit

class LoginViewController: UIViewController {
    
    let alert = UIAlertController(title: "비밀번호가 틀렸거나 존재하지 않는 아이디입니다.", message: nil, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboard()
    }
    
    @IBAction func loginBtnDidTap(_ sender: UIButton) {
        // 로그인 인증
        
        // alert button 색상 설정 및 action 추가
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationItem.hidesBackButton = true
   }
    
    func setKeyboard() {
        // 터치 시 키보드 내리기
        let tap = UITapGestureRecognizer(target: view, action: #selector(UIView.endEditing))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

}

