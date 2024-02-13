//
//  OpenAlarmViewController.swift
//  YounetProject
//
//  Created by 조혠 on 2/4/24.
//

import UIKit

class OpenAlarmViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        registerXib()
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()

    }
    private func registerXib() {
        let nibName = UINib(nibName: "AlarmCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "AlarmCell")
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func chatRequset(_ sender: Any) {
        guard let rqVC = storyboard?.instantiateViewController(identifier: "OpenRqVC") as? OpenRequestViewController else{
            return
        }
        rqVC.modalPresentationStyle = .fullScreen
        present(rqVC, animated: true, completion: nil)
    }
    
}
extension OpenAlarmViewController : UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "AlarmCell", for: indexPath) as? AlarmCell else{return UITableViewCell()}
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}
