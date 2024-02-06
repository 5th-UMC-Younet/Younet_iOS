//
//  ChatRequsetViewController.swift
//  YounetProject
//
//  Created by 조혠 on 2/2/24.
//

import UIKit

class ChatRequestViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBAction func back(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    override func viewDidLoad() {
        registerXib()
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
    }
    //셀 등록
    private func registerXib() {
        let nibName = UINib(nibName: "ChatRqCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "ChatRqCell")
    }
}
extension ChatRequestViewController : UITableViewDelegate, UITableViewDataSource {
    //셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5//임시
    }
    
    //셀 종류
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRqCell", for: indexPath) as? ChatRqCell else{return UITableViewCell()}
        return cell
    }
    //테이블뷰 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
}

