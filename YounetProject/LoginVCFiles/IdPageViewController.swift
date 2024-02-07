//
//  IdPageViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/28/24.
//

import UIKit

class IdPageViewController: UIViewController {
    @IBOutlet weak var firstLineView: UIView!
    @IBOutlet weak var secondLineView: UIView!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // 이름 TextField 터치 시 밑줄 색상 변경
    
    @IBAction func nameEditBegin(_ sender: Any) {
        firstLineView.backgroundColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
    }
    @IBAction func nameEditEnd(_ sender: Any) {
        firstLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
    }
    
    // 이메일 TextField 터치 시 밑줄 색상 변경
    @IBAction func EmailEditBegin(_ sender: Any) {
        secondLineView.backgroundColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
    }
    @IBAction func EmailEditEnd(_ sender: Any) {
        secondLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
    }
    
}
