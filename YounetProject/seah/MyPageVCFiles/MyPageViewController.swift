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
    
    let simpleData = UserDefaults.standard
    let imageData = ImageFileManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        nationImgContainer.layer.borderColor = UIColor.lightGray.cgColor
        nationImgContainer.layer.borderWidth = 0.25
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
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
    
    private func getData() {
        simpleData.string(forKey: "nickname") != nil ? usernameLabel.text = simpleData.string(forKey: "nickname") : nil
        simpleData.string(forKey: "selfExplain") != nil ? selfExplainLabel.text = simpleData.string(forKey: "selfExplain") : nil
        simpleData.string(forKey: "preferNation") != nil ? preferNationLabel.text = simpleData.string(forKey: "preferNation") : nil
        simpleData.string(forKey: "preferNationImage") != nil ? preferNationImage.image = UIImage(named: simpleData.string(forKey: "preferNationImage")!) : nil
        
        imageData.getSavedImage(named: "profileImage") != nil ? profileImage.image = imageData.getSavedImage(named: "profileImage") : nil

        if simpleData.string(forKey: "preferNation") == nil {
            nationImgContainer.isHidden = true
        } else {
            nationImgContainer.isHidden = false
        }
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
