//
//  CountrySelectionViewController.swift
//  YounetProject
//
//  Created by 조혠 on 1/9/24.
//

import UIKit

class CountrySelectionViewController: UIViewController {
    @IBOutlet var country: [UIButton]! //좌->우/상->하
    var index: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func countrySelection(_ sender: UIButton) {
        index = country.firstIndex(of: sender)
        print(country[index!].titleLabel?.text ?? "0")
        //해당 국가로 데이터 변경하는 코드 추가 필요
        self.dismiss(animated: true, completion: nil)
    }
    
}
