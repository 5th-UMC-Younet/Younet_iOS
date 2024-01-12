//
//  SearchViewController.swift
//  YounetProject
//
//  Created by 조혠 on 1/12/24.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        cancelButton.layer.cornerRadius = 5
        super.viewDidLoad()

    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    


}
