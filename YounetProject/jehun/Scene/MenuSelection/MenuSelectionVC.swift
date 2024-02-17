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
        // 커뮤니티 화면으로 이동 navigation control
        APIService.shared.checkIdentification(completion: { result in
            if result 
            {
                print(#fileID, #function, #line, "- Success")
            }
            else 
            {
                print(#fileID, #function, #line, "- Fail")
            }
        })
    }
    @objc private func openChatBtnClicked(_ sender: UIButton)
    {
        var isValid = false // 임시 값
        if (isValid) // 사용자의 본인인증 상태에 따라서 오픈채팅방으로 들어가는 로직을 변경해야 함
        {
            
        }
        else
        {
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
}
