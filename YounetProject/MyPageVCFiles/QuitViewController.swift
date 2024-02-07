//
//  QuitViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/21/24.
//

import UIKit

class QuitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func quitButtonDidtap(_ sender: UIButton) {
        // 회원 탈퇴 : 데이터 삭제
        deleteData()
        
        let presentedPopup = PopupViewController.present(parent: self)
        presentedPopup.labelText = "\n탈퇴가 완료되었습니다.\n"
        presentedPopup.onDismissed = { self.transitionVC() }
        
    }
    
    @IBAction func backButtonDidtap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

    private func deleteData() {
        // UserDefaults 데이터 전체 삭제
        for key in UserDefaults.standard.dictionaryRepresentation().keys {
                    UserDefaults.standard.removeObject(forKey: key.description)
                }
        // FileManager Profile Image 삭제
        ImageFileManager.shared.deleteImage(named: "profileImage") { onSuccess in return }
    }
    
    private func transitionVC() {
        let nextSB = UIStoryboard(name: "Main", bundle: nil)
        guard let nextVC = nextSB.instantiateViewController(withIdentifier: "LoginVC") as? LoginViewController else { return }
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true, completion: nil)
    }
}
