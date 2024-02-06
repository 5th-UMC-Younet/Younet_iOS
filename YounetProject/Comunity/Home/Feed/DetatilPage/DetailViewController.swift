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
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heartButton: UIButton!
    
    @IBAction func sendComent(_ sender: Any) {
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true)
    }
    @IBAction func settingButton(_ sender: Any) {
        guard let postSetVC = storyboard?.instantiateViewController(identifier: "PostSetVC") as? PostSetViewController else{
            return
        }
        postSetVC.modalPresentationStyle = .fullScreen
        present(postSetVC, animated: true, completion: nil)
    }
    @IBAction func isHeart(_ sender: Any) {
        if heartButton.isSelected{
            heartButton.isSelected = false
        }else{
            heartButton.isSelected = true
        }
    }
    override func viewDidLoad() {
        registerXib()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        super.viewDidLoad()
    }
    //셀 등록
    private func registerXib() {
        let nibName = UINib(nibName: "FeedDetailCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "FeedDetailCell")
        let nibName2 = UINib(nibName: "DetailImgCell", bundle: nil)
        collectionView.register(nibName2, forCellWithReuseIdentifier: "DetailImgCell")
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
extension DetailViewController : UICollectionViewDelegate, UICollectionViewDataSource{
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            5
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetailImgCell", for: indexPath) as? DetailImgCell else{
                return UICollectionViewCell()
            }
            return cell
        }
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.height)
        }
}
