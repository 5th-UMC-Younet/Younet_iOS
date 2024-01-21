//
//  MyPageViewController.swift
//  YounetProject
//
//  Created by 김세아 on 1/16/24.
//

import UIKit

class MyPageViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var myPostButton: UIButton!
    @IBOutlet weak var savedPostButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        registerXib()
        buttonSetting()
        
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    private func buttonSetting() {
        view.layer.shouldRasterize = false
        myPostButton.layer.addBorder([.bottom], color: UIColor.black, width: 1)
        savedPostButton.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1)
    }
    
    @IBAction func myPostBtnDidtap(_ sender: UIButton) {
        myPostButton.layer.addBorder([.bottom], color: UIColor.black, width: 1)
        savedPostButton.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1)
        myPostButton.setImage(UIImage(named: "MyPageDefaultSelected"), for: .normal)
        savedPostButton.setImage(UIImage(named: "MyPageSaved"), for: .normal)
    }
    
    @IBAction func savedPostBtnDidtap(_ sender: UIButton) {
        myPostButton.layer.addBorder([.bottom], color: UIColor.lightGray, width: 1)
        savedPostButton.layer.addBorder([.bottom], color: UIColor.black, width: 1)
        myPostButton.setImage(UIImage(named: "MyPageDefault"), for: .normal)
        savedPostButton.setImage(UIImage(named: "MyPageSavedSelected"), for: .normal)
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
        return 12
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

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat){
        for edge in arr_edge {
//            print("check",frame.width)
            let border = CALayer()
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}
