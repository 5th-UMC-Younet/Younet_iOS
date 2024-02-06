//
//  OpenSearchViewController.swift
//  YounetProject
//
//  Created by 조혠 on 2/4/24.
//

import UIKit

class OpenSearchViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var groupLabel: UILabel!
    
    override func viewDidLoad() {
        self.textField.delegate = self
        registerXib()
        tableView.delegate = self
        groupLabel.text = ""
        super.viewDidLoad()
    }
    private func registerXib() {
        let nibName = UINib(nibName: "OpenSearchCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "OpenSearchCell")
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
}
extension OpenSearchViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "OpenSearchCell", for: indexPath) as? OpenSearchCell else{return UITableViewCell()}
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
extension OpenSearchViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textField{
            groupLabel.text = "그룹채팅"
            tableView.dataSource = self
            tableView.reloadData()
        }
        return true
    }
}
