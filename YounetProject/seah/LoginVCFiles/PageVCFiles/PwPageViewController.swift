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
    @IBOutlet weak var verifyNumTextField: UITextField!
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var mainStackView: UIStackView!
    
    var secondsLeft: Int = 180
    var timer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
    }
    
    private func setDesign() {
        certifyButton.layer.shadowColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
        certifyButton.layer.masksToBounds = false
        certifyButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        certifyButton.layer.shadowOpacity = 0.25
        certifyButton.layer.shadowRadius = 0
        
        timerLabel.isHidden = true
    }

    // 아이디 TextField 터치 시 밑줄 색상 변경
    @IBAction func IdEditBegin(_ sender: Any) {
        firstLineView.backgroundColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
    }
    @IBAction func IdEditEnd(_ sender: Any) {
        firstLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
        UserDefaults.standard.setValue(idTextField.text, forKey: "idTf_pwSearch")
    }
    
    deinit {
        timer.invalidate()
    }
    
    @IBAction func VerifyButtonDidTap(_ sender: UIButton) {
        let idText = idTextField.text!
        timerLabel.isHidden = false
        // 서버에서 해당 이메일로 인증번호 전송
        SendEmailService.shared.sendEmail(id: idText) { (networkResult) -> (Void) in
            switch networkResult {
            case .success:
                // 타이머 설정
                self.timerLabel.text = "10:00"
                self.setTimer(with: 600) // 초 단위로 입력(TEST)
                self.timerLabel.textColor = UIColor.darkGray
                self.timerLabel.font = UIFont(name: "Inter-Regular", size: 13)
                // 알림 팝업 설정
                let pwSucceedPopup = PopupViewController.present(parent: self)
                pwSucceedPopup.labelText = "\n가입 시 입력하신 이메일로\n인증번호가 발송되었습니다.\n"
            case .requestErr:
                self.timerLabel.textColor = UIColor.red
                self.timerLabel.font = UIFont(name: "Inter-Regular", size: 12)
                self.timerLabel.text = "해당 아이디는 가입되어 있지 않습니다."
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }


    
    
    // 인증번호 TextField 터치 시 밑줄 색상 변경
    @IBAction func VerifyNumEditBegin(_ sender: Any) {
        secondLineView.backgroundColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
    }
    @IBAction func VerifyNumEditEnd(_ sender: Any) {
        secondLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
        UserDefaults.standard.setValue(verifyNumTextField.text, forKey: "verifyNumTf_pwSearch")
    }

    private func setTimer(with countDownSeconds: Int) {
        let startTime = Date()
        timer.invalidate()
        
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [weak self] timer in
            let elapsedTimeSeconds = Int(Date().timeIntervalSince(startTime))
            let remainSeconds = countDownSeconds - elapsedTimeSeconds
            guard remainSeconds >= 0 else {
                timer.invalidate()
                self?.timerLabel.text = "인증시간 초과로 재인증 부탁드립니다."
                self?.timerLabel.font = UIFont(name: "Inter-Regular", size: 12)
                self?.timerLabel.textColor = UIColor.red
                return
            }
            let minutes = remainSeconds / 60
            let seconds = remainSeconds % 60
            
            self?.timerLabel.text = String(format: "%02d:%02d", minutes, seconds)
        })
    }
    
}
