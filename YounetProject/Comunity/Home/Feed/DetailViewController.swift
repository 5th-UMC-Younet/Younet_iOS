//
//  DetailViewController.swift
//  YounetProject
//
//  Created by 조혠 on 1/12/24.
//

import UIKit

class DetailViewController: UIViewController {
    var num: Int?
    var title1: String?
    var like: Int?
    var comment: Int?
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var heartButton: UIButton!
    @IBOutlet weak var commentField: UITextField!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var nameLabel: UIButton!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var heartLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imgView: UIImageView!
    
    
    @IBAction func sendComment(_ sender: Any) {
        //댓글 전송
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func isHeart(_ sender: Any) {
        if heartButton.isSelected{
            heartButton.isSelected = false
        }else{
            heartButton.isSelected = true
        }
    }
    
    
    override func viewDidLoad() {
        //셀등록
        registerXib()
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
        //초기값
    }
    //셀 등록
    private func registerXib() {
        let nibName = UINib(nibName: "FeedDetailCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "FeedDetailCell")
    }
}
extension DetailViewController : UITableViewDelegate, UITableViewDataSource {
    //셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    //셀 종류
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedDetailCell", for: indexPath) as? FeedDetailCell else{return UITableViewCell()}
        return cell
    }
    //테이블뷰 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 92
    }
}
