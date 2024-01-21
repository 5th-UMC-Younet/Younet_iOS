//
//  SettingViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/20/24.
//

import UIKit

class SettingViewController: UIViewController {

    @IBOutlet weak var messageSwitch: CustomSwitch!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func logoutBtnDidtap(_ sender: Any) {
        let LogoutAlert = UIAlertController(title: "로그아웃", message: "로그아웃하시겠습니까?", preferredStyle: .alert)
        
        let DefaultAction = UIAlertAction(title: "예", style: .default, handler: { action in
            guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC") else { return }
            nextVC.modalPresentationStyle = .fullScreen
            //인자값으로 뷰 컨트롤러 인스턴스를 넣고 프레젠트 메소드 호출
            self.present(nextVC, animated: true)
        })
        
        let CancelAction = UIAlertAction(title: "아니오", style: .destructive)
                
        LogoutAlert.addAction(DefaultAction)
        LogoutAlert.addAction(CancelAction)

        self.present(LogoutAlert, animated: true)
        
    }
    @IBAction func backButtonDidtap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
