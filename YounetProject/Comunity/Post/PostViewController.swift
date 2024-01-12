//
//  PostViewController.swift
//  YounetProject
//
//  Created by 조혠 on 1/9/24.
//

import UIKit

class PostViewController: UIViewController {
    @IBOutlet weak var category: UIButton!
    @IBOutlet weak var titleField: UITextField!
    
    var currentCategory: Int?
    
    
    override func viewDidLoad() {
        //카테고리 메뉴
        let life = UIAction(title: "유학생활", handler: { _ in self.categorySelect(data: 1) })
        let prepare = UIAction(title: "유학준비", handler: { _ in self.categorySelect(data: 2) })
        let trade = UIAction(title: "중고거래", handler: { _ in self.categorySelect(data: 3) })
        let travel = UIAction(title: "여행", handler: { _ in self.categorySelect(data: 4) })
        let etc = UIAction(title: "기타", handler: { _ in self.categorySelect(data: 5) })
        let buttonMenu = UIMenu(title: "", children: [life,prepare,trade,travel,etc])
        category.menu = buttonMenu
        
        //제목
        titleField.borderStyle = .none
        let border = CALayer()
        border.frame = CGRect(x: 0, y: titleField.frame.size.height - 1, width: titleField.frame.width, height: 1)
        border.borderColor = UIColor.darkGray.cgColor
        border.borderWidth = 1.0 // 추가: 밑줄 두께
        titleField.layer.addSublayer(border)
        titleField.layer.masksToBounds = true

        super.viewDidLoad()
        tabBarController?.tabBar.isHidden = true
    }
    //카테고리
    func categorySelect(data: Int){
        switch data{
        case 1:
            print("1")
            break
        case 2:
            print("2")
            break
        case 3:
            print("3")
            break
        case 4:
            print("4")
            break
        case 5:
            print("5")
            break
        default:
            break
        }
        
    }
    
    //취소
    @IBAction func backButton(_ sender: Any) {
        guard let back = storyboard?.instantiateViewController(identifier: "tabC") as? TabBarController else{
            return
        }
        back.modalTransitionStyle = .crossDissolve
        back.modalPresentationStyle = .fullScreen
        present(back, animated: true, completion: nil)
    }
    //등록
    @IBAction func done(_ sender: Any) {
        //데이터 전송 추가
    }
    //사진
    @IBAction func goAlbum(_ sender: Any) {
        //앨범 열기 추가
    }
    
    
}
