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
    
    override func viewDidLoad() {
        getData()
        setDesign()
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        
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
        // 실명프로필 별도 API 연결
        simpleData.string(forKey: "preferNation") == nil ? (nationContainer.isHidden = true) : (nationContainer.isHidden = false)

        imageData.getSavedImage(named: "profileImage_realName") != nil ? profileImage.image = imageData.getSavedImage(named: "profileImage_realName") : nil
        simpleData.string(forKey: "selfExplain_realName") != nil ? selfExplain.text = simpleData.string(forKey: "selfExplain_realName") : nil
        // university, realName 서버에서 받아와서 등록
        
        MyPageService.shared.MyPage{ (networkResult) -> (Void) in
            switch networkResult {
            case .success(let result):
                if let myPageData = result as? MyPageUserData {
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
    }
    
    @IBAction func popupTest2(_ sender: UIButton) {
        let presentedPopup = ChatPopupViewController.present(parent: self)
        presentedPopup.setPopupNumber = 0
    }
}
