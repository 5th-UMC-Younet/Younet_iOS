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
    @IBOutlet weak var firstLineView: UIView!
    @IBOutlet weak var secondLineView: UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialDesignSetting()
        setKeyboard()
        
    }
    
    func initialDesignSetting() {
        pwCheckAlert.isHidden = true
        newPwAlert.isHidden = true
        completeButton.isEnabled = false
        completeButton.backgroundColor = #colorLiteral(red: 0.8313595057, green: 0.8745134473, blue: 0.9882282615, alpha: 1)
    }
    
    // 뒤로가기 버튼 터치 시
    @IBAction func backBtnDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    // 각 TextField 선택 및 입력 종료시 아래 줄 색상 변경    
    @IBAction func newPwEditBegin(_ sender: Any) {
        firstLineView.backgroundColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
    }
    
    @IBAction func newPwEditEnd(_ sender: Any) {
        if newPwAlert.isHidden == false {
            firstLineView.backgroundColor = UIColor.red
        } else {
            firstLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
        }
    }
    
    @IBAction func PwCheckEditBegin(_ sender: Any) {
        secondLineView.backgroundColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
    }
    
    @IBAction func PwCheckEditEnd(_ sender: Any) {
        if pwCheckAlert.isHidden == false {
            secondLineView.backgroundColor = UIColor.red
        } else {
            secondLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
        }
    }
    
    
    // 비밀번호 TextField 변경 시
    @IBAction func newPwTfChanged(_ sender: UITextField) {
        let newPwText = sender.text ?? ""
        let regularExpression = "^(?=.*[A-Za-z])(?=.*[0-9])(?=.*[!@#$%^&*()_+=-]).{8,50}"
        let pwValidaition = NSPredicate.init(format: "SELF MATCHES %@", regularExpression)
        let validateResult = pwValidaition.evaluate(with: newPwText)
        
        // 비밀번호 확인 TextField까지 작성하고 난 뒤 새 비밀번호 TextField란을 수정하는 경우
        if pwCheck.text!.count >= 1 && newPwText != pwCheck.text{
            pwCheck.textColor = UIColor.red
            pwCheckAlert.isHidden = false
            secondLineView.backgroundColor = UIColor.red
            completeButton.isEnabled = false
            completeButton.backgroundColor = #colorLiteral(red: 0.8313595057, green: 0.8745134473, blue: 0.9882282615, alpha: 1)
        } else if newPwText == pwCheck.text {
            pwCheck.textColor = UIColor.black
            pwCheckAlert.isHidden = true
            secondLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
            completeButton.isEnabled = true
            completeButton.backgroundColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
        }
        
        if validateResult == true || newPwText.count <= 1 {
            // 비밀번호 기준에 맞을 때
            newPwAlert.isHidden = true
            firstLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
            newPw.textColor = UIColor.black
        } else {
            // 비밀번호 기준에 맞지 않을 때
            newPwAlert.isHidden = false
            firstLineView.backgroundColor = UIColor.red
            newPw.textColor = UIColor.red
        }
    }
    
    
    @IBAction func pwCheckTfChanged(_ sender: UITextField) {
        let password = sender.text ?? ""
        if newPw.text == password {
            pwCheck.textColor = UIColor.black
            pwCheckAlert.isHidden = true
            secondLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
            completeButton.isEnabled = true
            completeButton.backgroundColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
        } else {
            pwCheck.textColor = UIColor.red
            pwCheckAlert.isHidden = false
            secondLineView.backgroundColor = UIColor.red
        }
    }
    
    @IBAction func completeBtnDidTap(_ sender: Any) {
        //self.present(alert, animated: true)
        openSelectNationPopup()
    }
    
    private func gotoRootVC() {
        self.view.window?.rootViewController?.dismiss(animated: false, completion: {
            let newVC = LoginViewController()
            newVC.modalTransitionStyle = .crossDissolve
            newVC.modalPresentationStyle = .fullScreen
            self.present(newVC, animated: true, completion: nil)
        })
    }
    
    @objc private func openSelectNationPopup(){
        let presentedPopup = PopupViewController.present(parent: self)
        presentedPopup.labelText = "완료"
        presentedPopup.onDismissed = {
            self.gotoRootVC()
        }
    }
    
    
}
