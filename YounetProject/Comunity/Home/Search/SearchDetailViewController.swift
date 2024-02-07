//
//  SearchDeatailViewController.swift
//  YounetProject
//
//  Created by 조혠 on 2/6/24.
//

import UIKit

class SearchDetailViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet var sortButton: [UIButton]!
    var index: Int?
    
    override func viewDidLoad() {
        sortButton[0].isSelected = true
        registerXib()
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
        
    }
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    private func registerXib() {
        let nibName = UINib(nibName: "FeedCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "FeedCell")
    }
    @IBAction func sort(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        
        for button in sortButton where button != sender {
            button.isSelected = false
        }
        
        if sender.isSelected {
            index = sortButton.firstIndex(of: sender)
        } else {
            index = nil
        }
    }
}
extension SearchDetailViewController : UITableViewDelegate, UITableViewDataSource {
    //셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12//임시
    }
    
    //셀 종류
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell else{return UITableViewCell()}
        return cell
    }
    //테이블뷰 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}