//
//  ServerSelectVC.swift
//  YounetProject
//
//  Created by 김제훈 on 1/5/24.
//

import UIKit

class ServerSelectVC: UIViewController {
    @IBOutlet var communityButton: UIButton!
    @IBOutlet var openChatButton: UIButton!
    
    override func viewDidLoad() 
    {
        super.viewDidLoad()
        
        config()
    }
    
    private func config() 
    {
        communityButton.addTarget(self, action: #selector(communityBtnClicked(_:)), for: .touchUpInside)
        openChatButton.addTarget(self, action: #selector(openChatBtnClicked(_:)), for: .touchUpInside)
    }
    
    @objc
    private func communityBtnClicked(_ sender: UIButton) {
        // 커뮤니티 버튼 누르면 커뮤니티 화면으로 이동
    }
    
    @objc 
    func openChatBtnClicked(_ sender: UIButton) {
        
        UIAlertController.presentAlert2(self, onBtnClicked: { selector in
            switch selector
            {
            case .YES:
                print(#fileID, #function, #line, "- YES")
            case .NO:
                print(#fileID, #function, #line, "- NO")
            }
            
        }, msg: "본인 인증 전에는 이용할 수 없습니다.")
        // 오픈 채팅 버튼 -> 본인인증 안했으면 본인인증 팝업
        // 본인인증 했으나 아직 대기중이면 대기중 팝업
        // 본인인증 완료면 채팅창으로 넘어감
    }
}

extension ServerSelectVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        
        return tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) ?? UITableViewCell()
    }
    
    
}

class AlertTVCell: UITableViewCell {
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}
