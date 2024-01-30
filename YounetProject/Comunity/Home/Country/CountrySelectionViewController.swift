//
//  CountrySelectionViewController.swift
//  YounetProject
//
//  Created by 조혠 on 1/9/24.
//

import UIKit
protocol SelectButtonDelegate: AnyObject{
    func selection(_ data: Int)
}
class CountrySelectionViewController: UIViewController {
    weak var delegate: SelectButtonDelegate?
    @IBOutlet var country: [UIButton]!
    //좌->우/상->하
    var index: Int?
    @IBAction func countrySelection(_ sender: UIButton) {
        index = country.firstIndex(of: sender)
        //print(country[index!].titleLabel?.text ?? "0")
        //print(index!)
//        //해당 국가로 데이터 변경하는 코드 추가 필요
//        let homeViewController = HomeViewController()
//        homeViewController.selection(index!)
        delegate?.selection(index!)
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
    
}
