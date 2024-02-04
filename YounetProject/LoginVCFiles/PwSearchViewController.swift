//
//  PwSearchViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/9/24.
//

import UIKit

class PwSearchViewController: UIViewController {
    
    let alert = UIAlertController(title: "입력하신 이메일로\n인증 번호가 발송되었습니다.", message: nil, preferredStyle: .alert)
    let alertAction = UIAlertAction(title: "확인", style: .default, handler: nil)

    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboard()
    }
    
    @IBAction func backBtnDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func confirmBtnDidtap(_ sender: Any) {
        alertAction.setValue(UIColor.black, forKey: "titleTextColor")
        alert.addAction(alertAction)
        self.present(alert, animated: true)
    }
    
}
