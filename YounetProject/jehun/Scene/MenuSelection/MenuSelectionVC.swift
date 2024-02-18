//
//  IdentificationVC.swift
//  YounetProject
//
//  Created by 김제훈 on 2/7/24.
//

import UIKit

class MenuSelectionVC: UIViewController
{
    @IBOutlet var communityBtn: UIButton!
    @IBOutlet var openChatBtn: UIButton!
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        self.config()
    }
    
    private func config()
    {
        // communityBtn
        communityBtn.layer.cornerRadius = 10
        communityBtn.addTarget(self, action: #selector(communityBtnClicked(_:)), for: .touchUpInside)
        
        // openChatBtn
        openChatBtn.layer.cornerRadius = 10
        openChatBtn.addTarget(self, action: #selector(openChatBtnClicked(_:)), for: .touchUpInside)
        
    }
    
    @objc private func communityBtnClicked(_ sender: UIButton)
    {
        // 커뮤니티 화면으로 이동
        let nextSB = UIStoryboard(name: "Comunity", bundle: nil)
        guard let nextVC = nextSB.instantiateViewController(withIdentifier: "tabC") as? CustomTabBarViewController else { return }
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        present(nextVC, animated: true, completion: nil)
        
    }
    
    @objc private func openChatBtnClicked(_ sender: UIButton)
    {
        // 오픈채팅 화면으로 이동(테스트용)
        let nextSB = UIStoryboard(name: "OpenChat", bundle: nil)
        guard let nextVC = nextSB.instantiateViewController(withIdentifier: "TabBarVC") as? UITabBarController else { return }
        
        nextVC.modalTransitionStyle = .crossDissolve
        nextVC.modalPresentationStyle = .fullScreen
        present(nextVC, animated: true, completion: nil)
        
        
        // 테스트를 위해 아래 본인인증 검증 부분 주석 처리
        /* APIService.shared.checkIdentification(completion: { result in
            if result
            {
                // 성공한 경우 오픈채팅 화면으로 이동
                print(#fileID, #function, #line, "- Success")
                
                self.dismiss(animated: false, completion: {
                    let nextSB = UIStoryboard(name: "OpenChat", bundle: nil)
                    guard let nextVC = nextSB.instantiateViewController(withIdentifier: "TabBarVC") as? UITabBarController else { return }
                    nextVC.modalTransitionStyle = .crossDissolve
                    nextVC.modalPresentationStyle = .fullScreen
                    self.present(nextVC, animated: true, completion: nil)
                })
                
            } 
            else
            {
                print(#fileID, #function, #line, "- Fail")
                
                let popup = DefaultPopup.present(parent: self, contentStr: "본인 인증 전에는\n이용할 수 없습니다.", btnTitleStr: "본인 인증 하기")
                popup.onDismissed = { [weak self] () in
                    // 본인 인증 화면으로 전환
                    let identificationVC = UIStoryboard(name: "IdentificationVC", bundle: .main).instantiateViewController(withIdentifier: "IdentificationVC")
                    identificationVC.navigationItem.title = "본인 인증"
                    self?.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.font: UIFont(name:"Inter-Bold", size:17.0)!]
                    self?.navigationController?.pushViewController(identificationVC, animated: true)
                    
                    }
                }
            }
        )*/
    }
    
    
}
