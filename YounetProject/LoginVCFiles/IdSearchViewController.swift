//
//  IdSearchViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/9/24.
//

import UIKit

var idName: String = "<아이디>"

class IdSearchViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setKeyboard()
    }
    
    @IBAction func backBtnDidTap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func IdSearchBtnDidtap(_ sender: UIButton) {
        let failAlert = UIAlertController(title: "관련된 아이디가 존재하지 않습니다.", message: nil, preferredStyle: .alert)
        let failAlertAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        let succeedAlert = UIAlertController(title: "회원님의 아이디는 '\(idName)' 입니다.", message: nil, preferredStyle: .alert)
        let succeedAlertAction = UIAlertAction(title: "로그인", style: .default, handler: gotoRootVC)
        
        // alert button 색상 설정 및 action 추가
        failAlertAction.setValue(UIColor.black, forKey: "titleTextColor")
        failAlert.addAction(failAlertAction)
        succeedAlertAction.setValue(UIColor.black, forKey: "titleTextColor")
        succeedAlert.addAction(succeedAlertAction)
        
        self.present(succeedAlert, animated: true)
        
    }
    
    private func gotoRootVC(_ sender: UIAlertAction) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
}
