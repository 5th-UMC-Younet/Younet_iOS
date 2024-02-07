//
//  OtherUserProfileViewController.swift
//  YounetProject
//
//  Created by 김세아 on 2/6/24.
//

import UIKit

class OtherUserProfileViewController: UIViewController {

    @IBOutlet weak var nickNameProfileImage: UIImageView!
    @IBOutlet weak var nickName: UILabel!
    @IBOutlet weak var nationContainer: UIView!
    @IBOutlet weak var preferNationImage: UIImageView!
    @IBOutlet weak var preferNation: UILabel!
    @IBOutlet weak var nickNameSelfExplain: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    let simpleData = UserDefaults.standard
    let imageData = ImageFileManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getData()
        registerXib()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func getData() {
        nationContainer.layer.borderColor = UIColor.lightGray.cgColor
        nationContainer.layer.borderWidth = 0.25
        simpleData.string(forKey: "preferNation") == nil ? (nationContainer.isHidden = true) : (nationContainer.isHidden = false)

        imageData.getSavedImage(named: "profileImage") != nil ? nickNameProfileImage.image = imageData.getSavedImage(named: "profileImage") : nil
        simpleData.string(forKey: "nickname") != nil ? nickName.text = simpleData.string(forKey: "nickname") : nil
        simpleData.string(forKey: "preferNationImage") != nil ? preferNationImage.image = UIImage(named: simpleData.string(forKey: "preferNationImage")!) : nil
        simpleData.string(forKey: "preferNation") != nil ? preferNation.text = simpleData.string(forKey: "preferNation") : nil
        simpleData.string(forKey: "selfExplain") != nil ? nickNameSelfExplain.text = simpleData.string(forKey: "selfExplain") : nil
    }
    
    private func registerXib() {
        let nibName = UINib(nibName: "FeedCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "FeedCell")
    }
    
    @IBAction func backButtonDidtap(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}

extension OtherUserProfileViewController : UITableViewDelegate, UITableViewDataSource {
    //셀 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 30
    }
    
    //셀 종류
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "FeedCell", for: indexPath) as? FeedCell else {return UITableViewCell()}
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
