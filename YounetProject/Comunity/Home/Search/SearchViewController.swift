//
//  SearchViewController.swift
//  YounetProject
//
//  Created by 조혠 on 1/12/24.
//

import UIKit

class SearchViewController: UIViewController {
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    
    
    override func viewDidLoad() {
        self.textField.delegate = self
        cancelButton.layer.cornerRadius = 5
        //셀등록
        registerXib()
        tableView.delegate = self
        super.viewDidLoad()

    }
    //셀 등록
    private func registerXib() {
        let nibName = UINib(nibName: "SearchCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "SearchCell")
    }
    @IBAction func backButton(_ sender: Any) {
        self.dismiss(animated: true,completion: nil)
    }
    @objc func more(_ sender: UIButton){
        guard let searchDetailVC = storyboard?.instantiateViewController(identifier: "SearchDetailVC") as? SearchDetailViewController else{
            return
        }
        searchDetailVC.modalPresentationStyle = .fullScreen
        present(searchDetailVC, animated: true, completion: nil)
    }
}
extension SearchViewController : UITableViewDelegate, UITableViewDataSource {
    //셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    //셀 종류
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "SearchCell", for: indexPath) as? SearchCell else{return UITableViewCell()}
        cell.moreButton.addTarget(self, action: #selector(more(_:)), for: .touchUpInside)
        return cell
    }
    //테이블뷰 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230
    }
}
extension SearchViewController : UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == self.textField{
            tableView.dataSource = self
            tableView.reloadData()
        }
        return true
    }
}
