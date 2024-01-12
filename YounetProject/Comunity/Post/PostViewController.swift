//
//  PostViewController.swift
//  YounetProject
//
//  Created by 조혠 on 1/9/24.
//

import UIKit

class PostViewController: UIViewController {
    @IBOutlet weak var category: UIButton!
    
    
    override func viewDidLoad() {
        let life = UIAction(title: "유학생활", handler: { _ in self.categorySelect(data: 1) })
        let prepare = UIAction(title: "유학준비", handler: { _ in self.categorySelect(data: 2) })
        let trade = UIAction(title: "중고거래", handler: { _ in self.categorySelect(data: 3) })
        let travel = UIAction(title: "여행", handler: { _ in self.categorySelect(data: 4) })
        let etc = UIAction(title: "기타", handler: { _ in self.categorySelect(data: 5) })
        let buttonMenu = UIMenu(title: "", children: [life,prepare,trade,travel,etc])
        category.menu = buttonMenu
        
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
    
    
    
}
