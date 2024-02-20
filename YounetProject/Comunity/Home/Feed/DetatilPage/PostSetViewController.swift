//
//  PostSetViewController.swift
//  YounetProject
//
//  Created by 조혠 on 2/3/24.
//

import UIKit

class PostSetViewController: UIViewController {

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    
    @IBAction func report(_ sender: Any) {
        let storyboard = UIStoryboard(name: "OpenChat", bundle: .main)
        let nextVC = storyboard.instantiateViewController(withIdentifier: "ReportViewController") as! ReportViewController
        nextVC.modalPresentationStyle = .fullScreen
        nextVC.modalTransitionStyle = .crossDissolve
        present(nextVC, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    

}
