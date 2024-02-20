//
//  MyPageViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/16/24.
//

import UIKit
import Alamofire

class MyPageViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var preferNationLabel: UILabel!
    @IBOutlet weak var selfExplainLabel: UILabel!
    @IBOutlet weak var preferNationImage: UIImageView!
    @IBOutlet weak var nationImgContainer: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var scrapButton: UIButton!
    @IBOutlet weak var postLineView: UIView!
    @IBOutlet weak var scrapLineView: UIView!
    
    let simpleData = UserDefaults.standard
    let imageData = ImageFileManager.shared
    
    var btnLists : [UIButton] = []
    var lineLists : [UIView] = []
    var imageLists : [UIImage] = []
    var currentIndex : Int = 0 {
        didSet {
            changeBtnColor()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        checkExpireTime()
        getData()
    }
    
    private func setDesign() {
        //countryId 리셋
        UserDefaults.standard.setValue(1, forKey: "countryId")
        
        scrapButton.setImage(UIImage(named: "ScrapDefault"), for: .normal)
        scrapButton.tintColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
        scrapLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
        postButton.setImage(UIImage(named: "PostSelected"), for: .normal)
        postButton.tintColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
        postLineView.backgroundColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
        
        nationImgContainer.layer.borderColor = UIColor.lightGray.cgColor
        nationImgContainer.layer.borderWidth = 0.25
        nationImgContainer.isHidden = true
        
        btnLists.append(postButton)
        btnLists.append(scrapButton)
        lineLists.append(postLineView)
        lineLists.append(scrapLineView)
        
        imageLists.append(UIImage(named: "PostSelected")!)
        imageLists.append(UIImage(named: "ScrapSelected")!)
        imageLists.append(UIImage(named: "PostDefault")!)
        imageLists.append(UIImage(named: "ScrapDefault")!)
    }
    
    private func changeBtnColor() {
        for (index, element) in btnLists.enumerated() {
            if index == currentIndex {
                element.tintColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
                element.setImage(imageLists[index], for: .normal)
                lineLists[index].backgroundColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
            } else {
                element.tintColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
                lineLists[index].backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
                element.setImage(imageLists[index + 2], for: .normal)
            }
        }
    }
    
    var pageViewController : TablePageViewController!
    
    @IBAction func postBtnDidtap(_ sender: UIButton) {
        pageViewController?.setViewcontrollersFromIndex(index: 0)
    }
    
    @IBAction func scrapBtnDidtap(_ sender: UIButton) {
        pageViewController?.setViewcontrollersFromIndex(index: 1)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // pageViewController 연결
        if segue.identifier == "tableEmbedSegue" {
            guard let vc = segue.destination as? TablePageViewController else { return }
            pageViewController = vc
            pageViewController.completeHandler = { (result) in
                self.currentIndex = result
            }
        }
    }
   
    private func getData() {
        // 서버에서 받아와서 설정
        MyPageService.shared.MyPage{ (networkResult) -> (Void) in
            switch networkResult {
            case .success(let result):
                if let myPageData = result as? MyPageUserData {
                    if myPageData.userId != nil {
                        self.simpleData.setValue(myPageData.userId, forKey: "myUserId")
                    }
                    
                    // 프로필 세팅
                    self.usernameLabel.text = myPageData.name
                    myPageData.profileText == nil ? (self.selfExplainLabel.text = "프로필 소개글") : (self.selfExplainLabel.text = myPageData.profileText)
                    
                    // 관심 국가명 및 이미지 세팅
                    if self.simpleData.string(forKey: "preferNationImage") != nil {
                        self.preferNationLabel.text = myPageData.likeCntr
                        self.preferNationImage.image = UIImage(named: self.simpleData.string(forKey: "preferNationImage")!)
                        self.nationImgContainer.isHidden = false
                    } else {
                        self.preferNationLabel.text = "관심국가"
                        self.nationImgContainer.isHidden = true
                    }
                    
                    if myPageData.profilePicture != nil {
                        // url로부터 프로필 이미지 받아오기
                        let url = URL(string: myPageData.profilePicture!)
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
    
    @IBAction func BackButtonDidtap(_ sender: Any) {
        dismiss(animated: false)
    }
}

