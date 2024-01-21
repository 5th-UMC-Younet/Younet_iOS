//
//  PwResetViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/14/24.
//

import UIKit

class PwResetViewController: UIViewController {

    @IBOutlet weak var newPw: UITextField!
    @IBOutlet weak var pwCheck: UITextField!
    @IBOutlet weak var pwCheckAlert: UILabel!
    @IBOutlet weak var newPwAlert: UILabel!
    @IBOutlet weak var completeButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialDesignSetting()
        setKeyboard()
        
    }
    
    func initialDesignSetting() {
        pwCheckAlert.isHidden = true
        newPwAlert.isHidden = true
        completeButton.isEnabled = false
        completeButton.backgroundColor = UIColor.darkGray
    }
    
    @IBAction func backBtnDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    // 비밀번호 TextField 변경 시
    @IBAction func newPwTfChanged(_ sender: UITextField) {
        let newPw = sender.text ?? ""
        let regularExpression = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}"
        let pwValidaition = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        let validateResult = pwValidaition.evaluate(with: newPw)
        
        if validateResult == true || newPw.count <= 1 {
            newPwAlert.isHidden = true
        } else {
            newPwAlert.isHidden = false
        }
    }
    
    
    @IBAction func pwCheckTfChanged(_ sender: UITextField) {
        let password = sender.text ?? ""
        if newPw.text == password {
            pwCheck.textColor = UIColor.black
            pwCheckAlert.isHidden = true
            completeButton.isEnabled = true
            completeButton.backgroundColor = UIColor.black
        } else {
            pwCheck.textColor = UIColor.red
            pwCheckAlert.isHidden = false
        }
    }
    
    @IBAction func completeBtnDidTap(_ sender: Any) {
        let alert = UIAlertController(title: "비밀번호가 재설정되었습니다.", message: nil, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "로그인", style: .default, handler: gotoRootVC)
        
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
    private func gotoRootVC(_ sender: UIAlertAction) {
        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
            let newVC = LoginViewController()
            newVC.modalTransitionStyle = .crossDissolve
            newVC.modalPresentationStyle = .fullScreen
            self.present(newVC, animated: true, completion: nil)
        })
    }
}
