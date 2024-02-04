//
//  MyPageViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/16/24.
//

import UIKit

class MyPageViewController: UIViewController {
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var preferNationLabel: UILabel!
    @IBOutlet weak var selfExplainLabel: UILabel!
    @IBOutlet weak var preferNationImage: UIImageView!
    @IBOutlet weak var nationImgContainer: UIView!
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var scrapButton: UIButton!
    @IBOutlet weak var postLineView: UIView!
    @IBOutlet weak var scrapLineView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        nationImgContainer.layer.borderColor = UIColor.lightGray.cgColor
        nationImgContainer.layer.borderWidth = 0.25
        
        if UserDefaults.standard.string(forKey: "preferNation") == nil {
            nationImgContainer.isHidden = true
        } else {
            nationImgContainer.isHidden = false
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        UserDefaults.standard.string(forKey: "nickname") != nil ? (usernameLabel.text = UserDefaults.standard.string(forKey: "nickname")) : (usernameLabel.text = "Username")
        UserDefaults.standard.string(forKey: "selfExplain") != nil ? (selfExplainLabel.text = UserDefaults.standard.string(forKey: "selfExplain")) : (selfExplainLabel.text = "프로필 소개글")
        UserDefaults.standard.string(forKey: "preferNation") != nil ? (preferNationLabel.text = UserDefaults.standard.string(forKey: "preferNation")) : (preferNationLabel.text = "관심국가")
        UserDefaults.standard.string(forKey: "preferNationImage") != nil ? (preferNationImage.image = UIImage(named: UserDefaults.standard.string(forKey: "preferNationImage")!)) : nil
        if ImageFileManager.shared.getSavedImage(named: "profileImage") != nil {
            profileImage.image = ImageFileManager.shared.getSavedImage(named: "profileImage")
        }
    }
    
    @IBAction func postBtnDidtap(_ sender: UIButton) {
        postButton.setImage(UIImage(named: "PostSelected"), for: .normal)
        postButton.tintColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
        postLineView.backgroundColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
        scrapButton.setImage(UIImage(named: "ScrapDefault"), for: .normal)
        scrapButton.tintColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
        scrapLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
        
    }
    
    @IBAction func scrapBtnDidtap(_ sender: UIButton) {
        postButton.setImage(UIImage(named: "PostDefault"), for: .normal)
        postButton.tintColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
        postLineView.backgroundColor = #colorLiteral(red: 0.8509804606, green: 0.850980401, blue: 0.8509804606, alpha: 1)
        scrapButton.setImage(UIImage(named: "ScrapSelected"), for: .normal)
        scrapButton.tintColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
        scrapLineView.backgroundColor = #colorLiteral(red: 0.1607553065, green: 0.1137417927, blue: 0.5372418165, alpha: 1)
    }
    
    // FeedCell register
    private func registerXib() {
        let nibName = UINib(nibName: "FeedCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "FeedCell")
    }
    
}

extension MyPageViewController : UITableViewDelegate, UITableViewDataSource {
    //셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    //셀 종류
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell else{return UITableViewCell()}
        return cell
    }
    
    //셀 세로 길이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 98
    }
    
    
    //데이터 전달
    /*func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        performSegue(withIdentifier: "DetailVC", sender: indexPath.row)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailVC"{
            let vc = segue.destination as? DetailViewController
            if let index = sender as? Int{
                vc?.num = index
            }
        }
    }*/
}
