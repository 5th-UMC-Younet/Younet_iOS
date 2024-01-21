//
//  QuitViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/21/24.
//

import UIKit

class QuitViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    @IBAction func backButtonDidtap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }

}
