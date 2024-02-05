//
//  ChatMyPageViewController.swift
//  YounetProject
//
//  Created by 김세아 on 2/6/24.
//

import UIKit

class ChatMyPageViewController: UIViewController {

    @IBOutlet weak var nameProfileView: UIView!
    @IBOutlet weak var nickNameProfileView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setDesign()
    }
    
    private func setDesign() {
        nameProfileView.layer.masksToBounds = false
        nameProfileView.layer.shadowColor = UIColor.black.cgColor
        nameProfileView.layer.shadowOffset = CGSize(width: 0, height: 2)
        nameProfileView.layer.shadowOpacity = 0.25
        
        nickNameProfileView.layer.masksToBounds = false
        nickNameProfileView.layer.shadowColor = UIColor.black.cgColor
        nickNameProfileView.layer.shadowOffset = CGSize(width: 0, height: 2)
        nickNameProfileView.layer.shadowOpacity = 0.25
    }

}
