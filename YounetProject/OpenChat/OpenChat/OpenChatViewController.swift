//
//  OpenChatViewController.swift
//  YounetProject
//
//  Created by 조혠 on 2/4/24.
//

import UIKit

class OpenChatViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        registerXib()
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
    }
    private func registerXib() {
        let nibName = UINib(nibName: "OpenChatCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "OpenChatCell")
    }
    @IBAction func alarm(_ sender: Any) {
        guard let alarmVC = storyboard?.instantiateViewController(identifier: "OpenAlarmVC") as? OpenAlarmViewController else{
            return
        }
        alarmVC.modalPresentationStyle = .fullScreen
        present(alarmVC, animated: true, completion: nil)
    }
    @IBAction func search(_ sender: Any) {
        guard let searchVC = storyboard?.instantiateViewController(identifier: "OpenSearchVC") as? OpenSearchViewController else{
            return
        }
        searchVC.modalPresentationStyle = .fullScreen
        present(searchVC, animated: true, completion: nil)
    }
}
extension OpenChatViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OpenChatCell", for: indexPath) as? OpenChatCell else{return UITableViewCell()}
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
