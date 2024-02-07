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
        super.viewDidLoad()
        setDesign()
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
        simpleData.string(forKey: "preferNation") == nil ? (nationContainer.isHidden = true) : (nationContainer.isHidden = false)

        imageData.getSavedImage(named: "profileImage_realName") != nil ? profileImage.image = imageData.getSavedImage(named: "profileImage_realName") : nil
        simpleData.string(forKey: "selfExplain_realName") != nil ? selfExplain.text = simpleData.string(forKey: "selfExplain_realName") : nil
        // university, realName 서버에서 받아와서 등록
        
        imageData.getSavedImage(named: "profileImage") != nil ? nickNameProfileImage.image = imageData.getSavedImage(named: "profileImage") : nil
        simpleData.string(forKey: "nickname") != nil ? nickName.text = simpleData.string(forKey: "nickname") : nil
        simpleData.string(forKey: "preferNationImage") != nil ? preferNationImage.image = UIImage(named: simpleData.string(forKey: "preferNationImage")!) : nil
        simpleData.string(forKey: "preferNation") != nil ? preferNation.text = simpleData.string(forKey: "preferNation") : nil
        simpleData.string(forKey: "selfExplain") != nil ? nickNameSelfExplain.text = simpleData.string(forKey: "selfExplain") : nil
    }
    
    @IBAction func settingBtnDidtap(_ sender: UIButton) {
        let storyboard = UIStoryboard(name: "MyPage", bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: "SettingViewController")
        newVC.modalTransitionStyle = .crossDissolve
        newVC.modalPresentationStyle = .fullScreen
        self.present(newVC, animated: true, completion: nil)
    }
    
    @IBAction func popupTest1(_ sender: UIButton) {
        let presentedPopup = ChatPopupViewController.present(parent: self)
    }
    
    @IBAction func popupTest2(_ sender: UIButton) {
        let presentedPopup = ChatPopupViewController.present(parent: self)
    }
}
