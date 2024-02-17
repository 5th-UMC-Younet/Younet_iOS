//
//  SettingViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/20/24.
//

import UIKit
import Alamofire

class SettingViewController: UIViewController {

    @IBOutlet weak var postAlertSwitch: CustomSwitch!
    @IBOutlet weak var messageSwitch: CustomSwitch!
    var num = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 알림 버튼 데이터 반영
        setMessageAlarm()
        postAlertSwitch.isOn = UserDefaults.standard.bool(forKey: "postAlertSwitch")
        
        messageSwitch.delegate = self
    }
    
    @IBAction func segueTest(_ sender: Any) {
        let storyboard = UIStoryboard(name: "ChatProfile", bundle: .main)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "tabbarVC") as! UITabBarController
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        
        self.present(nextVC, animated: true)
    }
    
    
    @IBAction func logoutBtnDidtap(_ sender: Any) {
        //카카오 로그아웃인지 서버 회원가입 로그아웃인지 분기 처리
        
        let presentedPopup = PopupChoiceViewController.present(parent: self)
        presentedPopup.confirmDismissed = { [weak self] () in
            LogoutService.shared.Logout{ (networkResult) -> (Void) in
                switch networkResult {
                case .success:
                    // 로그아웃 성공 -> 선택적 data 삭제 구현
                    let tk = TokenUtils()
                    tk.delete(APIUrl.url, account: "accessToken")
                    tk.delete(APIUrl.url, account: "refreshToken")
                    UserDefaults.standard.removeObject(forKey: "tokenExpireTime")
                    
                    // 맨 처음 로그인 화면으로 이동
                    self?.transitionVC()
                case .requestErr:
                    print("400 Error")
                case .pathErr:
                    print("pathErr")
                case .serverErr:
                    print("serverErr")
                case .networkFail:
                    print("networkFail")
                }
            }
        }
    }
    
    private func setMessageAlarm() {
        let AD = UIApplication.shared.delegate as? AppDelegate
        if AD?.alarmNum == 1 {
            messageSwitch.isOn = true
        } else {
            messageSwitch.isOn = false
        }
    }
    
    private func transitionVC() {
        let storyboard = UIStoryboard(name: "Main", bundle: .main)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "LoginVC") as! LoginViewController
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true)
    }
    
    // MARK: 알림 버튼 상태 data 전송
    @IBAction func backButtonDidtap(_ sender: UIButton) {
        UserDefaults.standard.setValue(postAlertSwitch.isOn, forKey: "postAlertSwitch")
        dismiss(animated: true, completion: nil)
    }

}

extension SettingViewController: SwitchButtonDelegate {
    func isOnValueChange(isOn: Bool) {
        num += 1
        
        if messageSwitch.isOn && (num >= 2){
            let presentPopup = PopupChoiceViewController.present(parent: self)
            presentPopup.titleText = "알림 설정"
            presentPopup.labelText = "설정에서 알림을 제어해 주새요."
            presentPopup.confirmText = "설정"
            presentPopup.rejectText = "취소"
            presentPopup.confirmDismissed = {
                UIApplication.shared.registerForRemoteNotifications()
                UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
            }
            presentPopup.rejectDismissed = { self.messageSwitch.setOn(on: false, animated: true) }
        } else {
            UIApplication.shared.unregisterForRemoteNotifications()
        }
        
        return
    }
    
}
