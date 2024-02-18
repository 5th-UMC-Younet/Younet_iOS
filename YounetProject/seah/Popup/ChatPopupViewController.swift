//
//  ChatPopupViewController.swift
//  YounetProject
//
//  Created by 김세아 on 2/6/24.
//

import UIKit

class ChatPopupViewController: UIViewController {

    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var leftBtn: UIButton!
    @IBOutlet weak var rightBtn: UIButton!
    
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var nationImgContainer: UIView!
    @IBOutlet weak var preferNationImage: UIImageView!
    @IBOutlet weak var univOrNationLabel: UILabel!
    @IBOutlet weak var selfExplainLabel: UILabel!
    
    var rightDismissed: (() -> Void)? = nil
    var leftDismissed: (() -> Void)? = nil
    
    // 실명프로필인 경우 setPopup = 0, 익명프로필인 경우 setPopup = 1
    var setPopupNumber = 0
    
    let simpleData = UserDefaults.standard
    let imageData = ImageFileManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        config()
        
        nationImgContainer.layer.borderColor = UIColor.lightGray.cgColor
        nationImgContainer.layer.borderWidth = 0.25
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getUserDefaults()
    }
    
    private func config() {
        closeBtn.addTarget(self, action: #selector(closeBtnClicked), for: .touchUpInside)
        leftBtn.addTarget(self, action: #selector(leftBtnClicked), for: .touchUpInside)
        rightBtn.addTarget(self, action: #selector(rightBtnClicked), for: .touchUpInside)
    }
    
    private func getUserDefaults() {
        // 왼쪽 버튼은 공통으로 신고하기 button
        leftDismissed = { [weak self] () in self?.goReport() }
        
        OpenChatProfileService.shared.OpenChatProfile(userId: 1, chatRoomId: 1){(networkResult) -> (Void) in
            switch networkResult {
            case .success(let result):
                if self.setPopupNumber == 0 {
                    if let ChatProfileData = result as? ChatRealNameProfileData {
                        // 실명프로필인 경우 서버에서 이름, 본교, 유학국, 교환교 데이터 수신
                        self.nationImgContainer.isHidden = true
                        
                        if ChatProfileData.profilePicture != nil {
                            let url = URL(string: ChatProfileData.profilePicture!)
                            self.profileImage.load(url: url!)
                        }
                        
                        self.nameLabel.text = ChatProfileData.name
                        self.univOrNationLabel.text = ChatProfileData.hostSkl
                        self.selfExplainLabel.text = ChatProfileData.profileText
                        self.rightDismissed = { [weak self] () in self?.requestChat() }
                    }
                } else {
                    // 익명프로필인 경우
                    if let ChatProfileData = result as? ChatProfileData {
                        self.nationImgContainer.isHidden = true
                        
                        if ChatProfileData.profilePicture != nil {
                            let url = URL(string: ChatProfileData.profilePicture!)
                            self.profileImage.load(url: url!)
                        }
                        
                        self.nameLabel.text = ChatProfileData.name
                        self.univOrNationLabel.text = ChatProfileData.likeCntr
                        self.selfExplainLabel.text = ChatProfileData.profileText
                        
                        self.rightBtn.setTitle("HOME", for: .normal)
                        self.rightDismissed = { [weak self] () in self?.goHome()
                        }
                    }
                }
            case .requestErr:
                print("400 error")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
            
        }
    }
    
    @objc private func closeBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc private func leftBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: leftDismissed)
    }
    
    @objc private func rightBtnClicked(_ sender: UIButton) {
        self.dismiss(animated: true, completion: rightDismissed)
    }
    
    // dismissed completion 사전 정의
    private func goReport() {
        // 신고 화면으로 전환
        let storyboard = UIStoryboard(name: "ChatProfile", bundle: .main)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true)
    }
    
    private func requestChat() {
        // VC 연결 코드 작성
        print("채팅 요청")
    }
    
    private func goHome() {
        let storyboard = UIStoryboard(name: "ChatProfile", bundle: .main)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "OtherUserProfileViewController") as! OtherUserProfileViewController
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true)
    }

    @discardableResult
    class func present(parent: UIViewController) -> ChatPopupViewController {
        let storyboard = UIStoryboard(name: "ChatPopupViewController", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "ChatPopupViewController") as! ChatPopupViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        parent.present(vc, animated: true)
        return vc
    }

}
