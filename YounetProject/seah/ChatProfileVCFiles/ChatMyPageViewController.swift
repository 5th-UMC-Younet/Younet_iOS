//
//  ChatMyPageViewController.swift
//  YounetProject
//
//  Created by 김세아 on 2/6/24.
//

import UIKit

class ChatMyPageViewController: UIViewController {

    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var realName: UILabel!
    @IBOutlet weak var university: UILabel!
    @IBOutlet weak var selfExplain: UILabel!
    
    @IBOutlet weak var nickNameProfileImage: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var nationContainer: UIView!
    @IBOutlet weak var preferNationImage: UIImageView!
    @IBOutlet weak var preferNation: UILabel!
    @IBOutlet weak var nickNameSelfExplain: UILabel!
    
    @IBOutlet weak var nameProfileView: UIView!
    @IBOutlet weak var nickNameProfileView: UIView!
    
    let simpleData = UserDefaults.standard
    let imageData = ImageFileManager.shared
    var myUserId = 1
    
    override func viewDidLoad() {
        setDesign()
        let userIdInt: Int? = UserDefaults.standard.integer(forKey: "myUserId")
        if let userId = userIdInt {
            myUserId = userId
        }
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        getRealNameData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkExpireTime()
        getRealNameData()
    }
    
    private func setDesign() {
        // 프로필 view에 그림자 넣기
        nameProfileView.layer.masksToBounds = false
        nameProfileView.layer.shadowColor = UIColor.black.cgColor
        nameProfileView.layer.shadowOffset = CGSize(width: 0, height: 2)
        nameProfileView.layer.shadowOpacity = 0.25
        
        nickNameProfileView.layer.masksToBounds = false
        nickNameProfileView.layer.shadowColor = UIColor.black.cgColor
        nickNameProfileView.layer.shadowOffset = CGSize(width: 0, height: 2)
        nickNameProfileView.layer.shadowOpacity = 0.25
        
        nationContainer.layer.borderColor = UIColor.lightGray.cgColor
        nationContainer.layer.borderWidth = 0.25
    }

    private func getData() {
        // 익명 프로필 연결
        MyPageService.shared.MyPage{ (networkResult) -> (Void) in
            switch networkResult {
            case .success(let result):
                if let myPageData = result as? MyPageUserData {
                    if myPageData.userId != nil {
                        self.simpleData.setValue(myPageData.userId, forKey: "myUserId")
                    }
                    
                    // 프로필 세팅
                    self.nickName.text = myPageData.name
                    myPageData.profileText == nil ? (self.nickNameSelfExplain.text = "프로필 소개글") : (self.nickNameSelfExplain.text = myPageData.profileText)
                    
                    // 관심 국가명 및 이미지 세팅
                    if self.simpleData.string(forKey: "preferNationImage") != nil {
                        self.preferNation.text = myPageData.likeCntr
                        self.preferNationImage.image = UIImage(named: self.simpleData.string(forKey: "preferNationImage")!)
                        self.nationContainer.isHidden = false
                    } else {
                        self.preferNation.text = "관심국가"
                        self.nationContainer.isHidden = true
                    }
                    
                    if myPageData.profilePicture != nil {
                        // url로부터 프로필 이미지 받아오기
                        let url = URL(string: myPageData.profilePicture!)
                        self.nickNameProfileImage.load(url: url!)
                    }
                    
                }
            case .requestErr:
                print("400 Error")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    private func getRealNameData(){
        print("실명프로필 연결")
        // 실명 프로필 연결
        RealNameProfileService.shared.RealNameProfile(userId: myUserId){ (networkResult) -> (Void) in
            switch networkResult {
            case .success(let result):
                if let realNameData = result as? RealNameProfileData {
                    // 이름 및 프로필 소개글 설정
                    self.realName.text = realNameData.name
                    realNameData.profileText == nil ? (self.selfExplain.text = "프로필 소개글") : (self.selfExplain.text = realNameData.profileText)
                    
                    // 본교 설정
                    realNameData.hostSkl == nil ? (self.university.text = "대학교") : (self.university.text = realNameData.hostSkl)
                    
                    if realNameData.profilePicture != nil {
                        // url로부터 프로필 이미지 받아오기
                        let url = URL(string: realNameData.profilePicture!)
                        self.profileImage.load(url: url!)
                    }
                }
            case .requestErr:
                print("400 Error")
            case .pathErr:
                print("pathErr")
            case .serverErr:
                print("serverErr")
            case .networkFail:
                print("networkFail")
            }
        }
    }
    
    @IBAction func settingBtnDidtap(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "Comunity", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "SettingViewController")
        newVC.modalTransitionStyle = .crossDissolve
        newVC.modalPresentationStyle = .fullScreen
        self.present(newVC, animated: true, completion: nil)
    }
    
    @IBAction func popupTest1(_ sender: UIButton) {
        let presentedPopup = ChatPopupViewController.present(parent: self)
        presentedPopup.setPopupNumber = 1
        presentedPopup.leftDismissed = { self.goReport() }
        presentedPopup.rightDismissed = { self.goHome() }
    }
    
    @IBAction func popupTest2(_ sender: UIButton) {
        let presentedPopup = ChatPopupViewController.present(parent: self)
        presentedPopup.setPopupNumber = 0
        presentedPopup.leftDismissed = { self.goReport() }
        presentedPopup.rightDismissed = { self.requestChat() }
    }
    
    private func goReport() {
        // 신고 화면으로 전환
        let storyboard = UIStoryboard(name: "OpenChat", bundle: .main)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        present(nextVC, animated: true)
    }
    
    private func requestChat() {
        // VC 연결 코드 작성
        print("채팅 요청")
    }
    
    private func goHome() {
        let storyboard = UIStoryboard(name: "OpenChat", bundle: .main)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "OtherUserProfileViewController") as! OtherUserProfileViewController
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        self.present(nextVC, animated: true)
    }
    
    @IBAction func backButtonDidtap(_ sender: Any) {
        dismiss(animated: false)
    }
    
}
