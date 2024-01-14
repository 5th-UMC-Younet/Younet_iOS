//
//  ViewController.swift
//  YounetProject
//
//  Created by 김제훈 on 1/5/24.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
        /// 수정내용
    
    // NavigationBar 뒤로가기 버튼 기능
    @IBAction func backBtnDidTap(_ sender: UIBarButtonItem) {
        self.navigationController?.popViewController(animated: true)
    }
}


/* extension UITextField {
    func addLeftPadding() {
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: self.frame.height))
        self.leftView = paddingView
        self.leftViewMode = ViewMode.always
      }
}*/
