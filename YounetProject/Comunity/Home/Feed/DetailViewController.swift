//
//  DetailViewController.swift
//  YounetProject
//
//  Created by 조혠 on 1/12/24.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var test: UILabel!
    var num: Int?
    var title1: String?
    var like: Int?
    var comment: Int?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        update()
    }
    func update(){
        if let num = self.num{
            test.text = "\(num+1)"
        }
    }

}
