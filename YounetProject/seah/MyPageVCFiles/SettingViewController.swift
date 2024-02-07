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
        let presentedPopup = PopupChoiceViewController.present(parent: self)
        presentedPopup.confirmDismissed = { [weak self] () in self?.transitionVC() }
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
        UserDefaults.standard.setValue(messageSwitch.isOn, forKey: "messageSwitch")
        dismiss(animated: true, completion: nil)
    }

}
