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
    var setPopupNumber: Int? = 0
    
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
        // 프로필 이미지와 소개글은 전체 팝업 공유
        UserDefaults.standard.string(forKey: "selfExplain") != nil ? (selfExplainLabel.text = UserDefaults.standard.string(forKey: "selfExplain")) : (selfExplainLabel.text = "프로필 소개글")
        if ImageFileManager.shared.getSavedImage(named: "profileImage") != nil {
            profileImage.image = ImageFileManager.shared.getSavedImage(named: "profileImage")
        }
        leftDismissed = { [weak self] () in self?.goReport() }
        
        if setPopupNumber == 0 {
            // 실명프로필인 경우 서버에서 데이터 수신
            nationImgContainer.isHidden = true
            nameLabel.text = "실명"
            univOrNationLabel.text = "OO대학교"
            rightDismissed = { [weak self] () in self?.requestChat() }
            
        } else {
            // 익명프로필인 경우
            UserDefaults.standard.string(forKey: "nickname") != nil ? (nameLabel.text = UserDefaults.standard.string(forKey: "nickname")) : (nameLabel.text = "닉네임")
            UserDefaults.standard.string(forKey: "preferNation") != nil ? (univOrNationLabel.text = UserDefaults.standard.string(forKey: "preferNation")) : (univOrNationLabel.text = "관심국가")
            UserDefaults.standard.string(forKey: "preferNationImage") != nil ? (preferNationImage.image = UIImage(named: UserDefaults.standard.string(forKey: "preferNationImage")!)) : nil
            
            if UserDefaults.standard.string(forKey: "preferNation") == nil {
                nationImgContainer.isHidden = true
            } else {
                nationImgContainer.isHidden = false
            }
            
            rightBtn.setTitle("HOME", for: .normal)
            rightDismissed = { [weak self] () in self?.goHome() }
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
    class func present(parent: UIViewController) -> PopupChoiceViewController {
        let storyboard = UIStoryboard(name: "PopupChoiceViewController", bundle: .main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PopupChoiceViewController") as! PopupChoiceViewController
        
        vc.modalPresentationStyle = .overCurrentContext
        vc.modalTransitionStyle = .crossDissolve
        
        parent.present(vc, animated: true)
        return vc
    }

}
