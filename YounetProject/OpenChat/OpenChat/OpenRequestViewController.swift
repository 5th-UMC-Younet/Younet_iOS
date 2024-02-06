//
//  OpenRequestViewController.swift
//  YounetProject
//
//  Created by 조혠 on 2/4/24.
//

import UIKit

class OpenRequestViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        registerXib()
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
    }
    private func registerXib() {
        let nibName = UINib(nibName: "ChatRqCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "ChatRqCell")
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
}
extension OpenRequestViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ChatRqCell", for: indexPath) as? ChatRqCell else{return UITableViewCell()}
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}
