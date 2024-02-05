//
//  SettingViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/20/24.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var postAlertSwitch: CustomSwitch!
    @IBOutlet weak var messageSwitch: CustomSwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 알림 버튼 데이터 반영
        postAlertSwitch.isOn = UserDefaults.standard.bool(forKey: "postAlertSwitch")
        messageSwitch.isOn = UserDefaults.standard.bool(forKey: "messageSwitch")
    }
    
    @IBAction func logoutBtnDidtap(_ sender: Any) {
        let LogoutAlert = UIAlertController(title: "로그아웃", message: "로그아웃하시겠습니까?", preferredStyle: .alert)
        
        let DefaultAction = UIAlertAction(title: "예", style: .default, handler: { action in
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") else { return }
            nextVC.modalPresentationStyle = .fullScreen
            self.present(nextVC, animated: true)
        })
        
        let CancelAction = UIAlertAction(title: "아니오", style: .destructive)
                
        LogoutAlert.addAction(DefaultAction)
        LogoutAlert.addAction(CancelAction)

        self.present(LogoutAlert, animated: true)
        
    }
    
    // MARK: 알림 버튼 상태 data 전송
    @IBAction func backButtonDidtap(_ sender: UIButton) {
        UserDefaults.standard.setValue(postAlertSwitch.isOn, forKey: "postAlertSwitch")
        UserDefaults.standard.setValue(messageSwitch.isOn, forKey: "messageSwitch")
        dismiss(animated: true, completion: nil)
    }

}
